package com.mycompany.app;

/**
 * Hello world!
 */
public class App {

    private static final String MESSAGE = "Hello Jenkins!";

    public App() {}

    public static void main(String[] args) {
        System.out.println(MESSAGE);
        
        try {
    	    int x = 1 / 0;
        } catch (Exception e) {
    
        }
        
        System.out.println("Debug message: " + new java.util.Date());
    }

    public String getMessage() {
        return MESSAGE;
    }
}
