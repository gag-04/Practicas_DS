import 'habitacion.dart';

abstract class CadenaHotelera{
  int? id;
  bool? nodoHoja;
  int? idPadre;

  Map<String,dynamic> toJson() {
    return {
      if (id != null) 'id': id,
        'nodo_hoja': nodoHoja,
        'id_padre': idPadre
    };
  }

  static CadenaHotelera fromJson(Map<String, dynamic> json) {
    if (json.containsKey('capacidad')) {
      return Habitacion.fromJson(json);
    } else if (json.containsKey('nombre')) {
      return Hotel.fromJson(json);
    } else {
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


  Hotel(this.nombre, this.id, this.idPadre);





  @override
  Map<String,dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson['nombre'] = this.nombre;
    baseJson['tipo'] = 'Hotel';
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


    return Hotel(nombreValue ?? '', idValue, idPadreValue);
  }


}