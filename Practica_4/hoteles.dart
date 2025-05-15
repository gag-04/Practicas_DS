abstract class CadenaHotelera{
  void mostrar();
}

class Hotel extends CadenaHotelera{
  String nombre;
  List <CadenaHotelera> hijos;


  Hotel(this.nombre): hijos = [];

  void agregar(hijo){
    hijos.add(hijo);
  }


  void eliminar(hijo){
    hijos.remove(hijo);
  }

  @override
  void mostrar(){
    print(nombre + hijos.length.toString());
  }


}
