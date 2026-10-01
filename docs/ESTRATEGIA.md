# Informe de Estrategia de Automatización

## 1. Estrategia General

La automatización fue diseñada para validar las operaciones CRUD de la API de Usuarios de ServeRest mediante Karate DSL.

La estrategia se enfocó en cubrir los criterios de aceptación del reto mediante escenarios positivos y negativos, procurando que las pruebas sean legibles, reutilizables y con la menor dependencia posible de datos estáticos.

Se decidió separar cada operación de usuarios en un feature independiente para facilitar el mantenimiento y permitir identificar rápidamente las pruebas asociadas a cada endpoint.

---

## 2. Cobertura de Pruebas

La cobertura fue dividida en dos grupos principales:

### Happy Path

Se validaron los flujos esperados de la API:

- Listar usuarios.
- Registrar un usuario válido.
- Buscar un usuario existente por ID.
- Actualizar un usuario existente.
- Eliminar un usuario existente.

### Unhappy Path

Se agregaron escenarios negativos para comprobar el comportamiento de la API ante situaciones inválidas:

- Registro con email duplicado.
- Búsqueda con ID inexistente.
- Búsqueda con ID de longitud inválida.
- Actualización con un email perteneciente a otro usuario.
- Eliminación de un usuario inexistente.

Los escenarios se organizaron mediante los tags `@happyPath` y `@unHappyPath`, además de tags específicos por funcionalidad.

---

## 3. Estrategia de Validación

Las pruebas fueron diseñadas para no depender únicamente del código de estado HTTP.

Se validan tres niveles:

1. **Código HTTP:** confirma el resultado general de la petición.
2. **Esquema JSON:** comprueba que la estructura y los tipos de datos sean los esperados.
3. **Validación funcional:** comprueba valores concretos como mensajes, IDs y cantidades.

Por ejemplo, una respuesta puede validarse mediante un esquema:

```gherkin
* def schemaUsuario =
"""
{
  "nome": "#string",
  "email": "#string",
  "password": "#string",
  "administrador": "#string",
  "_id": "#string"
}
"""

And match response == schemaUsuario
```

Esta estrategia permite detectar tanto cambios en la estructura de la API como comportamientos funcionales incorrectos.

---

## 4. Estrategia de Datos de Prueba

Se buscó reducir el uso de datos hardcodeados para permitir que los escenarios puedan ejecutarse repetidamente.

Para los datos que deben ser únicos se implementó:

```text
helpers/DataGenerator.java
```

Esta utilidad genera dinámicamente emails y contraseñas.

Para los escenarios que necesitan información existente se implementó:

```text
helpers/obtener-usuario.feature
```

Este helper consulta la API y permite reutilizar usuarios disponibles durante la ejecución.

De esta manera, los escenarios pueden obtener dinámicamente datos como `_id` y `email` en lugar de depender únicamente de valores escritos manualmente.

Los datos estáticos se mantienen únicamente cuando forman parte intencional del caso de prueba, por ejemplo un ID con longitud inválida.

---

## 5. Reutilización y Patrones Utilizados

La automatización aplica principalmente los siguientes patrones y prácticas:

### Separación de responsabilidades

Cada operación CRUD se encuentra en un feature independiente, mientras que los helpers y el runner se encuentran separados de los escenarios funcionales.

### Reutilización mediante helpers

La lógica común para obtener usuarios existentes se centralizó en un helper reutilizable, evitando repetir la misma preparación en diferentes features.

### Generación dinámica de datos

Los datos que pueden provocar conflictos entre ejecuciones, como emails, son generados dinámicamente.

### Configuración común con Background

Cada feature utiliza `Background` para definir configuraciones compartidas, como la URL base de ServeRest.

### Organización mediante tags

Los tags permiten clasificar los escenarios por tipo y funcionalidad, facilitando la ejecución selectiva durante el desarrollo.

### Validación estructural y funcional

Los escenarios combinan validaciones de esquema JSON con validaciones específicas del comportamiento esperado de la API.

---

## 6. Criterio de Diseño

Se priorizó mantener los escenarios simples y legibles.

Karate DSL permite expresar las pruebas utilizando una estructura cercana a Gherkin, por lo que se evitó agregar complejidad innecesaria dentro de los feature files.

La lógica reutilizable o relacionada con preparación de datos fue separada en helpers, mientras que los escenarios principales se mantienen enfocados en:

```text
Preparar datos
      ↓
Ejecutar request
      ↓
Validar status
      ↓
Validar esquema
      ↓
Validar resultado funcional
```

---

## 7. Resultado

La estrategia implementada permite cubrir las operaciones CRUD solicitadas en el reto junto con escenarios positivos y negativos.

La combinación de separación por features, helpers reutilizables, datos dinámicos, tags y validaciones de esquema permite mantener una suite organizada y preparada para futuras ampliaciones.