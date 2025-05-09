import 'package:flutter_test/flutter_test.dart';

import 'package:practica3/transfer_transaction.dart';
import 'package:practica3/account.dart';
import 'package:practica3/bank_service.dart';
import 'package:practica3/deposit_transaction.dart';
import 'package:practica3/withdrawal_transaction.dart';

void main() {

  //Account cuenta3 = new Account("3", -100);

  group('Account', () {
    Account cuenta1 = Account("Cuenta 1");
    Account cuenta2 = Account("Cuenta 2");

    test('El balance inicial de una cuenta debe ser cero', () {
      expect(cuenta1.balance, equals(0.0));
      expect(cuenta2.balance, equals(0.0));
      //expect(() => cuenta2.balance, isAssertionError);
      //expect(() => cuenta3.balance, isAssertionError);
    });

    test('No se permite depositar cantidades negativas o cero', () {
      expect(() => cuenta1.deposit(0), throwsStateError);
      expect(() => cuenta1.deposit(-100), throwsStateError);
    });

    test('No se permite retirar cantidades negativas o cero', () {
      expect(() => cuenta1.withdraw(0), throwsStateError);
      expect(() => cuenta1.withdraw(-50), throwsStateError);
    });
  });

  group('Transaction', () {
    Account cuenta1 = Account("Cuenta 1");
    Account cuenta2 = Account("Cuenta 2");

    test('DepositTransaction.apply aumenta el saldo correctamente', () {

      final deposito = DepositTransaction(150.0);

      deposito.apply(cuenta1);

      expect(cuenta1.balance, equals(150.0));
    });

    test('WithdrawalTransaction.apply lanza StateError cuando no hay fondos suficientes', () {

      final retiro = WithdrawalTransaction(300.0);

      expect(() => retiro.apply(cuenta1), throwsStateError);
    });

    test('TransferTransaction.apply mueve fondos entre cuentas de forma correcta', () {

      final transferencia = TransferTransaction(100.0, cuenta2);

      transferencia.apply(cuenta1);

      expect(cuenta1.balance, equals(50.0));
      expect(cuenta2.balance, equals(100.0));
    });
  });
  group('BankService Test', () {
    BankService banco = BankService();
    banco.createAccount("Cuenta 1");
    banco.createAccount("Cuenta 2");


    test('La lista empieza vacia', () {
      BankService otroBanco = BankService();
      expect (otroBanco.accounts.isEmpty, isTrue);
    });


    test('Depositar dinero', () {
      banco.deposit("Cuenta 1", 50);

      expect(banco.getBalance("Cuenta 1"), equals(50.0));
    });

    test('Depositar dinero negativo', () {
      expect(() => banco.deposit("Cuenta 1", -50), throwsStateError);
    });


    test('Transferir dinero', () {
      banco.transfer("Cuenta 1",50, "Cuenta 2" );

      expect(banco.getBalance("Cuenta 1"), equals(0.0));
      expect(banco.getBalance("Cuenta 2"), equals(50.0));
    });


    test('Transferir dinero con saldo insuficiente', () {
      expect(() => banco.transfer("Cuenta 1",1000, "Cuenta 2"), throwsStateError);
    });


    test('Retirar dinero con saldo suficiente', () {
      banco.withdraw("Cuenta 2", 40);

      expect(banco.getBalance("Cuenta 2"), equals(10.0));
    });


    test('Retirar dinero con saldo insuficiente', () {
      expect(() => banco.withdraw("Cuenta 1", 40), throwsStateError);
    });


    test('El identificador de transacción es único', (){
      Set<String> transacciones = {};
      for (int i=0; i<10; i++){
        String idNueva = banco.deposit("Cuenta 1", 20);
        transacciones.add(idNueva);
      }

      expect(transacciones.length, 10);
    });

  });

}


/*
Preguntar sobre el id unico de transaccion
Preguntar sobre los test de Bank Service



Falta Lista cuentas
 */

