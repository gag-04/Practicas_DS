import 'account.dart';

abstract class Transaction {
   final String _id ;
   final double amount;
   static int siguienteID = 0;

   Transaction(this.amount) : _id = "Transaction_${siguienteID++}"
   {
      Transaction.siguienteID++;
   }

   String getID(){
      return _id;
   }


   void apply( Account account);
}