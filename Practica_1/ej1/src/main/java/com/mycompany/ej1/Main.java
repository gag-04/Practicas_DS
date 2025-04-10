/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package com.mycompany.ej1;
import java.util.ArrayList;
import java.util.Random;

/**
 *
 * @author Usuario
 */
public class Main {
    public static void main(String[] args) {
        Random random = new Random();
        int N = random.nextInt(16) + 5; //20-5+1=16 empieza en 5
        System.out.println("Número de bicicletas inicial: " + N);       
        
        Thread hiloMontana = new Thread(){
            @Override
            public void run(){
                FactoriaCarrerayBicicleta factoria = new FactoriaMontana();
                Carrera carrera = factoria.crearCarrera();
            
                for(int i = 0; i < N; i++){
                    carrera.bicicletas.add(factoria.crearBicicleta());
                }
            
                System.out.println("Carrera de Montaña iniciada con " + carrera.bicicletas.size());
                try{
                    Thread.sleep(60000);
                }catch(InterruptedException e){
                    Thread.currentThread().interrupt();
                }
            
                carrera.retirarBicicletas();
                System.out.println("Carrera de Montaña terminada con " + carrera.bicicletas.size());
            }
        };
        
        Thread hiloCarretera = new Thread(){
            @Override
            public void run(){
                FactoriaCarrerayBicicleta factoria = new FactoriaCarretera();
                Carrera carrera = factoria.crearCarrera();
            
                for(int i = 0; i < N; i++){
                    carrera.bicicletas.add(factoria.crearBicicleta());
                }
            
                System.out.println("Carrera de Carretera iniciada con " + carrera.bicicletas.size());
                try{
                    Thread.sleep(60000);
                }catch(InterruptedException e){
                    Thread.currentThread().interrupt();
                }
            
                carrera.retirarBicicletas();
                System.out.println("Carrera de Carretera terminada con " + carrera.bicicletas.size());
            }
        };
        
        hiloMontana.start();
        hiloCarretera.start();
    }
}
