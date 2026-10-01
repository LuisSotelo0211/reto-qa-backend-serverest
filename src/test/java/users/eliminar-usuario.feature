Feature: Eliminar usuario

  Background:
    * url 'https://serverest.dev'


  @happyPath @eliminarUsuario
  Scenario: Eliminar un usuario existente

    * def resultado = call read('classpath:helpers/obtener-usuario.feature')
    * def idUsuario = resultado.usuario._id

    * print 'ID del usuario a eliminar:', idUsuario

    Given path 'usuarios', idUsuario
    When method DELETE
    Then status 200

    # Validar esquema de respuesta
    * def schemaEliminacion =
    """
    {
      "message": "#string"
    }
    """

    And match response == schemaEliminacion
    And match response.message == 'Registro excluído com sucesso'


  @unHappyPath @eliminarUsuarioInexistente
  Scenario: Intentar eliminar un usuario inexistente

    * def idUsuario = 'XCyAj6sxjhwvNXLx'

    Given path 'usuarios', idUsuario
    When method DELETE
    Then status 200

    # Validar esquema de respuesta
    * def schemaEliminacion =
    """
    {
      "message": "#string"
    }
    """

    And match response == schemaEliminacion
    And match response.message == 'Nenhum registro excluído'