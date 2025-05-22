import 'dart:convert';
import 'package:http/http.dart' as http;
import 'habitacion.dart';

class GestorDeHabitaciones {
  List<Habitacion> mishabs = [];
  final String apiUrl = "http://localhost:3000/habitaciones";

  GestorDeHabitaciones(this.mishabs);


  Future<Habitacion> cargarHabitacion(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final hab = Habitacion.fromJson(jsonMap);

      mishabs.removeWhere((h) => h.id == id); // Evita duplicados
      mishabs.add(hab);
      return hab;
    } else {
      throw Exception('Failed to load habitacion with id $id');
    }
  }

  Future<List<Habitacion>> cargarHabitaciones(int? idPadre) async {
    String url = '$apiUrl?idPadre=$idPadre';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> habsJson = json.decode(response.body);

      mishabs.clear();
      mishabs.addAll(habsJson.map((json) => Habitacion.fromJson(json)).toList());
      return mishabs;
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
    final response = await http.get(
      Uri.parse('$apiUrl/$id'),
    );

    return (response.statusCode == 200);
  }

  Future<void> eliminar(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id')
    );
    if (response.statusCode == 200) {
      mishabs.removeWhere((t) => t.id == id);
    } else {
      throw Exception('Failed to delete task');
    }
  }

  Future<void> ocupada(int id) async {
    await cargarHabitacion(id);
    final hab = mishabs.firstWhere((h) => h.id == id);
    bool nuevoEstadoCompletado = !(hab.estaOcupada ?? false);

    final payload = {
      'habitacion': {
        'estaOcupada': nuevoEstadoCompletado,
      }
    };

    final response = await http.patch(
      Uri.parse('$apiUrl/$id'),
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
