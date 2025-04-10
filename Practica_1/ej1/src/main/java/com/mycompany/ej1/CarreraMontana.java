/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ej1;

import java.util.ArrayList;

/**
 *
 * @author Usuario
 */
public class CarreraMontana extends Carrera{
    public CarreraMontana(ArrayList<Bicicleta> bicicletas) {
        super(0.2f,bicicletas);
    }
    
    @Override 
    public void retirarBicicletas(){
        int numRetirada = (int) (1 + bicicletas.size() * retirados);
        for(int i = 0; i < numRetirada; i++){
            bicicletas.remove(bicicletas.size() - 1);
        }
    }
    
}
