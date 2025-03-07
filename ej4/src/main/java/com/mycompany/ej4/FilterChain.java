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
public class FilterChain {
    private final ArrayList<Filter> filters = new ArrayList<>();
    private Target target;
    
    public void addFilter(Filter filter){
        filters.add(filter);
    }
    
    public void setTarget(Target target){
        this.target = target;
    }
    
    public boolean execute(String data){
        for(Filter f : filters){
            //Si hay ya un filtro que falla la validación termina
            if(!f.execute(data)){
                System.out.println("Algún filtro ha fallado, intercepción terminada.");
                return false;
            }
        }
        
        if(target != null){
            target.execute(data);
        }
        
        return true;
    }
}
