/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ej4;

/**
 *
 * @author Usuario
 */
public class SpecialCharacterFilter implements Filter{
    @Override
    public boolean execute(String password){
        if(!password.matches(".*[!@#$%&/(),.?¿¡{}|<>].*")){
            System.out.println("ERROR: La contraseña debe obtener al menos un caracter especial.");
            return false;
        }
        return true;
    }
}
