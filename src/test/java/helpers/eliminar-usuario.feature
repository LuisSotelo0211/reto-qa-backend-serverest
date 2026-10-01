@ignore
Feature: Limpiar únicamente un usuario creado por la prueba

  Scenario: Eliminar usuario de prueba
    Given url baseUrl
    And path 'usuarios', idUsuario
    When method DELETE
    Then status 200
    And match response == { message: '#string' }
    And assert response.message == 'Registro excluído com sucesso' || response.message == 'Nenhum registro excluído'
