import 'package:proyecto_hoteles/gestor_habitacion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_hoteles/habitacion.dart';

void main() {
  group("Operaciones conexion",(){
    final gestor = GestorDeHabitaciones([]);

    test('Agrega y elimina una habitacion correctamente', () async {
      final nuevaHabitacion = Habitacion(capacidad:3, precio: 30.0,estaOcupada: false);
      int id = await gestor.agregar(nuevaHabitacion);
      expect(await gestor.existe(id), isTrue);
      await gestor.eliminar(id);
      expect(await gestor.existe(id), isFalse);
    });

    test('Modifica una habitacion correctamente', () async {
      final nuevaHabitacion = Habitacion(capacidad:3, precio: 30.0,estaOcupada: false);
      int id = await gestor.agregar(nuevaHabitacion);
      expect(await gestor.existe(id), isTrue);
      await gestor.ocupada(id);
      await gestor.cargarHabitacion(id);
      final habitacionModificada = gestor.mishabs.firstWhere((h) => h.id == id);
      expect(habitacionModificada.estaOcupada, isTrue);
    });



});
  }




