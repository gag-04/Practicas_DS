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


  Hotel hotel1 = Hotel("Cadena Hotelera 1");
  Hotel hotel2 = Hotel("Cadena Hotelera 2");

  late List<Hotel> hoteles=[];


  @override
  void initState() {
    super.initState();
    _cargarHotelesDesdeApi();
  }

  Future<void> _cargarHotelesDesdeApi() async {
    try {
      await gestor.cargarHoteles();

      if (gestor.mishabs.whereType<Hotel>().isEmpty) {
        // Si no hay hoteles, los agregamos solo UNA vez
        final hotel1 = Hotel("Cadena Hotelera 1");
        final hotel2 = Hotel("Cadena Hotelera 2");

        await gestor.agregar(hotel1);
        await gestor.agregar(hotel2);

        await gestor.cargarHoteles();  // Recarga la lista tras la inserción
      }

      setState(() {
        hoteles = gestor.mishabs.whereType<Hotel>().toList();
        currentHotel = hoteles.isNotEmpty ? hoteles.first : null;
      });
    } catch (e) {
      print('Error cargando hoteles: $e');
    }
  }

  bool cargando = false;
  String mensaje = "";

  Future<void> cargar(id) async {
    if (id == null) return;
    setState(() {
      cargando = true;
      mensaje = "Cargando habitaciones y hoteles...";
    });
    try {
      await gestor.cargarHabitaciones(id);
      setState(() {
        mensaje = "Habitaciones y hoteles cargados correctamente";
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

    var numHabitacionSiguiente = (currentHotel!.numHabitaciones ?? 0) + 1;

    final nueva = Habitacion(
      estaOcupada: false,
      idPadre: currentHotel!.id,
      tipo: "Habitacion",
      numHabitacion: numHabitacionSiguiente
    );

    try {
      await gestor.agregar(nueva);
      setState(() {
        currentHotel!.numHabitaciones = numHabitacionSiguiente;
        gestor.actualizarHotel(currentHotel!);
        mensaje = "Habitación añadida a ${currentHotel!.nombre}";
      });
    } catch (e) {
      setState(() {
        mensaje = "Error al agregar: $e";
      });
    }
  }

  Future<void> agregarHotel(String nombreValue) async {
    if (currentHotel == null ) return;
    final nueva = Hotel(
        nombreValue,idPadre: currentHotel!.id
    );
    try {
      await gestor.agregar(nueva);
      setState(() {
        mensaje = "Hotel añadido a ${currentHotel!.nombre}";
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
        mensaje = "Se ha eliminado correctamente de ${currentHotel!.nombre}";
      });
    } catch (e) {
      setState(() {
        mensaje = "Error al agregar: $e";
      });
    }
  }

  Future<void> marcarOcupada(int id, int numHab) async {
    try {
      await gestor.ocupada(id);
      await gestor.cargarHabitaciones(currentHotel!.id);
      setState(() {
        mensaje = "Habitación $numHab actualizada";
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

  Future<void> decorarComoSuite(int id, int numHab) async {
    try {
      // Buscar la habitación por ID en la lista cargada
      final original = gestor.mishabs.firstWhere((h) => h is Habitacion && h.id == id) as Habitacion;

      if (original.tipo!.contains("suite")){
        return;
      }
      // Crear una nueva instancia decorada
      final decorada = Suite(original);
      decorada.decorar();

      decorada.id = original.id;
      await gestor.actualizar(decorada);

      setState(() {
        mensaje = "Habitación $numHab decorada como Suite";
      });
    } catch (e) {
      setState(() {
        mensaje = "Error al decorar como Suite: $e";
      });
    }
  }
  Future<void> decorarComoFamiliar(int id, int numHabitacion) async {
    try {
      // Buscar la habitación por ID en la lista cargada
      final original = gestor.mishabs.firstWhere((h) => h is Habitacion && h.id == id) as Habitacion;

      if (original.tipo!.contains("familiar")){
        return;
      }
      // Crear una nueva instancia decorada
      final decorada = HabFamiliar(original);
      decorada.decorar();

      decorada.id = original.id;
      await gestor.actualizar(decorada);

      setState(() {
        mensaje = "Habitación $numHabitacion decorada como Familiar";
      });
    } catch (e) {
      setState(() {
        mensaje = "Error al decorar como Suite: $e";
      });
    }
  }

  Future<void> _mostrarDialogoAgregarHotel() async {
    String nombreHotel = "";

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar nuevo hotel'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "Nombre del hotel"),
            onChanged: (value) {
              nombreHotel = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nombreHotel.trim().isNotEmpty) {
                  Navigator.of(context).pop(); // Cierra el diálogo y continúa
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );

    if (nombreHotel.trim().isNotEmpty) {
      await agregarHotel(nombreHotel.trim());
    }
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
                    onPressed: currentHotel == null ? null : (){
                      cargar(currentHotel!.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Fondo distinto para el botón 1
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text("Cargar habitaciones y hoteles",),
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
                    onPressed: currentHotel == null ? null : _mostrarDialogoAgregarHotel,
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
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // Confirmación antes de borrar
                            final confirmar = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar borrado'),
                                content: Text('¿Seguro que quieres borrar el hotel "${h.nombre}"?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Borrar')),
                                ],
                              ),
                            );

                            if (confirmar == true) {
                              try {
                                await gestor.eliminar(h.id!);
                                setState(() {
                                  mensaje = 'Hotel "${h.nombre}" eliminado';
                                  hoteles.removeWhere((hotel) => hotel.id == h.id);
                                  if (currentHotel?.id == h.id) {
                                    currentHotel = hoteles.isNotEmpty ? hoteles.first : null;
                                  }
                                  gestor.mishabs.clear();
                                });
                              } catch (e) {
                                setState(() {
                                  mensaje = 'Error al eliminar hotel: $e';
                                });
                              }
                            }
                          },
                        ),
                        onTap: () {
                          seleccionarHotel(h);
                          cargar(h.id);
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
                          '🛏️ Habitación Nº${h.numHabitacion}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Capacidad: ${h.capacidad}    Precio: \$${h.precio}    Ocupada: ${h.estaOcupada== true ? "Sí" : "No"}'
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min, // Para que el row ocupe el mínimo espacio necesario
                          children: [
                            ElevatedButton(
                              onPressed: currentHotel != null && h.id != null
                                  ? () => decorarComoFamiliar(h.id!, h.numHabitacion!)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber, // Fondo distinto para el botón 2
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              ),
                              child: const Text("Familiar"),
                            ),
                            ElevatedButton(
                              onPressed: currentHotel != null && h.id != null
                                  ? () => decorarComoSuite(h.id!, h.numHabitacion!)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber, // Fondo distinto para el botón 2
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              ),
                              child: const Text("Suite"),
                            ),

                            IconButton(
                              icon: Icon(
                                h.estaOcupada ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: h.estaOcupada ? Colors.green : Colors.grey,
                              ),
                              onPressed: h.id != null ? () => marcarOcupada(h.id!, h.numHabitacion!) : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: h.id == null ? null : () async {
                                final confirmar = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmar borrado'),
                                    content: Text('¿Seguro que quieres borrar la habitación Nº${h.numHabitacion}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Borrar'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmar == true) {
                                  try {
                                    await eliminar(h.id!);
                                    setState(() {
                                      mensaje = 'Habitación Nº${h.numHabitacion} eliminada';
                                      // Opcionalmente quita la habitación de la lista local para actualizar UI
                                      gestor.mishabs.removeWhere((habitacion) => habitacion.id == h.id);
                                    });
                                  } catch (e) {
                                    setState(() {
                                      mensaje = 'Error al eliminar habitación: $e';
                                    });
                                  }
                                }
                              },
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