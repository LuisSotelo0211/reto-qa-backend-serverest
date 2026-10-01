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

Cada escenario prepara sus propios usuarios. `DataGenerator.java` usa UUID para crear emails y contraseñas. Los casos de email duplicado crean expresamente los registros necesarios. Para probar un ID inexistente se crea y elimina un usuario propio antes de consultar o intentar eliminar ese ID.

Cada escenario guarda sus IDs en `idsLimpieza`. El hook `afterScenario` llama al helper de eliminación al terminar, incluso si falla una aserción. La limpieza acepta que el usuario ya haya sido eliminado por el caso. No se actualizan ni eliminan usuarios tomados al azar del listado público. Una interrupción del proceso o caída de red puede impedir la limpieza y debe revisarse en los reportes.

## Organización y patrones utilizados

- **Separación de responsabilidades:** un feature por operación CRUD, un runner y helpers independientes.
- **Reutilización mediante helpers:** la creación y limpieza se centralizan; los escenarios mantienen visibles las acciones que verifican.
- **Configuración por escenario:** `karate-config.js` define la URL, los IDs propios y la limpieza. No se comparten usuarios entre casos.
- **Tags:** permiten ejecutar casos positivos, negativos o una operación concreta.
- **Esquemas JSON:** los marcadores `#string`, `#number` y `#array` validan tipos; las comparaciones de mensajes y datos verifican el comportamiento.

## Alcance y límites

La suite se concentra en usuarios. No incluye carga, seguridad ni otros endpoints. Depende de ServeRest y de la red. Las instrucciones de instalación, comandos y reportes están en el README, separado de este informe.
