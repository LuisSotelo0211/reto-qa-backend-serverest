Feature: Buscar usuario por ID

  Background:
    * url baseUrl

  @happyPath @buscarUsuario
  Scenario: Buscar un usuario existente por su ID
    * def creado = call read('classpath:helpers/crear-usuario.feature')
    * eval idsLimpieza.push(creado.idUsuario)

    Given path 'usuarios', creado.idUsuario
    When method GET
    Then status 200
    And match response == { nome: '#string', email: '#string', password: '#string', administrador: '#string', _id: '#string' }
    And match response contains creado.usuario
    And match response._id == creado.idUsuario

  @unHappyPath @usuarioIdInexistente
  Scenario: Buscar un usuario con ID inexistente
    * def creado = call read('classpath:helpers/crear-usuario.feature')
    * eval idsLimpieza.push(creado.idUsuario)
    # El ID pertenece a esta prueba y deja de existir tras eliminarlo.
    * call read('classpath:helpers/eliminar-usuario.feature') { idUsuario: '#(creado.idUsuario)' }

    Given path 'usuarios', creado.idUsuario
    When method GET
    Then status 400
    And match response == { message: 'Usuário não encontrado' }

  @unHappyPath @usuarioIdInvalido
  Scenario: Buscar un usuario con ID de longitud inválida
    Given path 'usuarios', 'IDcorto'
    When method GET
    Then status 400
    And match response == { id: 'id deve ter exatamente 16 caracteres alfanuméricos' }
