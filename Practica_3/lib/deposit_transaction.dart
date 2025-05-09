import 'transaction.dart';
import 'account.dart';

class DepositTransaction extends Transaction{

  DepositTransaction(super.amount);

  @override
  apply(Account account){
    if (amount > 0){
      account.deposit(amount);
    }

    else{
      throw StateError("La cantidad no puede ser negativa");
    }
  }
}