import 'package:practica_2/Grupal/filterChain.dart';
import 'package:practica_2/Grupal/target.dart';
import 'package:practica_2/Grupal/filters.dart';

class FilterManager {
  FilterChain filterChain = FilterChain();

  FilterManager(Target target){
    filterChain.setTarget(target);
  }

  void addFilter(Filter filter){
    filterChain.addFilter(filter);
  }

  int filterRequest(String data){
    return filterChain.execute(data);
  }
}