import 'package:proyecto_hoteles/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_hoteles/habitacion.dart';

void main() {
  group("Operaciones conexion",(){
    test('Agrega y elimina una habitacion correctamente', () async {
      final nuevaHabitacion = Habitacion(capacidad:3, precio: 30.0,estaOcupada: false);
      int id = await gestor.agregar(nuevaHabitacion);
      expect(await gestor.existe(id), isTrue);
      await gestor.eliminar(id);
      expect(await gestor.existe(id), isFalse);
    });

    test('Modifica una habitacion correctamente', () async {
      final nuevaHabitacion = Habitacion(capacidad:300, precio: 3000.0, estaOcupada: false);
      int id = await gestor.agregar(nuevaHabitacion);
      expect(await gestor.existe(id), isTrue);

      // Debug: verificar estado inicial
      await gestor.cargarHabitacion(id);
      var habitacionInicial = gestor.mishabs.firstWhere((h) => h.id == id);
      print('Estado inicial: ${habitacionInicial.estaOcupada}');

      await gestor.ocupada(id);
      await gestor.cargarHabitacion(id);

      final habitacionModificada = gestor.mishabs.firstWhere((h) => h.id == id);
      print('Estado después de ocupada: ${habitacionModificada.estaOcupada}');

      expect(habitacionModificada.estaOcupada, isTrue);

      // Limpiar
      await gestor.eliminar(id);
    });



});
  }




