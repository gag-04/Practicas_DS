/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ej4;

/**
 *
 * @author Usuario
 */
public class EmailFilter implements Filter{
    @Override
    public boolean execute(String email){
        //1º ver que tiene @, es lo más importante que necesita un email
        if(email == null || !email.contains("@")){
            System.out.println("ERROR: El correo no contiene @.");
            return false;
        }
        
        //2º veo las dos partes que separa el @. Que no estén vacías
        String[] parts = email.split("@");
        if(parts.length != 2 || parts[0].isEmpty()){
            System.out.println("ERROR: No hay texto antes del @.");
            return false;
        }
        
        //3º veo si el dominio es hotmail o gmail, si no no es aceptado
        String domain = parts[1];
        if(!domain.equals("gmail.com") && !domain.equals("hotmail.com")){
            System.out.println("ERROR: El dominio debe ser gmail.com o hotmail.com.");
            return false;
        }
        
        //si pasa esos filtros es una dirección válida
        return true;
    }
}
