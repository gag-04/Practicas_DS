import 'account.dart';
import 'transaction.dart';

class WithdrawalTransaction extends Transaction{
  WithdrawalTransaction(String id, double amount) : super(id, amount);

  @override
  void apply(Account account) {
    if (account.balance >= amount) {
      account.withdraw(amount);
    } else {
      throw ArgumentError("Fondos insuficientes.");
    }
  }
}