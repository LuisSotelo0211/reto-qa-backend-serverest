Feature: Listar usuarios

  Background:
    * url baseUrl

  @happyPath @listarUsuarios
  Scenario: Obtener la lista de usuarios correctamente
    * def creado = call read('classpath:helpers/crear-usuario.feature')

    Given path 'usuarios'
    When method GET
    Then status 200
    And match response.quantidade == '#number'
    And match response.usuarios == '#array'
    And match each response.usuarios == { nome: '#string', email: '#string', password: '#string', administrador: '#string', _id: '#string' }
    And match response.quantidade == response.usuarios.length
    And match response.usuarios[*]._id contains creado.idUsuario
