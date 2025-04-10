/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ej4;
import java.util.ArrayList;
/**
 *
 * @author Usuario
 */
public class FilterManager {
    private FilterChain filterChain;
    
    public FilterManager(Target target){
        filterChain = new FilterChain();
        filterChain.setTarget(target);
    }
    
    public void addFilter(Filter filter){
        filterChain.addFilter(filter);
    }
    
    public boolean filterRequest(String data){
        return filterChain.execute(data);
    }
}
