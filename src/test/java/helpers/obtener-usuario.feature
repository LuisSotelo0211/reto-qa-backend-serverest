Feature: Helper para obtener un usuario existente

  Scenario: Obtener un usuario existente para las pruebas
    Given url 'https://serverest.dev'
    And path 'usuarios'
    When method GET
    Then status 200
    And match response.usuarios == '#array'
    And assert response.usuarios.length > 0

    * def usuarios = response.usuarios
    * def indice = Math.floor(Math.random() * usuarios.length)
    * def usuario = usuarios[indice]

    * print 'Usuario seleccionado:', usuario