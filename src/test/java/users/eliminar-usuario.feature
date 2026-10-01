Feature: Eliminar usuario

  Background:
    * url baseUrl

  @happyPath @eliminarUsuario
  Scenario: Eliminar un usuario existente
    * def creado = call read('classpath:helpers/crear-usuario.feature')

    Given path 'usuarios', creado.idUsuario
    When method DELETE
    Then status 200
    And match response == { message: 'Registro excluído com sucesso' }

    Given path 'usuarios', creado.idUsuario
    When method GET
    Then status 400
    And match response == { message: 'Usuário não encontrado' }

  @unHappyPath @eliminarUsuarioInexistente
  Scenario: Intentar eliminar un usuario inexistente
    * def creado = call read('classpath:helpers/crear-usuario.feature')

    # Eliminar primero el usuario propio para dejar su ID inexistente.
    Given path 'usuarios', creado.idUsuario
    When method DELETE
    Then status 200
    And match response == { message: 'Registro excluído com sucesso' }

    Given path 'usuarios', creado.idUsuario
    When method DELETE
    Then status 200
    And match response == { message: 'Nenhum registro excluído' }
