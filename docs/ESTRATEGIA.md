# Informe breve de estrategia de automatización

## Objetivo y cobertura

Validar las cinco operaciones de usuarios solicitadas por el reto Back en ServeRest.

| Operación | Casos |
| --- | --- |
| GET /usuarios | Listado, esquema, cantidad y presencia de un usuario propio |
| POST /usuarios | Registro válido y rechazo de email duplicado |
| GET /usuarios/{id} | Usuario existente, ID inexistente e ID de longitud inválida |
| PUT /usuarios/{id} | Actualización válida y rechazo de email de otro usuario |
| DELETE /usuarios/{id} | Eliminación válida y eliminación de un ID inexistente |

Son 10 escenarios: 5 positivos y 5 negativos. Se validan códigos HTTP, estructura JSON y valores esperados. Después de registrar o actualizar se consulta el usuario para verificar la persistencia; después de eliminar se comprueba que ya no existe.

## Datos de prueba

Cada escenario prepara sus propios usuarios cuando los necesita. `DataGenerator.java` usa UUID para crear emails y contraseñas. Los casos de email duplicado crean expresamente los registros necesarios.

Los usuarios se conservan después de ejecutar las pruebas: no existe limpieza automática. Solo los escenarios de eliminación envían DELETE sobre sus propios registros. El caso de eliminar un ID inexistente crea y elimina primero su usuario, dentro de ese mismo escenario. El caso de búsqueda de ID inexistente genera uno de formato válido y comprueba su ausencia en el listado, sin borrar datos.

Los registros de ejecuciones anteriores permanecen disponibles para revisión manual. Ningún escenario toma usuarios ajenos del listado para modificarlos o eliminarlos.

## Organización y patrones utilizados

- **Separación de responsabilidades:** un feature por operación CRUD, un runner y helpers independientes.
- **Reutilización mediante helpers:** se reutilizan la generación de datos y la creación de usuarios. Los DELETE están directamente en los escenarios de eliminación.
- **Configuración por escenario:** `karate-config.js` define la URL base. No se comparten usuarios entre casos.
- **Tags:** permiten ejecutar casos positivos, negativos o una operación concreta.
- **Esquemas JSON:** los marcadores `#string`, `#number` y `#array` validan tipos; las comparaciones de mensajes y datos verifican el comportamiento.

## Alcance y límites

La suite se concentra en usuarios. No incluye carga, seguridad ni otros endpoints. Depende de ServeRest y de la red. Las instrucciones de instalación, comandos y reportes están en el README, separado de este informe.
