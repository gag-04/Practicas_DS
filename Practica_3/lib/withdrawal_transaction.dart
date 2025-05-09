import 'account.dart';
import 'transaction.dart';

class WithdrawalTransaction extends Transaction{

  WithdrawalTransaction(super.amount);

  @override
  void apply(Account account) {
    if (account.balance >= amount) {
      account.withdraw(amount);
    } else {
      throw StateError("Fondos insuficientes.");
    }
  }
}