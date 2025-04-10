import 'package:practica_2/Grupal/BD.dart';

abstract class Filter {
  int execute(String data);
}


class EmailFilter implements Filter{

  static const String GMAIL = "gmail.com";
  static const String HOTMAIL = "hotmail.com";


  @override
  int execute(String email){
    if(email == null || !email.contains("@")){
      return 1;
    }

    List<String> parts = email.split("@");
    if(parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty){
      return 2;
    }

    String domain = parts[1];
    if(domain != GMAIL && domain != HOTMAIL){
      return 3;
    }

    return 0;
  }
}



class LengthFilter implements Filter{
  static const int MIN_LENGTH = 8;

  @override
  int execute(String password){
    if(password == null || password.length < MIN_LENGTH){
      return 4;
    }
    return 0;
  }
}


class NumbersFilter implements Filter{
  static final RegExp PSW_EXPRESSION = RegExp(".*\\d.*\\d.*");
  @override
  int execute(String password){
    if(!PSW_EXPRESSION.hasMatch(password)){
      return 5;
    }
    return 0;
  }
}



class SpecialCharacterFilter implements Filter{
  static final RegExp SPECIAL_CHAR_EXPRESSION = RegExp(r".*[!@#\$%&/\(\),.\?¿¡\{\}\|<>].*");
  @override
  int execute(String password){
    if(!SPECIAL_CHAR_EXPRESSION.hasMatch(password)){
      return 6;
    }
    return 0;
  }
}




class EmailCreatedFilter implements Filter{
  BasedeDatos correos = new BasedeDatos();
  @override
  int execute(String email){
    if(correos.estaRegistrado(email)){
      return 7;
    }
    return 0;
  }
}