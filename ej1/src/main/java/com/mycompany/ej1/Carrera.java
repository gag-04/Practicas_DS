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
public abstract class Carrera {
    protected ArrayList<Bicicleta> bicicletas;
    protected float retirados;

    public Carrera(float retirados, ArrayList<Bicicleta> bicicletas) {
        this.retirados = retirados;
        this.bicicletas = bicicletas;
    }
    
    public abstract void retirarBicicletas();
}
