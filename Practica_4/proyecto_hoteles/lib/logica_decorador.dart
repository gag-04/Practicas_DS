// hacer un fromJson y un toJson, comn su formato correspondiente

//las llamadas son : http.post, get, delete,put....
import 'package:proyecto_hoteles/hoteles.dart';

abstract class HabitacionGeneral implements CadenaHotelera{

  void decorar();
  int? get capacidad;
  double? get precio;
  bool? get estaOcupada;

  @override
  void mostrar();

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
  bool? get estaOcupada => habitacion.estaOcupada;

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
    print('→ Capacidad actualizada a 6 personas');
    print('→ Precio incrementado en un 80%');

    print('Suite final: capacidad 6, precio \$${(precio! * 1.8).toStringAsFixed(2)}');

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
  void mostrar(){
    print("Es una suite");
  }

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
}

class HabFamiliar extends Decorador {
  HabFamiliar(super.habitacion);

  @override
  void decorar() {
    print('Decorando como Habitación Familiar');
    print('→ Capacidad limitada a 4 personas');
    print('→ Precio reducido un 30%');

    print('Familiar final: capacidad 4, precio \$${(precio! * 0.7).toStringAsFixed(2)}');
  }

  @override
  int? get capacidad => 4;

  @override
  double? get precio => habitacion.precio != null ? habitacion.precio! * 0.7 : null;

  @override
  void mostrar(){
    print("Es una habitación familiar");
  }

  @override
  int? id;

  @override
  set idPadre(int? _idPadre) {
    habitacion.idPadre = _idPadre;
  }

  @override
  set nodoHoja(bool? _nodoHoja) {
    habitacion.nodoHoja = _nodoHoja;
  }
}





