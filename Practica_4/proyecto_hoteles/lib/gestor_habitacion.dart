import 'dart:convert';
import 'package:http/http.dart' as http;
import 'logica_decorador.dart';
import 'habitacion.dart';
import 'hoteles.dart';

class GestorDeHabitaciones {
  List<CadenaHotelera> mishabs = [];
  final String apiUrl;

  GestorDeHabitaciones(this.mishabs, {this.apiUrl = 'http://localhost:3000'});


  Future<CadenaHotelera> cargarHabitacion(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    print('Respuesta: ${response.body}');
    print('Código de estado: ${response.statusCode}');
    if (response.statusCode == 200) {

      final jsonMap = json.decode(response.body);

      final hab = CadenaHotelera.fromJson(jsonMap);

      mishabs.removeWhere((h) => h.id == id); // Evita duplicados
      mishabs.add(hab);
      return hab;
    } else {
      throw Exception('Failed to load habitacion with id $id');
    }
  }

  Future<List<CadenaHotelera>> cargarHabitaciones(int? idPadre) async {
    String url = '$apiUrl?idPadre=$idPadre';
    print('Cargando habitaciones con URL: $url');

    final response = await http.get(Uri.parse(url));
    print('Respuesta: ${response.body}');
    print('Código de estado: ${response.statusCode}');
    if (response.statusCode == 200) {
      List<dynamic> habsJson = json.decode(response.body);

      mishabs.clear();
      mishabs.addAll(
        habsJson
            .map((json) => CadenaHotelera.fromJson(json))
            .where((item) => item.idPadre == idPadre)
            .toList(),
      );
      return mishabs;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<int> agregar(CadenaHotelera hab) async {
    final url = "http://localhost:3000/habitaciones";

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'habitacion': hab.toJson()}),  // Aquí la diferencia
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      final nuevaInstancia = CadenaHotelera.fromJson(json);
      mishabs.add(nuevaInstancia);
      hab.id = nuevaInstancia.id;
      return nuevaInstancia.id!;
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
  Future<bool> borrarHotel(int idHotel) async {
    final url = '$apiUrl/$idHotel';  // Asegúrate que esta es la URL correcta para borrar
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Hotel ${idHotel} borrado correctamente');
      return true;
    } else {
      print('Error al borrar hotel: ${response.statusCode}');
      return false;
    }
  }

  Future<void> ocupada(int id) async {
    await cargarHabitacion(id);
    final hab = mishabs.firstWhere((h) => h.id == id);

    if (hab is Habitacion){
      bool nuevoEstadoCompletado = false;

      if (hab.estaOcupada == false) {
        nuevoEstadoCompletado = true;
      }
      //  bool nuevoEstadoCompletado =
      // !(hab.estaOcupada ?? false);

      final payload = {
        'habitacion': {
          'esta_ocupada': nuevoEstadoCompletado,
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




  Future<void> actualizar(HabitacionGeneral habitacion) async {
    final url = Uri.parse('http://localhost:3000/habitaciones/${habitacion.id}');
    final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'habitacion': habitacion.toJson()})
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar habitación ${habitacion.id}');
    }
  }

  Future<void> cargarHoteles() async {
    final url = 'http://localhost:3000/habitaciones?tipo=Hotel';
    final response = await http.get(Uri.parse(url));
    print('Respuesta: ${response.body}');
    print('Código de estado: ${response.statusCode}');
    if (response.statusCode == 200) {
      List<dynamic> hotelesJson = json.decode(response.body);

      // Elimina los hoteles antiguos para no duplicar
      mishabs.removeWhere((h) => h is Hotel);

      // Añade solo los hoteles (filtrando por tipo == 'Hotel')
      for (var jsonHotel in hotelesJson) {
        if (jsonHotel['tipo'] == 'Hotel') {
          mishabs.add(Hotel.fromJson(jsonHotel));
        }
      }
    } else {
      throw Exception('Failed to load hoteles');
    }
  }
}