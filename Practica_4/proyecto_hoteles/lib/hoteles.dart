abstract class CadenaHotelera{
  int? id;
  bool? nodoHoja;
  int? idPadre;
  void mostrar();
}

class Hotel extends CadenaHotelera{
  @override
  int? id;
  @override
  bool? nodoHoja;
  @override
  int? idPadre;
  String nombre;
  List <CadenaHotelera> hijos;


  Hotel(this.nombre): hijos = [];

  void agregar(CadenaHotelera hijo){
    hijos.add(hijo);
  }


  void eliminar(CadenaHotelera hijo){
    hijos.remove(hijo);
  }

  @override
  void mostrar(){
    print(nombre + hijos.length.toString());
  }


}
