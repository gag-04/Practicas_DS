import 'account.dart';
import 'transaction.dart';

class TransferTransaction extends Transaction {
    final Account to_account;

    TransferTransaction(String id, double amount, this.to_account){
    }
        : super(id, amount);


    @override
    void apply(Account origin) {
        origin.withdraw(amount); // Retira de la cuenta origen
        to_account.deposit(amount); // Deposita en la cuenta destino
    }

}