// hacer un fromJson y un toJson, comn su formato correspondiente

//las llamadas son : http.post, get, delete,put....

import 'package:p4_hoteles/logica_decorador.dart';

class Habitacion implements HabitacionGeneral{
  int? id;
  @override
  int? capacidad;
  @override
  double? precio;
  @override
  bool? esta_ocupada;

  Habitacion({this.id, this.capacidad, this.precio,
      this.esta_ocupada});



  @override
  void decorar(){
    print('Habitación base: capacidad $capacidad, precio \$${precio?.toStringAsFixed(2)}');
  }

  factory Habitacion.fromJson(Map<String, dynamic> json){

    return Habitacion(
      id: json['id'] as int?,
      capacidad: json['capacidad'] as int?,
      precio: json['precio'] as double?,
      esta_ocupada: json['esta_ocupada'] as bool?,
    );

  }
@override
  Map<String,dynamic> toJson(){
    return{
      if (id != null)
        'id' : id,
      'capacidad' : capacidad,
      'precio' : precio,
      'esta_ocupada' : esta_ocupada

    };
  }



}



