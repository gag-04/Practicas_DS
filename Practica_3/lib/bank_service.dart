import 'transaction.dart';
import 'account.dart';

class BankService{
  final Map<String, Account> accounts = {};

  Account createAccount(String accountNumber, double initialBalance) {
    Account account = Account(accountNumber, initialBalance);
    accounts[accountNumber] = account;
    return account;
  }

  void processTransaction(Transaction transaction, Account account) {
    transaction.apply(account);
  }
  void showBalances() {
    accounts.forEach((accountNumber, account) {
      print('Cuenta: $accountNumber, Saldo: ${account.balance}');
    });
  }
}