import 'package:practica_2/Grupal/filterManager.dart';

class Client{
  FilterManager emailManager;
  FilterManager passwordManager;

  Client(this.emailManager,this.passwordManager);

  int validateEmail(String email){
    return emailManager.filterRequest(email);
  }

  int validatePassword(String password){
    return passwordManager.filterRequest(password);
  }
}