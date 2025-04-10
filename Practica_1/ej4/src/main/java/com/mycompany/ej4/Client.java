/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ej4;

/**
 *
 * @author Usuario
 */
public class Client {
    private FilterManager emailManager;
    private FilterManager passwordManager;
    
    public Client(FilterManager emailManager, FilterManager passwordManager){
        this.emailManager = emailManager;
        this.passwordManager = passwordManager;

    }
    
    public boolean validateEmail(String email){
        System.out.println("\n Validando el correo...");
        return emailManager.filterRequest(email);
    }
    
    public boolean validatePassword(String password){
        System.out.println("\n Validando el contraseña...");
        return passwordManager.filterRequest(password);
    }
}
