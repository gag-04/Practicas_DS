import 'package:practica_2/Grupal/filters.dart';
import 'package:practica_2/Grupal/target.dart';


class FilterChain {
  final List<Filter> filters = [];
  Target? target;

  void addFilter(Filter filter){
    filters.add(filter);
  }

  void setTarget(Target target){
    this.target = target;
  }

  int execute(String data){
    int success = 0 ;
    int resultado = 0 ;

    for(var f in filters){
      resultado = f.execute(data);
      if(resultado != 0){
        return resultado;
      }
    }

    if (target != null) {
      success = target!.execute(data);
    } else {
      throw Exception('Target no ha sido establecido antes de ejecutar la cadena de filtros.');
    }

    return success;
  }
}