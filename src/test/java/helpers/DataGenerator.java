package helpers;

public class DataGenerator {

    public static String generarEmail() {
        return "usuario" + System.currentTimeMillis() + "@qa.com";
    }

    public static String generarPassword() {
        return "Qa" + System.currentTimeMillis() + "!";
    }
}