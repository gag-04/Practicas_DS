import 'habitacion.dart';

abstract class CadenaHotelera{
  int? id;
  bool? nodoHoja;
  int? idPadre;
  String? tipo;

  get estaOcupada => null; /*Esto no lo tiene Lorena*/

  Map<String,dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nodo_hoja': nodoHoja,
      'id_padre': idPadre
    };
  }

  static CadenaHotelera fromJson(Map<String, dynamic> json) {
    final tipo = json['tipo'] as String?;
    if (tipo!.contains('Habitacion')) {
      return Habitacion.fromJson(json);
    } else if (tipo == 'Hotel') {
      return Hotel.fromJson(json);
    } else {
      // Inferir por otras pistas (p.ej., si tiene 'nombre' es Hotel, si tiene 'capacidad' es Habitacion)
      if (json.containsKey('nombre')) {
        return Hotel.fromJson(json);
      } else if (json.containsKey('capacidad')) {
        return Habitacion.fromJson(json);
      }
      throw Exception('No se pudo determinar el tipo de CadenaHotelera desde el JSON');
    }
  }



}

class Hotel extends CadenaHotelera{
  @override
  int? id;
  @override
  bool? nodoHoja;
  @override
  int? idPadre;
  String nombre;
  int? numHabitaciones;


  Hotel(this.nombre, this.id, this.idPadre, {this.numHabitaciones = 1}){
    nodoHoja = false;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Hotel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;



  @override
  Map<String,dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson['nombre'] = nombre;
    baseJson['tipo'] = 'Hotel';
    baseJson['num_Habitacion'] = numHabitaciones;
    return baseJson;
  }

  factory Hotel.fromJson(Map<String, dynamic> json){
    // Convertir id si viene como String
    int? idValue;
    if (json['id'] != null) {
      idValue = json['id'] is String ? int.parse(json['id']) : json['id'] as int?;
    }

    int? idPadreValue;
    if (json['id_padre'] != null) {
      idPadreValue = json['id_padre'] is String ? int.parse(json['id_padre']) : json['id_padre'] as int?;
    }

    String? nombreValue;
    if (json['nombre'] != null){
      nombreValue = json['nombre'];
    }

    int? numHabitacionValue;
    if (json['num_Habitacion'] != null) {
      numHabitacionValue = json['num_Habitacion'] is String ? int.parse(json['num_Habitacion']) : json['num_Habitacion'] as int?;
    }


    return Hotel(nombreValue ?? '', idValue, idPadreValue, numHabitaciones: numHabitacionValue);
  }


}