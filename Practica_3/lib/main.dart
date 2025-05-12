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

  void _depositarDinero(String numCuenta, double cantidad){
    setState(() {
      banco.deposit(numCuenta, cantidad);
    });
  }

  void _transferirDinero(String numCuenta, double cantidad, String destino){
    setState(() {
      banco.transfer(numCuenta, cantidad, destino);
    });
  }

  void _sacarDinero(String numCuenta, double cantidad){
    setState(() {
      banco.withdraw(numCuenta, cantidad);
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
                onDeposit: _depositarDinero,
                onTransfer: _transferirDinero,
                onWithdraw: _sacarDinero
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
  final void Function(String, double) onDeposit;
  final void Function(String, double, String) onTransfer;
  final void Function(String, double) onWithdraw;

  const ListaCuentas({super.key, required this.bankService, required this.onDeposit, required this.onTransfer, required this.onWithdraw});


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
                onTap: () => _mostrarDialogoTransferencia(context, cuenta.accountNumber),
                child: const Icon(CupertinoIcons.arrow_right_arrow_left),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _mostrarDialogoOperacionSimple(context, 'deposit', cuenta.accountNumber),
                child: const Icon(CupertinoIcons.add),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _mostrarDialogoOperacionSimple(context, 'withdraw', cuenta.accountNumber),
                child: const Icon(CupertinoIcons.minus),
              ),
            ],
          ),

        );
      }).toList(),
    );
  }


  void _mostrarDialogoOperacionSimple(BuildContext context, String tipo, String cuentaOrigen) {
    final TextEditingController cantidadController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(tipo == 'deposit' ? 'Depositar dinero' : 'Sacar dinero'),
        content: Column(
          children: [
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: cantidadController,
              placeholder: 'Cantidad',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: const Text('Aceptar'),
            onPressed: () {
              final cantidad = double.tryParse(cantidadController.text);
              if (cantidad != null) {
                if (tipo == 'deposit') {
                  onDeposit(cuentaOrigen, cantidad);
                } else {
                  onWithdraw(cuentaOrigen, cantidad);
                }
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoTransferencia(BuildContext context, String cuentaOrigen) {
    final TextEditingController cantidadController = TextEditingController();
    final TextEditingController destinoController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Transferencia'),
        content: Column(
          children: [
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: cantidadController,
              placeholder: 'Cantidad',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: destinoController,
              placeholder: 'Cuenta destino',
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: const Text('Aceptar'),
            onPressed: () {
              final cantidad = double.tryParse(cantidadController.text);
              final destino = destinoController.text.trim();
              if (cantidad != null && destino.isNotEmpty) {
                onTransfer(cuentaOrigen, cantidad, destino);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

}


