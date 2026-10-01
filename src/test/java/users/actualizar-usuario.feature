Feature: Actualizar usuario

  Background:
    * url baseUrl

  @happyPath @actualizarUsuario
  Scenario: Actualizar la información de un usuario existente
    * def creado = call read('classpath:helpers/crear-usuario.feature')
    * eval idsLimpieza.push(creado.idUsuario)
    * def DataGenerator = Java.type('helpers.DataGenerator')
    * def usuarioActualizado = { nome: 'Prueba Actualizada', email: '#(DataGenerator.generarEmail())', password: '#(DataGenerator.generarPassword())', administrador: 'false' }

    Given path 'usuarios', creado.idUsuario
    And request usuarioActualizado
    When method PUT
    Then status 200
    And match response == { message: 'Registro alterado com sucesso' }

    # Comprobar que los cambios realmente quedaron guardados.
    Given path 'usuarios', creado.idUsuario
    When method GET
    Then status 200
    And match response contains usuarioActualizado
    And match response._id == creado.idUsuario

  @unHappyPath @actualizarEmailDuplicado
  Scenario: No actualizar un usuario con un email ya registrado
    * def creado = call read('classpath:helpers/crear-usuario.feature')
    * eval idsLimpieza.push(creado.idUsuario)
    * def segundo = call read('classpath:helpers/crear-usuario.feature')
    * eval idsLimpieza.push(segundo.idUsuario)
    * copy usuarioActualizado = creado.usuario
    * set usuarioActualizado.email = segundo.usuario.email

    Given path 'usuarios', creado.idUsuario
    And request usuarioActualizado
    When method PUT
    Then status 400
    And match response == { message: 'Este email já está sendo usado' }

    Given path 'usuarios', creado.idUsuario
    When method GET
    Then status 200
    And match response contains creado.usuario
