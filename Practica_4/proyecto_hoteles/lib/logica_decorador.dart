// hacer un fromJson y un toJson, comn su formato correspondiente

//las llamadas son : http.post, get, delete,put....
import 'hoteles.dart';

abstract class HabitacionGeneral implements CadenaHotelera{
  int? get capacidad;
  double? get precio;
  bool get estaOcupada;

  set capacidad(int? value);
  set precio(double? value);
  set estaOcupada(bool value);

  void decorar();

  Map<String,dynamic> toJson();
}

abstract class Decorador implements HabitacionGeneral{
  final HabitacionGeneral habitacion;

  Decorador(this.habitacion);

  @override
  int? get capacidad => habitacion.capacidad;

  @override
  double? get precio => habitacion.precio;

  @override
  bool get estaOcupada => habitacion.estaOcupada;

  @override
  Map<String,dynamic> toJson() => habitacion.toJson();

  @override
  bool? get nodoHoja => habitacion.nodoHoja;

  @override
  int? get idPadre => habitacion.idPadre;

  @override
  String? get tipo => habitacion.tipo;

  @override
  set tipo(String? value) {
    habitacion.tipo = value;
  }

}

class Suite extends Decorador {
  Suite(super.habitacion);

  @override
  void decorar() {
    if (!habitacion.tipo!.contains('suite')) {
    print('Decorando como Suite');
    habitacion.capacidad = (habitacion.capacidad ?? 1) + 2;
    habitacion.precio = (habitacion.precio ?? 1.0) + 100;
    habitacion.tipo = (habitacion.tipo ?? 'habitación') + ' suite';
    }
  }

  @override
  int? get capacidad => habitacion.capacidad;

  @override
  double? get precio => habitacion.precio;

  @override
  bool? get nodoHoja => habitacion.nodoHoja;

  @override
  int? get idPadre => habitacion.idPadre;

  @override
  int? get id => habitacion.id;

  @override
  set id(int? id) {
    habitacion.id = id;
  }

  @override
  set idPadre(int? idPadre) {
    habitacion.idPadre = idPadre;
  }

  @override
  set nodoHoja(bool? nodoHoja) {
    habitacion.nodoHoja = nodoHoja;
  }
  @override
  Map<String,dynamic> toJson() {
    final baseJson = habitacion.toJson();
    return baseJson;
  }

  @override
  set capacidad(int? value) {
    habitacion.capacidad = value;
  }

  @override
  set estaOcupada(bool value) {
    habitacion.estaOcupada = value;
  }

  @override
  set precio(double? value) {
    habitacion.precio = value;
  }

}

class HabFamiliar extends Decorador {
  @override
  int? id;

  HabFamiliar(super.habitacion);


  @override
  void decorar() {
    if (!habitacion.tipo!.contains('familiar')) {
      print('Decorando como Familiar');
      habitacion.capacidad = (habitacion.capacidad ?? 1) + 4;
      habitacion.precio = (habitacion.precio ?? 1.0) + 50;
      habitacion.tipo = (habitacion.tipo ?? 'habitación') + ' familiar';
    }
  }



  @override
  set idPadre(int? _idPadre) {
    habitacion.idPadre = _idPadre;
  }

  @override
  set nodoHoja(bool? _nodoHoja) {
    habitacion.nodoHoja = _nodoHoja;
  }

  @override
  Map<String,dynamic> toJson() {
    final baseJson = habitacion.toJson();
    return baseJson;
  }

  @override
  set capacidad(int? value) {
    habitacion.capacidad = value;
  }

  @override
  set estaOcupada(bool value) {
    habitacion.estaOcupada = value;
  }

  @override
  set precio(double? value) {
    habitacion.precio = value;
  }

}