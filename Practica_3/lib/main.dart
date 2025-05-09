import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'bank_service.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 3: Sistema Bancario',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Sistema Bancario'),
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

  final BankService banco = BankService();

  final TextEditingController _numCuentaController = TextEditingController();
  String _nuevoNumCuenta = '';
  bool _mostrarCampo = false;

  void _crearCuenta() {
    setState(() {
      String numCuenta = _nuevoNumCuenta;
      banco.createAccount(numCuenta);
    });
  }

  void _depositarDinero(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Servicio Bancario'),

      ),
      child: SafeArea(
          child: Column(
            children: [
              ListaCuentas(
                bankService: banco,
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _mostrarCampo
                      ? Row(
                    children: [
                      Expanded(
                        child: CupertinoTextField(
                                  controller: _numCuentaController,
                                  placeholder: 'Número de cuenta',
                                  onChanged: (value) {
                                    _nuevoNumCuenta = value;
                                  },
                                ),
                      ),

                      const SizedBox(width: 8),
                      Row(
                          spacing: 5,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (_nuevoNumCuenta
                                      .trim()
                                      .isNotEmpty) {
                                    _crearCuenta();
                                    _numCuentaController.clear();
                                    _nuevoNumCuenta = '';
                                    _mostrarCampo = false;
                                  }
                                });
                              },
                              child: const Text('✓'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _numCuentaController.clear();
                                  _nuevoNumCuenta = '';
                                  _mostrarCampo = false;
                                });
                              },
                              child: const Text('✗'),
                            ),


                          ]

                        )
                      ],
                    )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      // espacio entre total y el botón
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mostrarCampo = true;
                          });
                        },
                        child: const Text('Nueva Cuenta'),
                      ),
                    ],
                  )

              )
            ],
          )
      ),
    );
  }
}

class ListaCuentas extends StatelessWidget {
  final BankService bankService;

  const ListaCuentas({super.key, required this.bankService});

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection(
      header: const Text('Cuentas Bancarias'),
      children: bankService.accounts.values.map((cuenta) {
        return CupertinoListTile(
          title: Text(cuenta.accountNumber),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: Text(cuenta.accountNumber),
                      content: Text('Saldo actual: ${cuenta.balance.toStringAsFixed(2)} €'),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: const Text('Cerrar'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(CupertinoIcons.info),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => null,//onTransfer(cuenta),
                child: const Icon(CupertinoIcons.arrow_right_arrow_left),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => null,//onTransfer(cuenta),
                child: const Icon(CupertinoIcons.add),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => null,//onTransfer(cuenta),
                child: const Icon(CupertinoIcons.minus),
              ),
            ],
          ),

        );
      }).toList(),
    );
  }
}

