package helpers;

import java.util.UUID;

public class DataGenerator {
    public static String generarEmail() {
        return "qa-reto-" + UUID.randomUUID() + "@example.com";
    }

    public static String generarPassword() {
        return "Qa-" + UUID.randomUUID() + "!";
    }
}
