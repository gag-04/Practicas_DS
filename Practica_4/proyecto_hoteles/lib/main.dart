import 'package:flutter/material.dart';
import 'habitacion.dart';
import 'gestor_habitacion.dart';
import 'hoteles.dart';
import 'logica_decorador.dart';

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
  Hotel? currentHotel;


  Hotel hotel1 = Hotel("Cadena Hotelera 1", null, null);
  Hotel hotel2 = Hotel("Cadena Hotelera 2", null, null);

  late List<Hotel> hoteles;


  @override
  void initState() {
    super.initState();
    hoteles = [hotel1, hotel2];
    _agregarHoteles();
    currentHotel = hoteles.first;
  }

  Future<void> _agregarHoteles() async {
    await gestor.agregar(hotel1);
    await gestor.agregar(hotel2);
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

  Future<void> agregarHabitacion() async {
    if (currentHotel == null) return;
    final nueva = Habitacion(
      estaOcupada: false,
      idPadre: currentHotel!.id,
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

  Future<void> agregarHotel(String nombreValue) async {
    if (currentHotel == null) return;
    final nueva = Hotel(
      nombreValue, null, currentHotel!.id
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


  Future<void> eliminar(id) async {
    if (currentHotel == null) return;

    try {
      await gestor.eliminar(id);
      setState(() {
        mensaje = "Habitación eliminada de ${currentHotel!.nombre}";
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
      appBar: AppBar(
        // Para que no opaque tu fondo
        elevation: 0, // Sin sombra que interfiera
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent, // Color del fondo de toda la barra
          ),
        ),
        title: Container(
          decoration: BoxDecoration(
             // Fondo gris claro del título
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: const Text(
            "Gestión de Habitaciones",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4.0,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Escoge el hotel donde quieres realizar la gestión:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
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
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: currentHotel == null ? null : cargar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Fondo distinto para el botón 1
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text("Cargar habitaciones",),
                  ),
                  const SizedBox(height: 20), // Separación de 20 px
                  ElevatedButton(
                    onPressed: currentHotel == null ? null : agregarHabitacion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange, // Fondo distinto para el botón 2
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text("Agregar nueva habitación"),
                  ),
                  const SizedBox(height: 20), // Separación de 20 px
                  ElevatedButton(
                    onPressed: currentHotel == null ? null : () => agregarHotel("Nuevo"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange, // Fondo distinto para el botón 2
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text("Agregar nuevo hotel"),
                  ),
                ],
              ),
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

                  if (h is Hotel) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.orangeAccent),
                      ),
                      child: ListTile(
                        title: Text('🏨 Hotel: ${h.nombre}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        onTap: () {
                          // Aquí podrías implementar navegación a los hijos del hotel si se desea
                        },
                      ),
                    );
                  } else if (h is Habitacion) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.blueAccent),
                      ),
                      child: ListTile(
                        title: Text(
                          '🛏️ Habitación Nº${h.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Capacidad: \$${h.capacidad}    Precio: \$${h.precio}    Ocupada: ${h.estaOcupada== true ? "Sí" : "No"}'
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min, // Para que el row ocupe el mínimo espacio necesario
                          children: [
                            IconButton(
                              icon: Icon(
                                h.estaOcupada ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: h.estaOcupada ? Colors.green : Colors.grey,
                              ),
                              onPressed: h.id != null ? () => marcarOcupada(h.id!) : null,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: h.id != null ? () {
                                eliminar(h.id!);
                              } : null,
                            ),
                          ],
                        ),

                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
