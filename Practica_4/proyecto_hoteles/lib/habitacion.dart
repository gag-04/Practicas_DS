// hacer un fromJson y un toJson, comn su formato correspondiente

//las llamadas son : http.post, get, delete,put....

import 'hoteles.dart';
import 'logica_decorador.dart';

class Habitacion extends CadenaHotelera implements HabitacionGeneral  {
  //Atributos CadenaHotelera
  int? id;
  bool? nodoHoja;
  int? idPadre;
  String? tipo;


  //Atributos HabitacionGeneral
  @override
  int? capacidad;
  @override
  double? precio;
  @override
  bool estaOcupada;

  int? numHabitacion;


  Habitacion({this.id,
    this.estaOcupada= false, this.idPadre, this.tipo = "Habitacion", this.numHabitacion}){
    nodoHoja = true;
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

    int? numHabitacionValue;
    if (json['num_Habitacion'] != null) {
      numHabitacionValue = json['num_Habitacion'] is String ? int.parse(json['num_Habitacion']) : json['num_Habitacion'] as int?;
    }

    String? tipoValue;
    if (json['tipo'] != null) {
      tipoValue = json['tipo'];
    }

    return Habitacion(
        id: idValue,
        estaOcupada: estaOcupadaValue,
        idPadre: idPadreValue,
        tipo: tipoValue,
        numHabitacion: numHabitacionValue
    );
  }


  @override
  Map<String,dynamic> toJson(){
    final baseJson = super.toJson();
    baseJson['capacidad'] = capacidad;
    baseJson['precio'] = precio;
    baseJson['esta_ocupada'] = estaOcupada;
    baseJson['tipo'] = tipo;
    baseJson['num_Habitacion'] = numHabitacion;
    return baseJson;
  }




}