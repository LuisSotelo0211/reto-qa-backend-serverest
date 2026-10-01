Feature: Registrar usuarios

  Background:
    * url baseUrl
    * def DataGenerator = Java.type('helpers.DataGenerator')

  @happyPath @registrarUsuario
  Scenario: Registrar un usuario correctamente
    * def nuevoUsuario = { nome: 'Usuario QA', email: '#(DataGenerator.generarEmail())', password: '#(DataGenerator.generarPassword())', administrador: 'true' }

    Given path 'usuarios'
    And request nuevoUsuario
    When method POST
    Then status 201
    * def idUsuario = response._id
    * print 'Usuario creado (se conserva):', idUsuario, nuevoUsuario.email
    And match response == { message: 'Cadastro realizado com sucesso', _id: '#string' }

    Given path 'usuarios', idUsuario
    When method GET
    Then status 200
    And match response contains nuevoUsuario
    And match response._id == idUsuario

  @unHappyPath @usuarioEmailDuplicado
  Scenario: No registrar un usuario con email duplicado
    * def creado = call read('classpath:helpers/crear-usuario.feature')
    * def usuarioDuplicado = { nome: 'Usuario Duplicado', email: '#(creado.usuario.email)', password: '#(DataGenerator.generarPassword())', administrador: 'true' }

    Given path 'usuarios'
    And request usuarioDuplicado
    When method POST
    Then status 400
    And match response == { message: 'Este email já está sendo usado' }
