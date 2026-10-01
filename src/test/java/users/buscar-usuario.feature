Feature: Buscar usuario por ID

  Background:
    * url 'https://serverest.dev'


  @happyPath @buscarUsuario
  Scenario: Buscar un usuario existente por su ID

    * def resultado = call read('classpath:helpers/obtener-usuario.feature')
    * def idUsuario = resultado.usuario._id
    * print 'ID obtenido automáticamente:', idUsuario

    Given path 'usuarios', idUsuario
    When method GET
    Then status 200

    # Validar esquema de respuesta
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
    And match response._id == idUsuario


  @unHappyPath @usuarioIdInexistente
  Scenario: Buscar un usuario con ID inexistente

    * def idUsuario = 'XCyAj6sxjhwvNXL1'

    Given path 'usuarios', idUsuario
    When method GET
    Then status 400

    # Validar esquema de respuesta de error
    * def schemaError =
    """
    {
      "message": "#string"
    }
    """

    And match response == schemaError
    And match response.message == 'Usuário não encontrado'


  @unHappyPath @usuarioIdInvalido
  Scenario: Buscar un usuario con ID de longitud inválida

    * def idUsuario = 'XCyAj6sxjhwvN'

    Given path 'usuarios', idUsuario
    When method GET
    Then status 400

    # Validar esquema de respuesta de ID inválido
    * def schemaErrorId =
    """
    {
      "id": "#string"
    }
    """

    And match response == schemaErrorId
    And match response.id == 'id deve ter exatamente 16 caracteres alfanuméricos'