import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_hoteles/habitacion.dart';
import 'package:proyecto_hoteles/gestor_habitacion.dart';
import 'package:proyecto_hoteles/hoteles.dart';


void main() {
  group("Operaciones conexion",(){
    final gestor = GestorDeHabitaciones([]);
    Hotel hotelTest = Hotel("test", null, null);
    int id=-1;
    int id_test=100;

    //test('Agrega y elimina una habitacion correctamente', () async {
    //  final nuevaHabitacion = Habitacion(capacidad:3, precio: 30.0,estaOcupada: false);
      //int id = await gestor.agregar(nuevaHabitacion);
    //  expect(await gestor.existe(id), isTrue);
    //  await gestor.eliminar(id);
    //  expect(await gestor.existe(id), isFalse);
   // });

    test('Agregar habitacion correctamente', () async {
      final nuevaHabitacion = Habitacion(estaOcupada: false,idPadre: hotelTest.id);
      id = await gestor.agregar(nuevaHabitacion);
      expect(await gestor.existe(id), isTrue);
    });

    /*
    test('Eliminar una habitacion correctamente', () async {

      final nuevaHabitacion = Habitacion(estaOcupada: false);
      final id = await gestor.agregar(nuevaHabitacion);

      expect(await gestor.existe(id), isTrue);  // Verificas que exista

      await gestor.eliminar(id);

      expect(await gestor.existe(id), isFalse); // Verificas que se eliminó
    });


    test('Modifica una habitacion correctamente', () async {
      final nuevaHabitacion = Habitacion(estaOcupada: false);
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

    });

    test('Cargar habitaciones correctamente',() async{
      final nuevaHabitacion = Habitacion(estaOcupada: false);
      int id = await gestor.agregar(nuevaHabitacion);
      expect(await gestor.existe(id), isTrue);

      // Debug: verificar estado inicial
      await gestor.cargarHabitacion(id);


    });
    */


  });
}


