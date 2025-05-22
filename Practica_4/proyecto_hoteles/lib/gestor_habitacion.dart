import 'dart:convert';
import 'package:http/http.dart' as http;
import 'habitacion.dart';

class GestorDeHabitaciones {
  List<Habitacion> mishabs = [];
  final String apiUrl = "http://localhost:3000/habitaciones";

  GestorDeHabitaciones(this.mishabs);


  Future<void> cargarHabs(int id, int? idPadre) async {
    String url = 'apiUrl?id=$id';
    if (idPadre != null){
      url += '&idPadre=$idPadre';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> habsJson = json.decode(response.body);

      mishabs.clear();
      mishabs.addAll(habsJson.map((json) => Habitacion.fromJson(json)).toList());
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<int> agregar(Habitacion hab) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'habitacion': hab.toJson()}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      final creada = Habitacion.fromJson(json);
      mishabs.add(creada);
      return creada.id!;
    } else {
      throw Exception('Failed to add task: ${response.statusCode} - ${response.body}');
    }
  }

  Future<bool> existe(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );

    return (response.statusCode == 200);
  }

  Future<void> eliminar(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );
    if (response.statusCode == 200) {
      mishabs.removeWhere((t) => t.id == id);
    } else {
      throw Exception('Failed to delete task');
    }
  }

  Future<void> ocupada(Habitacion hab) async {
    bool nuevoEstadoCompletado = !(hab.estaOcupada ?? false);

    // Aquí también deberías anidar bajo 'habitacion' para consistencia
    final payload = {
      'habitacion': {
        'estaOcupada': nuevoEstadoCompletado,
      }
    };

    final response = await http.patch(
      Uri.parse('$apiUrl/${hab.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      hab.estaOcupada = nuevoEstadoCompletado;
    } else {
      throw Exception('Failed to update task');
    }
  }
}
