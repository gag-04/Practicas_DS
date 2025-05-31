import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_hoteles/habitacion.dart';
import 'package:proyecto_hoteles/gestor_habitacion.dart';
import 'package:proyecto_hoteles/hoteles.dart';
import 'package:proyecto_hoteles/logica_decorador.dart';


void main() {
  group("Operaciones conexion",(){
    final gestor = GestorDeHabitaciones([]);
    final hotelTest = Hotel("test");

    // La aplicación debe poder agregar correctamente nuevos hoteles
    test('Agregar hotel correctamente', () async {
      await gestor.agregar(hotelTest);
      expect(await gestor.existe(hotelTest.id!), isTrue);
    });

    // La aplicación debe poder agregar correctamente nuevas habitaciones a los hoteles
    test('Agregar habitacion correctamente', () async {
      final nuevaHabitacion = Habitacion(idPadre: hotelTest.id!);
      await gestor.agregar(nuevaHabitacion);
      expect(await gestor.existe(nuevaHabitacion.id!), isTrue);
    });

    // La aplicación debe poder eliminar correctamente habitaciones de los hoteles
    test('Eliminar una habitacion correctamente', () async {
      final nuevaHabitacion = Habitacion(idPadre: hotelTest.id!);

      await gestor.agregar(nuevaHabitacion);

      expect(await gestor.existe(nuevaHabitacion.id!), isTrue);  // Verificas que exista

      await gestor.eliminar(nuevaHabitacion.id!);

      expect(await gestor.existe(nuevaHabitacion.id!), isFalse); // Verificas que se eliminó
    });

    // La aplicación debe poder eliminar correctamente hoteles, eliminando con ello su contenido
    test('Eliminar un hotel y todas sus habitaciones', () async {
      final nuevoHotel =Hotel("test", idPadre: hotelTest.id );

      await gestor.agregar(nuevoHotel);

      final habitacionHija1 = Habitacion(idPadre: nuevoHotel.id!);
      final habitacionHija2 = Habitacion(idPadre: nuevoHotel.id!);
      final habitacionHija3 = Habitacion(idPadre: nuevoHotel.id!);

      await gestor.agregar(habitacionHija1);
      await gestor.agregar(habitacionHija2);
      await gestor.agregar(habitacionHija3);

      expect(await gestor.existe(nuevoHotel.id!), isTrue); // Verificas que se eliminó

      expect(await gestor.existe(habitacionHija1.id!), isTrue);
      expect(await gestor.existe(habitacionHija2.id!), isTrue);
      expect(await gestor.existe(habitacionHija3.id!), isTrue);


      await gestor.eliminar(nuevoHotel.id!);

      expect(await gestor.existe(nuevoHotel.id!), isFalse); // Verificas que se eliminó


      expect(await gestor.existe(habitacionHija1.id!), isFalse);
      expect(await gestor.existe(habitacionHija2.id!), isFalse);
      expect(await gestor.existe(habitacionHija3.id!), isFalse);

    });

    //La aplicación debe poder modificar una habitación marcándola de no ocupada a ocupada y viceversa
    test('Modifica el estado de una habitacion correctamente', () async {
      final nuevaHabitacion = Habitacion(idPadre: hotelTest.id!);
      await gestor.agregar(nuevaHabitacion);
      expect(await gestor.existe(nuevaHabitacion.id!), isTrue);

      // Debug: verificar estado inicial
      await gestor.cargarHabitacion(nuevaHabitacion.id!);

      var habitacionInicial = gestor.mishabs.firstWhere((h) => h.id == nuevaHabitacion.id);
      expect(habitacionInicial.estaOcupada, isFalse);

      await gestor.ocupada(nuevaHabitacion.id!);
      await gestor.cargarHabitacion(nuevaHabitacion.id!);

      final habitacionModificada = gestor.mishabs.firstWhere((h) => h.id == nuevaHabitacion.id);

      expect(habitacionModificada.estaOcupada, isTrue);

      await gestor.ocupada(nuevaHabitacion.id!);
      await gestor.cargarHabitacion(nuevaHabitacion.id!);

      final segundaHabitacionModificada = gestor.mishabs.firstWhere((h) => h.id == nuevaHabitacion.id);

      expect(segundaHabitacionModificada.estaOcupada, isFalse);

      // Limpiar
    });

    //La aplicación debe poder cargar las habitaciones de un hotel desde la base de datos
    test('Cargar habitaciones de un hotel correctamente',() async{
      final nuevoHotel =Hotel("test", idPadre:hotelTest.id );

      await gestor.agregar(nuevoHotel);

      final habitacionHija1 = Habitacion(idPadre: nuevoHotel.id!);
      final habitacionHija2 = Habitacion(idPadre: nuevoHotel.id!);
      final habitacionHija3 = Habitacion(idPadre: nuevoHotel.id!);

      await gestor.agregar(habitacionHija1);
      await gestor.agregar(habitacionHija2);
      await gestor.agregar(habitacionHija3);

      expect(await gestor.existe(nuevoHotel.id!), isTrue); // Verificas que se eliminó

      expect(await gestor.existe(habitacionHija1.id!), isTrue);
      expect(await gestor.existe(habitacionHija2.id!), isTrue);
      expect(await gestor.existe(habitacionHija3.id!), isTrue);


      final habitaciones = await gestor.cargarHabitaciones(nuevoHotel.id);

      expect(habitaciones.length, 3 );
      expect(habitaciones.contains(habitacionHija1), isTrue);
      expect(habitaciones.contains(habitacionHija2), isTrue);
      expect(habitaciones.contains(habitacionHija3), isTrue);




    });

  });



  group("Test Extras, Probando clases",(){
    //La habitación por defecto se crea sin estar ocupada.
    test('Habitación por defecto esta libre',(){
      final habitacion = Habitacion();

      expect(habitacion.estaOcupada, isFalse);
    });

    //El hotel por defecto no tiene habitaciones creadas
    test('Hotel por defecto tiene 0 habitaciones',(){
      final hotel = Hotel("Test");

      expect(hotel.numHabitaciones, 0);
    });

    //Solo es posible decorar una habitacion como suite una vez
    test("Decorar como suite solo una vez", (){
      final habitacion = Habitacion();


      final habitacionSuite = Suite(habitacion);

      habitacionSuite.decorar();

      expect(habitacionSuite.habitacion.tipo!.contains("suite"), isTrue);

      final habitacionSuiteDoble = Suite(habitacionSuite);

      habitacionSuiteDoble.decorar();

      expect(habitacionSuiteDoble.habitacion.tipo!.contains("suite suite"), isFalse);

    });


    test("Decorar como familiar solo una vez", (){
      final habitacion = Habitacion();


      final habitacionFamiliar = HabFamiliar(habitacion);

      habitacionFamiliar.decorar();

      expect(habitacionFamiliar.habitacion.tipo!.contains("familiar"), isTrue);

      final habitacionFamiliarDoble = HabFamiliar(habitacionFamiliar);

      habitacionFamiliarDoble.decorar();

      expect(habitacionFamiliarDoble.habitacion.tipo!.contains("familiar familiar"), isFalse);

    });


    test("Decorar como suite y familiar", (){
      final habitacion = Habitacion();


      final habitacionFamiliar = HabFamiliar(habitacion);

      habitacionFamiliar.decorar();

      expect(habitacionFamiliar.habitacion.tipo!.contains("familiar"), isTrue);

      final habitacionFamiliarSuite = Suite(habitacionFamiliar);

      habitacionFamiliarSuite.decorar();

      expect(habitacionFamiliarSuite.habitacion.tipo!.contains("familiar suite"), isTrue);

    });

    //La habitación se crea correctamnete con precio inicial a 50 y capacidad a 2 personas
    test("Habitacion por defecto se crea con precio 50 y 2 de capacidad",(){
      final habitacion = Habitacion();

      expect(habitacion.precio,50);
      expect(habitacion.capacidad,2);

      final habitacionDecorada = Suite(habitacion);
      habitacionDecorada.decorar();

      expect(habitacionDecorada.precio,150);
      expect(habitacionDecorada.capacidad,4);

      final otraHabitacionDecorada = HabFamiliar(habitacionDecorada);
      otraHabitacionDecorada.decorar();

      expect(otraHabitacionDecorada.precio,200);
      expect(otraHabitacionDecorada.capacidad,8);

    });


  });

}


