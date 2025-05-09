import 'account.dart';
import 'transaction.dart';

class TransferTransaction extends Transaction {
    final Account toAccount;

    TransferTransaction(super.amount, this.toAccount);


    @override
    void apply(Account origin) {
        origin.withdraw(amount); // Retira de la cuenta origen
        toAccount.deposit(amount); // Deposita en la cuenta destino
    }

}