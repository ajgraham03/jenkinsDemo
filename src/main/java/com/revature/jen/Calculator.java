package com.revature.jen;

public class Calculator {
    public int add(int a, int b){
        return a+b;
    }

    public static void main(String[] args) {
        Calculator calc = new Calculator();

        System.out.println("=========================================");
        System.out.println("   Calculator Demo Application");
        System.out.println("   Jenkins CI/CD Demo - 2026-01-08");
        System.out.println("=========================================");
        System.out.println();

        // Demonstrate arithmetic operations
        int a = 10;
        int b = 5;

        System.out.println("Operands: a = " + a + ", b = " + b);
        System.out.println("-----------------------------------------");
        System.out.println("Addition:       " + a + " + " + b + " = " + calc.add(a, b));
        System.out.println("-----------------------------------------");
        System.out.println("Calculator demo completed successfully!");
        System.out.println("=========================================");
    }
}
