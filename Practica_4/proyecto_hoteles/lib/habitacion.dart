// hacer un fromJson y un toJson, comn su formato correspondiente

//las llamadas son : http.post, get, delete,put....

import 'package:proyecto_hoteles/hoteles.dart';
import 'package:proyecto_hoteles/logica_decorador.dart';

class Habitacion implements HabitacionGeneral , CadenaHotelera {
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
  bool? estaOcupada;


  Habitacion({this.id, this.capacidad, this.precio,
      this.estaOcupada, this.idPadre}){
    nodoHoja = (idPadre == null);
  }




  @override
  void mostrar(){
    print("Esto es una habiación normal");
  }
  @override
  void decorar(){
    print('Habitación base: capacidad $capacidad, precio \$${precio?.toStringAsFixed(2)}');
  }

  factory Habitacion.fromJson(Map<String, dynamic> json){
    // Convertir id si viene como String
    int? idValue;
    if (json['id'] != null) {
      idValue = json['id'] is String ? int.parse(json['id']) : json['id'] as int?;
    }

    // Convertir capacidad si viene como String
    int? capacidadValue;
    if (json['capacidad'] != null) {
      capacidadValue = json['capacidad'] is String ? int.parse(json['capacidad']) : json['capacidad'] as int?;
    }

    // Convertir precio si viene como String
    double? precioValue;
    if (json['precio'] != null) {
      precioValue = json['precio'] is String ? double.parse(json['precio']) : json['precio'] as double?;
    }

    // Manejo de estaOcupada con valor por defecto y chequeo de tipo
    bool estaOcupadaValue = false; // valor por defecto
    if (json.containsKey('estaOcupada')) {
      final raw = json['estaOcupada'];
      if (raw is String) {
        estaOcupadaValue = raw.toLowerCase() == 'true';
      } else if (raw is bool) {
        estaOcupadaValue = raw;
      }
    }

    int? idPadreValue;
    if (json['idPadre'] != null) {
      idPadreValue = json['idPadre'] is String ? int.parse(json['idPadre']) : json['idPadre'] as int?;
    }


    return Habitacion(
      id: idValue,
      capacidad: capacidadValue,
      precio: precioValue,
      estaOcupada: estaOcupadaValue,
      idPadre: idPadreValue
    );
  }
@override
  Map<String,dynamic> toJson(){
    return{
      if (id != null)
        'id' : id,
        'capacidad' : capacidad,
        'precio' : precio,
        'estaOcupada' : estaOcupada,
        'nodoHoja' : nodoHoja,
        'idPadre' : idPadre
    };
  }



}



