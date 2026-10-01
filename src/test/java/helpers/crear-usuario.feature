@ignore
Feature: Crear un usuario exclusivo para una prueba

  Scenario: Crear usuario
    * def DataGenerator = Java.type('helpers.DataGenerator')
    * def usuario = { nome: 'Usuario de prueba QA', email: '#(DataGenerator.generarEmail())', password: '#(DataGenerator.generarPassword())', administrador: 'true' }
    Given url baseUrl
    And path 'usuarios'
    And request usuario
    When method POST
    Then status 201
    * def idUsuario = response._id
    And match response == { message: 'Cadastro realizado com sucesso', _id: '#string' }
