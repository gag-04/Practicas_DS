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


}

class Suite extends Decorador {
  Suite(super.habitacion);

  @override
  void decorar() {
    print('Decorando como Suite');
    habitacion.capacidad = (habitacion.capacidad ?? 1) + 2;
    habitacion.precio = (habitacion.precio ?? 1.0) + 100;
  }

  @override
  int? get capacidad => 6;

  @override
  double? get precio => habitacion.precio != null ? habitacion.precio! * 1.8 : null;

  @override
  bool? get nodoHoja => habitacion.nodoHoja;

  @override
  int? get idPadre => habitacion.idPadre;

  @override
  int? get id => habitacion.id;

  @override
  set id(int? _id) {
    habitacion.id = _id;
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
    baseJson['tipo'] = 'suite';
    return baseJson;
  }

  @override
  set capacidad(int? value) {
    this.habitacion.capacidad = value;
  }

  @override
  set estaOcupada(bool value) {
    this.habitacion.estaOcupada = value;
  }

  @override
  set precio(double? value) {
    this.habitacion.precio = value;
  }
}

class HabFamiliar extends Decorador {
  HabFamiliar(super.habitacion);

  @override
  void decorar() {
    print('Decorando como Familiar');
    habitacion.capacidad = (habitacion.capacidad ?? 1) + 4;
    habitacion.precio = (habitacion.precio ?? 1.0) + 50;
  }

  @override
  int? id;

  @override
  set idPadre(int? _idPadre) {
    this.habitacion.idPadre = _idPadre;
  }

  @override
  set nodoHoja(bool? _nodoHoja) {
    habitacion.nodoHoja = _nodoHoja;
  }
  @override
  Map<String,dynamic> toJson() {
    final baseJson = habitacion.toJson();
    baseJson['tipo'] = 'familiar';
    return baseJson;
  }

  @override
  set capacidad(int? value) {
    this.habitacion.capacidad = value;
  }

  @override
  set estaOcupada(bool value) {
    this.habitacion.estaOcupada = value;
  }

  @override
  set precio(double? value) {
    habitacion.precio = value;
  }
}