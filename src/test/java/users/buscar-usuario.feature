Feature: Buscar usuario por ID

  Background:
    * url baseUrl

  @happyPath @buscarUsuario
  Scenario: Buscar un usuario existente por su ID
    * def creado = call read('classpath:helpers/crear-usuario.feature')

    Given path 'usuarios', creado.idUsuario
    When method GET
    Then status 200
    And match response == { nome: '#string', email: '#string', password: '#string', administrador: '#string', _id: '#string' }
    And match response contains creado.usuario
    And match response._id == creado.idUsuario

  @unHappyPath @usuarioIdInexistente
  Scenario: Buscar un usuario con ID inexistente
    # Generar un ID de formato válido sin crear ni eliminar usuarios.
    * def idInexistente = Java.type('java.util.UUID').randomUUID().toString().replace(/-/g, '').substring(0, 16)
    Given path 'usuarios'
    When method GET
    Then status 200
    And match response.usuarios[*]._id !contains idInexistente

    Given path 'usuarios', idInexistente
    When method GET
    Then status 400
    And match response == { message: 'Usuário não encontrado' }

  @unHappyPath @usuarioIdInvalido
  Scenario: Buscar un usuario con ID de longitud inválida
    Given path 'usuarios', 'IDcorto'
    When method GET
    Then status 400
    And match response == { id: 'id deve ter exatamente 16 caracteres alfanuméricos' }
