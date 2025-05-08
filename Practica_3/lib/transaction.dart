import 'account.dart';

abstract class Transaction {
   final String id;
   final double amount;

   Transaction(this.id, this.amount);

   void apply( Account account);
}