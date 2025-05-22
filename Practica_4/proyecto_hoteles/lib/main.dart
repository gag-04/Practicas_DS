import 'package:flutter/material.dart';
import 'habitacion.dart';
import 'gestor_habitacion.dart';
import 'hoteles.dart';

final gestor = GestorDeHabitaciones([]);

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
  Hotel? currentHotel;

  Hotel hotel1 = Hotel("Hotel 1");
  Hotel hotel2 = Hotel("Hotel 2");
  Hotel admin = Hotel("Admin");

  late List<Hotel> hoteles;

  @override
  void initState() {
    super.initState();
    hoteles = [hotel1, hotel2, admin];
    currentHotel = hoteles.first;
  }

  bool cargando = false;
  String mensaje = "";

  Future<void> cargar() async {
    if (currentHotel == null) return;
    setState(() {
      cargando = true;
      mensaje = "Cargando habitaciones...";
    });
    try {
      await gestor.cargarHabitaciones(currentHotel!.id);
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
    if (currentHotel == null) return;
    final nueva = Habitacion(
      capacidad: 3,
      precio: 80.0,
      estaOcupada: false,
      id: currentHotel!.id,
    );
    try {
      await gestor.agregar(nueva);
      setState(() {
        mensaje = "Habitación añadida a ${currentHotel!.nombre}";
      });
    } catch (e) {
      setState(() {
        mensaje = "Error al agregar: $e";
      });
    }
  }

  Future<void> marcarOcupada(int id) async {
    try {
      await gestor.ocupada(id);
      setState(() {
        mensaje = "Habitación $id actualizada";
      });
    } catch (e) {
      setState(() {
        mensaje = "Error al actualizar: $e";
      });
    }
  }

  void seleccionarHotel(Hotel? hotel) {
    setState(() {
      currentHotel = hotel;
      gestor.mishabs.clear();
      mensaje = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Habitaciones")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Escoge el hotel donde quieres realizar la gestión:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue[50],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Hotel>(
                  value: currentHotel,
                  hint: const Text("Selecciona un hotel"),
                  onChanged: seleccionarHotel,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  dropdownColor: Colors.white,
                  items: hoteles.map((hotel) {
                    return DropdownMenuItem<Hotel>(
                      value: hotel,
                      child: Text(
                        hotel.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: currentHotel == null ? null : cargar,
              child: const Text("Cargar habitaciones"),
            ),
            ElevatedButton(
              onPressed: currentHotel == null ? null : agregar,
              child: const Text("Agregar nueva habitación"),
            ),
            const SizedBox(height: 20),
            Text(
              mensaje,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            if (cargando) const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: gestor.mishabs.length,
                itemBuilder: (context, index) {
                  final h = gestor.mishabs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.blueAccent),
                    ),
                    child: ListTile(
                      title: Text(
                        'ID ${h.id} - Capacidad: ${h.capacidad}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          'Precio: \$${h.precio} - Ocupada: ${h.estaOcupada== true ? "Sí" : "No"}'),
                      trailing: IconButton(
                        icon: Icon(
                          h.estaOcupada == true ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: h.estaOcupada == true? Colors.green : Colors.grey,
                        ),
                        onPressed: () => marcarOcupada(h.id!),
                      ),
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
