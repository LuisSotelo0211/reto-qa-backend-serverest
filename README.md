# Informe de Estrategia de Automatización

## 1. Enfoque de Automatización

La automatización fue diseñada para cubrir las operaciones CRUD de la API de Usuarios de ServeRest utilizando Karate DSL.

El enfoque principal fue mantener una suite de pruebas:

- Legible.
- Reutilizable.
- Organizada por funcionalidad.
- Con baja dependencia de datos estáticos.
- Capaz de validar tanto escenarios positivos como negativos.

Cada operación CRUD fue separada en un feature independiente con el objetivo de facilitar el mantenimiento y la identificación de los escenarios.

---

## 2. Estrategia de Cobertura

La cobertura se dividió en dos tipos principales de escenarios.

### Happy Path

Se validaron los flujos esperados de la API:

- Listado de usuarios.
- Registro de usuario válido.
- Consulta de usuario existente.
- Actualización de usuario existente.
- Eliminación de usuario existente.

### Unhappy Path

Se agregaron escenarios negativos para validar el comportamiento de la API frente a condiciones no válidas, como:

- Registro con email duplicado.
- Consulta con ID inexistente.
- Consulta con ID de longitud inválida.
- Actualización utilizando un email ya registrado.
- Eliminación de un usuario inexistente.

La combinación de Happy Path y Unhappy Path permite validar tanto el funcionamiento esperado como el manejo de errores de la API.

---

## 3. Estrategia de Datos de Prueba

Uno de los objetivos fue reducir el uso de datos hardcodeados y evitar que las pruebas dependan de información fija.

Para ello se utilizaron dos estrategias.

### Generación dinámica de datos

Se implementó `DataGenerator.java` para generar datos que requieren ser únicos durante la ejecución, principalmente:

- Emails.
- Contraseñas.

Esto evita conflictos al ejecutar varias veces escenarios como el registro o actualización de usuarios.

### Obtención dinámica de usuarios existentes

Se implementó `obtener-usuario.feature` para consultar la API y obtener información de usuarios existentes durante la ejecución.

Este helper permite reutilizar datos como:

- `_id`
- email
- lista de usuarios

De esta forma, las pruebas que necesitan trabajar con usuarios existentes no dependen exclusivamente de IDs o correos definidos manualmente.

---

## 4. Estrategia de Validación

Las pruebas fueron diseñadas para validar la respuesta en diferentes niveles.

### Validación del resultado HTTP

Se valida que la API responda con el código HTTP esperado para cada escenario.

### Validación estructural

Se utilizan esquemas JSON para comprobar que la respuesta contenga los campos y tipos de datos esperados.

Por ejemplo:

```gherkin
{
  "nome": "#string",
  "email": "#string",
  "password": "#string",
  "administrador": "#string",
  "_id": "#string"
}