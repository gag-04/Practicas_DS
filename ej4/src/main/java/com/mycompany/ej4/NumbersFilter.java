/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ej4;

/**
 *
 * @author Usuario
 */
public class NumbersFilter implements Filter{
    @Override
    public boolean execute(String password){
        if(!password.matches(".*\\d.*\\d.*")){
            System.out.println("ERROR: La contraseña debe contener al menos 2 números.");
            return false;
        }
        return true;
    }
}
