package runners;

import com.intuit.karate.junit5.Karate;

class UsersTest {

    @Karate.Test
    Karate testUsers() {
        return Karate.run("classpath:users");
                //.tags("@eliminarUsuario");
    }
}   