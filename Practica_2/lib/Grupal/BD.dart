class BasedeDatos{
  static List<String> correosRegistrados= [];

  bool estaRegistrado(String email){
    return correosRegistrados.contains(email);
  }
  
  void add(String email){
    correosRegistrados.add(email);
  }
}