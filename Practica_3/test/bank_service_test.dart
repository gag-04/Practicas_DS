import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:practica3/main.dart';
import 'package:practica3/transfer_transaction.dart';
import 'package:practica3/account.dart';
import 'package:practica3/transaction.dart';
import 'package:practica3/bank_service.dart';
import 'package:practica3/deposit_transaction.dart';
import 'package:practica3/transfer_transaction.dart';
import 'package:practica3/withdrawal_transaction.dart';

void main() {
  Account cuenta1 = new Account("1", 0);
  Account cuenta2 = new Account("2", 0);
  //Account cuenta3 = new Account("3", -100);

  group('Account', () {

    test('El balance inicial de una cuenta debe ser cero', () {
      expect(cuenta1.balance, equals(0.0));
      expect(cuenta2.balance, equals(0.0));
      //expect(() => cuenta2.balance, isAssertionError);
      //expect(() => cuenta3.balance, isAssertionError);
    });

    test('No se permite depositar cantidades negativas o cero', () {
      expect(() => cuenta1.deposit(0), throwsArgumentError);
      expect(() => cuenta1.deposit(-100), throwsArgumentError);
    });

    test('No se permite retirar cantidades negativas o cero', () {
      expect(() => cuenta1.withdraw(0), throwsArgumentError);
      expect(() => cuenta1.withdraw(-50), throwsArgumentError);
    });
  });

  group('Transaction', () {
    test('DepositTransaction.apply aumenta el saldo correctamente', () {

      final deposito = DepositTransaction('tx1', 150.0);

      deposito.apply(cuenta1);

      expect(cuenta1.balance, equals(150.0)); //revisar pq no la hemos creado aqui la cuenta, poner el numero del main
    });

    test('WithdrawalTransaction.apply lanza StateError cuando no hay fondos suficientes', () {

      final retiro = WithdrawalTransaction('tx2', 300.0);

      expect(() => retiro.apply(cuenta1), throwsArgumentError);
    });

    test('TransferTransaction.apply mueve fondos entre cuentas de forma correcta', () {

      final transferencia = TransferTransaction('tx3', 100.0, cuenta2);

      transferencia.apply(cuenta1);

      expect(cuenta1.balance, equals(50.0));
      expect(cuenta2.balance, equals(100.0));
    });
  });

  group('BankService Test', () {
    test('Depositar dinero', () {
      DepositTransaction deposit = DepositTransaction("t1", 50);

      deposit.apply(cuenta1);
      expect(cuenta1.balance, equals(100.0));
    });

    test('Transferir dinero', () {
      TransferTransaction transfer = TransferTransaction("t2", 50, cuenta2);

      transfer.apply(cuenta1);
      expect(cuenta1.balance, equals(50.0));
    });

    test('Retirar dinero con saldo suficiente', () {
      WithdrawalTransaction withdrawal = WithdrawalTransaction("t3", 40);

      withdrawal.apply(cuenta1);
      expect(cuenta1.balance, equals(10.0));
    });

    /*
    NO ERA NECESARIO PERO FUNCIONA
     */
    test('Depositar dinero negativo', () {
      DepositTransaction deposit = DepositTransaction("t1", -50);

      expect(() => deposit.apply(cuenta1), throwsArgumentError);
    });



   /* test('Transferir dinero con saldo insuficiente', () {
      TransferTransaction transfer = TransferTransaction("t2", 50, cuenta2);

      expect(() => transfer.apply(cuenta1), throwsArgumentError);
    });

   */

    test('Retirar dinero con saldo insuficiente', () {
      WithdrawalTransaction withdrawal = WithdrawalTransaction("t3", 40);

      expect(() => withdrawal.apply(cuenta1), throwsArgumentError);
    });


  });

}


/*
Preguntar sobre el id unico de transaccion
Preguntar sobre el initial amount
Preguntar sobre los test de Bank Service
 */

