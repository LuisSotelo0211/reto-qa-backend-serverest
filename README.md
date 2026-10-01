# Reto QA Back - ServeRest

Pruebas de la API de usuarios con **Karate DSL 1.5.2, Java y Maven**.

## Requisitos

- JDK 17 o superior (recomendado: JDK 17 o 21).
- Maven 3.9.x en el PATH.
- Acceso a Internet y a `https://serverest.dev`.

Comprueba la instalación:

```powershell
java -version
mvn -version
```

Maven debe mostrar un JDK compatible. Si no encuentra Java, configura `JAVA_HOME` apuntando a la carpeta del JDK y agrega su carpeta `bin` al PATH.

## Configuración

Abre una terminal en la carpeta que contiene `pom.xml`. Maven descargará las dependencias en la primera ejecución.

La URL se configura en `src/test/java/karate-config.js`. No se requiere token para los endpoints de usuarios usados en el reto.

## Ejecutar todas las pruebas

```powershell
mvn clean test
```

Se ejecutan **10 escenarios**: listar (1), registrar (2), buscar por ID (3), actualizar (2) y eliminar (2). Los helpers generan datos y crean usuarios para la preparación, no son casos independientes.

## Ejecutar por tags

En PowerShell, conserva las comillas del argumento:

```powershell
mvn test "-Dkarate.options=--tags @happyPath"
mvn test "-Dkarate.options=--tags @unHappyPath"
mvn test "-Dkarate.options=--tags @registrarUsuario"
mvn test "-Dkarate.options=--tags @actualizarUsuario"
mvn test "-Dkarate.options=--tags @eliminarUsuario"
```

Otros tags: `@listarUsuarios`, `@buscarUsuario`, `@usuarioEmailDuplicado`, `@usuarioIdInexistente`, `@usuarioIdInvalido`, `@actualizarEmailDuplicado` y `@eliminarUsuarioInexistente`.

## Reportes

- `target/karate-reports/`: reportes HTML por feature.
- `target/surefire-reports/`: resultados JUnit y resumen de Maven.

Para abrir el reporte de registro en Windows:

```powershell
Start-Process .\target\karate-reports\users.registrar-usuario.html
```

Un resultado correcto debe indicar 10 pruebas ejecutadas, cero fallos y cero errores. `mvn clean test` elimina los reportes anteriores antes de ejecutar.

## Estructura

```text
src/test/java/
  karate-config.js           URL base de la API
  runners/UsersTest.java     Ejecuta los features de users
  helpers/                  Generación de datos y creación de usuarios
  users/                    Un feature por operación de usuarios
docs/ESTRATEGIA.md           Informe breve de estrategia y patrones
pom.xml                     Dependencias y configuración de Maven
```

## Datos y solución de problemas

Las pruebas crean usuarios propios con emails únicos `qa-reto-...@example.com` y los conservan al terminar. No hay limpieza automática ni hook `afterScenario`. El registro imprime el ID y email para localizarlo en `https://serverest.dev/usuarios`.

Solo los escenarios de `users/eliminar-usuario.feature` envían DELETE. Cada uno crea y elimina su propio usuario; no borra automáticamente los usuarios de ejecuciones anteriores ni usuarios ajenos. Buscar un ID inexistente genera un ID de 16 caracteres y comprueba que no esté en el listado, sin eliminar registros.

El runner puede tener un filtro `.tags(...)`: si está configurado, solo ejecutará los casos seleccionados. Para ejecutar todos, debe devolver `Karate.run("classpath:users")` sin ese filtro.

Si no se encuentran los features, ejecuta desde la raíz con `mvn clean test`. El `pom.xml` copia los recursos `.feature` y `.js` de `src/test/java` al classpath de pruebas.

La cobertura y las decisiones de diseño están en [docs/ESTRATEGIA.md](docs/ESTRATEGIA.md).
