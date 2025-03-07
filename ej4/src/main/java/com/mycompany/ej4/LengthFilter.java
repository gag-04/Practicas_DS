/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ej4;

/**
 *
 * @author Usuario
 */
public class LengthFilter implements Filter{
    @Override
    public boolean execute(String password){
        if(password == null || password.length() < 8){
            System.out.println("ERROR: La contraseña debe tener al menos 8 caracteres");
            return false;
        }
        return true;
    }
}
