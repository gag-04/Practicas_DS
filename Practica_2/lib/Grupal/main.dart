import 'package:flutter/material.dart';
import 'package:practica_2/Grupal/client.dart';
import 'package:practica_2/Grupal/target.dart';
import 'package:practica_2/Grupal/filters.dart';
import 'package:practica_2/Grupal/filterManager.dart';
import 'package:practica_2/Grupal/filterChain.dart';
import 'package:practica_2/Grupal/BD.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 2 DS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
      ),
      home: const MyHomePage(title: 'Filtros de Intercepción'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Client client;

  @override
  void initState() {
    super.initState();

    Target target = Target();
    FilterManager managerCorreo = FilterManager(target);
    managerCorreo.addFilter(EmailFilter());
    managerCorreo.addFilter(EmailCreatedFilter());

    FilterManager managerContrasena = FilterManager(target);
    managerContrasena.addFilter(LengthFilter());
    managerContrasena.addFilter(NumbersFilter());
    managerContrasena.addFilter(SpecialCharacterFilter());


    client = Client(managerCorreo, managerContrasena);
  }


  void validation(){
    String email = _emailController.text;
    String password = _passwordController.text;
    BasedeDatos correos = new BasedeDatos();
    int resultado = this.client.validateEmail(email);
    String texto = "Error desconocido";
    if (resultado == 0){
      resultado = this.client.validatePassword(password);
    }
    switch (resultado) {
      case 0:
        texto = "Ha sido registrado correctamente";
        correos.add(email);
        _emailController.clear();
        _passwordController.clear();
        break;
      case 1:
        texto = "El email no contiene @";
        break;
      case 2:
        texto = "El email no tiene un formato correcto";
        break;
      case 3:
        texto = "Introduce un dominio válido";
        break;
      case 4:
        texto = "La contraseña debe tener una lóngitud mínima de 8 caracteres";
        break;
      case 5:
        texto = "La contraseña debe contener mínimo 2 dígitos";
        break;
      case 6:
        texto = "La contraseña debe contener mínimo 1 caracter especial";
        break;
      case 7:
        texto = "Este correo ya ha sido registrado";
        break;
    }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(texto),
            content: Text(email),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
                children: [
                  TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: 'Email'
                      ),

                  ),

                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: 'Contraseña'
                    ),

                  ),

                  ElevatedButton(
                      onPressed:(){
                        this.validation();
                        },
                      child: const Text('Login')
                  )
                ]
            )

        )
    );
  }

}
