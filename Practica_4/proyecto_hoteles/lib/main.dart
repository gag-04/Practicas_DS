import 'package:flutter/material.dart';
import 'habitacion.dart';
import 'gestor_habitacion.dart';
import 'hoteles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Habitaciones',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HabitacionesHttpDemo(),
    );
  }
}

class HabitacionesHttpDemo extends StatefulWidget {
  const HabitacionesHttpDemo({super.key});

  @override
  State<HabitacionesHttpDemo> createState() => _HabitacionesHttpDemoState();
}

class _HabitacionesHttpDemoState extends State<HabitacionesHttpDemo> {
  final gestor = GestorDeHabitaciones([]);
  Hotel? currentHotel = null;

  Hotel hotel1 = Hotel("Hotel 1");
  Hotel hotel2 = Hotel("Hotel 2");
  Hotel admin = Hotel("Admin");

  late List<Hotel> hoteles;

  @override
  void initState() {
    super.initState();
    hoteles = [hotel1, hotel2, admin];
  }

  bool cargando = false;
  String mensaje = "";

  Future<void> cargar() async {
    setState(() {
      cargando = true;
      mensaje = "Cargando habitaciones...";
    });
    try {
      await gestor.cargarHabs(1, currentHotel?.id); // Cambia el ID si es necesario
      setState(() {
        mensaje = "Habitaciones cargadas correctamente";
      });
    } catch (e) {
      setState(() {
        mensaje = "Error al cargar: $e";
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  Future<void> agregar() async {
    final nueva = Habitacion(
      capacidad: 3,
      precio: 80.0,
      estaOcupada: false,
    );
    try {
      gestor.agregar(nueva);
      debugPrint("Habitaciones: ${gestor.mishabs.length}");
      setState(() {
        mensaje = "Habitación añadida";
      });
    } catch (e) {
      setState(() {
        mensaje = "Error al agregar";
      });
    }
  }

  Future<void> marcarOcupada(Habitacion h) async {
    try {
      await gestor.ocupada(h);
      setState(() {
        mensaje = "Habitación ${h.id} actualizada";
      });
    } catch (e) {
      setState(() {
        mensaje = "Error al actualizar: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Habitaciones")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(onPressed: cargar, child: const Text("Cargar habitaciones")),
            ElevatedButton(onPressed: agregar, child: const Text("Agregar nueva habitación")),
            const SizedBox(height: 20),
            Text(mensaje),
            if (cargando) const CircularProgressIndicator(),
            Expanded(
              child: ListView.builder(
                itemCount: gestor.mishabs.length,
                itemBuilder: (context, index) {
                  final h = gestor.mishabs[index];
                  return ListTile(
                    title: Text('ID ${h.id} - Capacidad: ${h.capacidad}'),
                    subtitle: Text('Precio: \$${h.precio} - Ocupada: ${h.estaOcupada}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: () => marcarOcupada(h),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}