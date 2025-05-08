import 'transaction.dart';
import 'account.dart';

class DepositTransaction extends Transaction{

  DepositTransaction(String id, double amount): super(id,amount);

  @override
  apply(Account account){
    if (this.amount > 0){
      account.deposit(this.amount);
    }

    else{
      throw ArgumentError("La cantidad no puede ser negativa");
    }
  }
}