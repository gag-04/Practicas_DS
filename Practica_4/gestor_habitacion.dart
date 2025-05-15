import 'dart:convert';
import 'package:http/http.dart' as http;
import 'habitacion.dart';

class GestorDeHabitaciones {
  List<Habitacion> mishabs = [];
  final String apiUrl = "http://localhost:3000/tareas";

  GestorDeHabitaciones(this.mishabs);


  Future<void> cargarHabs(int id) async {
    final response = await http.get(Uri.parse('$apiUrl?id=$id'));
    if (response.statusCode == 200) {
      List<dynamic> HabsJson = json.decode(response.body);

      mishabs.clear();
      mishabs.addAll(HabsJson.map((json) => Habitacion.fromJson(json)).toList());
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> agregar(Habitacion hab) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(hab.toJson()),
    );
    if (response.statusCode == 201) {
      mishabs.add(Habitacion.fromJson(json.decode(response.body)));
    } else {
      throw Exception('Failed to add task: ${response.body}');
    }
  }

  Future<void> eliminar(Habitacion hab) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/${hab.id}'),
    );
    if (response.statusCode == 200) {
      mishabs.removeWhere((t) => t.id == hab.id);
    } else {
      throw Exception('Failed to delete task');
    }
  }

  Future<void> ocupada(Habitacion hab) async {
    bool nuevoEstadoCompletado = !(hab.esta_ocupada ?? false);

    final response = await http.patch(
      Uri.parse('$apiUrl/${hab.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'esta_ocupada': nuevoEstadoCompletado,
      }),
    );

    if (response.statusCode == 200) {
      hab.esta_ocupada = nuevoEstadoCompletado;
    } else {
      throw Exception('Failed to update task');
    }
  }
}
