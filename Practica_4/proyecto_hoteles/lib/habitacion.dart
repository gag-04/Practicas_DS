// hacer un fromJson y un toJson, comn su formato correspondiente

//las llamadas son : http.post, get, delete,put....

import 'hoteles.dart';
import 'logica_decorador.dart';

class Habitacion extends CadenaHotelera implements HabitacionGeneral  {
  //Atributos CadenaHotelera
  @override
  int? id;
  @override
  bool? nodoHoja;
  @override
  int? idPadre;

  //Atributos HabitacionGeneral
  @override
  int? capacidad;
  @override
  double? precio;
  @override
  bool estaOcupada;


  Habitacion({this.id,
    this.estaOcupada= false, this.idPadre}){
    nodoHoja = (idPadre == null);
    precio = 50;
    capacidad = 2;
  }




  @override
  void decorar(){
    print('Habitación base: capacidad $capacidad, precio \$${precio?.toStringAsFixed(2)}');
  }

  factory Habitacion.fromJson(Map<String, dynamic> json){
    int? idValue;
    if (json['id'] != null) {
      idValue = json['id'] is String ? int.parse(json['id']) : json['id'] as int?;
    }

    bool estaOcupadaValue = false;
    if (json['esta_ocupada'] != null) {
      if (json['esta_ocupada'] is String) {
        estaOcupadaValue = json['esta_ocupada'].toLowerCase() == 'true';
      } else {
        estaOcupadaValue = json['esta_ocupada'] as bool;
      }
    }

    int? idPadreValue;
    if (json['id_padre'] != null) {
      idPadreValue = json['id_padre'] is String ? int.parse(json['id_padre']) : json['id_padre'] as int?;
    }

    return Habitacion(
        id: idValue,
        estaOcupada: estaOcupadaValue,
        idPadre: idPadreValue
    );
  }


  @override
  Map<String,dynamic> toJson(){
    final baseJson = super.toJson();
    baseJson['capacidad'] = capacidad;
    baseJson['precio'] = precio;
    baseJson['esta_ocupada'] = estaOcupada;
    baseJson['tipo'] = 'Habitacion';
    return baseJson;
  }




}