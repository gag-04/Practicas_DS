import 'package:practica3/deposit_transaction.dart';
import 'package:practica3/transfer_transaction.dart';
import 'package:practica3/withdrawal_transaction.dart';
import 'account.dart';

class BankService{
  final Map<String, Account> accounts = {};

  Account createAccount(String accountNumber) {
    Account account = Account(accountNumber);
    accounts[accountNumber] = account;
    return account;
  }

  String deposit(String numCuenta, double amount) {
    final cuenta = accounts[numCuenta];
    if (cuenta == null) {
      throw StateError('La cuenta $numCuenta no existe.');
    }

    final transaction = DepositTransaction(amount);
    transaction.apply(cuenta);

    return transaction.getID();
  }


  String transfer(String numCuenta,double amount, String numCuentaDestino){
    final cuenta = accounts[numCuenta];
    if (cuenta == null) {
      throw StateError('La cuenta $numCuenta no existe.');
    }

    final cuentaDestino = accounts[numCuentaDestino];
    if (cuentaDestino == null) {
      throw StateError('La cuenta $numCuentaDestino no existe.');
    }

    TransferTransaction transaction = TransferTransaction(amount, cuentaDestino);

    transaction.apply(cuenta);

    return transaction.getID();
  }

  String withdraw(String numCuenta, double amount){
    final cuenta = accounts[numCuenta];
    if (cuenta == null) {
      throw StateError('La cuenta $numCuenta no existe.');
    }

    WithdrawalTransaction transaction = WithdrawalTransaction(amount);

    transaction.apply(cuenta);

    return transaction.getID();
  }

  void showBalances() {
    accounts.forEach((accountNumber, account) {
      print('Cuenta: $accountNumber, Saldo: ${account.balance}');
    });
  }

  double getBalance(String numCuenta){
    final cuenta = accounts[numCuenta];
    if (cuenta == null) {
      throw StateError('La cuenta $numCuenta no existe.');
    }

    return cuenta.balance;

  }
}