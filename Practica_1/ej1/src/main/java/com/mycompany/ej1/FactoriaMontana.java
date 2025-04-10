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
public class FactoriaMontana implements FactoriaCarrerayBicicleta{
    @Override
    public Carrera crearCarrera(){
        return new CarreraMontana(new ArrayList<>());
    }
    
    @Override
    public Bicicleta crearBicicleta(){
        return new BicicletaMontana();
    }
}
