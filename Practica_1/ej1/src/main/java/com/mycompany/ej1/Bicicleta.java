/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ej1;

/**
 *
 * @author Usuario
 */
abstract public class Bicicleta {
    private final int id;
    private static int contadorID = 0;

    public Bicicleta() {
        this.id = contadorID;
        contadorID++;        
    }
}
