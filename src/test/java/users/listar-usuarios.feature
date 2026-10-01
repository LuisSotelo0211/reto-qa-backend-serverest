Feature: Gestión de usuarios

  Background:
    * url 'https://serverest.dev'

  @happyPath @listarUsuarios
  Scenario: Obtener la lista de usuarios correctamente

    Given path 'usuarios'
    When method GET
    Then status 200

    # Validar esquema de cada usuario
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

    # Validar esquema general de la respuesta
    And match response.quantidade == '#number'
    And match response.usuarios == '#array'
    And match each response.usuarios == schemaUsuario

    # Validar que la cantidad coincida con el número de usuarios
    And match response.quantidade == response.usuarios.length