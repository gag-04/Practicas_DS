/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package com.mycompany.ej4;

import java.util.Scanner;

/**
 *
 * @author Usuario
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Target target = new Target();
        FilterManager managerCorreo = new FilterManager(target);
        managerCorreo.addFilter(new EmailFilter());
        
        FilterManager managerContrasena = new FilterManager(target);
        managerContrasena.addFilter(new LengthFilter());
        managerContrasena.addFilter(new NumbersFilter());
        managerContrasena.addFilter(new SpecialCharacterFilter());
        
        Client client = new Client(managerCorreo, managerContrasena);
        
        System.out.println("Introduce tu correo: ");
        String correo = scanner.nextLine();
        
        System.out.println("Introduce tu contraseña: ");
        String contrasena = scanner.nextLine();
        
        if(!client.validateEmail(correo)){
            System.out.println("El correo no ha pasado las validaciones correspondientes.");
            return;
        }
        
        if(!client.validatePassword(contrasena)){
            System.out.println("La contraseña no ha pasado las validaciones correspondientes.");
            return;
        }
        
        System.out.println("\nValidación de correo y contraseña exitosa. Usuario guardado.");
    }
    
}
