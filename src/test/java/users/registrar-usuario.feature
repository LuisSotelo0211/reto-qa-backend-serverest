Feature: Registrar usuarios

  Background:
    * url 'https://serverest.dev'


  @happyPath @registrarUsuario
  Scenario: Registrar un usuario correctamente

    # Generar datos dinámicos
    * def DataGenerator = Java.type('helpers.DataGenerator')
    * def emailDinamico = DataGenerator.generarEmail()
    * def passwordDinamico = DataGenerator.generarPassword()

    * def nuevoUsuario =
    """
    {
      "nome": "Prueba 23",
      "email": "#(emailDinamico)",
      "password": "#(passwordDinamico)",
      "administrador": "true"
    }
    """

    Given path 'usuarios'
    And request nuevoUsuario
    When method POST
    Then status 201

    # Validar esquema de respuesta
    * def schemaRegistro =
    """
    {
      "message": "#string",
      "_id": "#string"
    }
    """

    And match response == schemaRegistro
    And match response.message == 'Cadastro realizado com sucesso'


  @unHappyPath @usuarioEmailDuplicado
  Scenario: No registrar un usuario con email duplicado

    # Obtener usuarios existentes
    * def resultado = call read('classpath:helpers/obtener-usuario.feature')
    * def emailExistente = resultado.usuario.email

    * print 'Email existente utilizado:', emailExistente

    # Generar contraseña dinámica
    * def DataGenerator = Java.type('helpers.DataGenerator')
    * def passwordDinamico = DataGenerator.generarPassword()

    * def usuarioDuplicado =
    """
    {
      "nome": "Usuario Duplicado",
      "email": "#(emailExistente)",
      "password": "#(passwordDinamico)",
      "administrador": "true"
    }
    """

    Given path 'usuarios'
    And request usuarioDuplicado
    When method POST
    Then status 400

    # Validar esquema de respuesta de error
    * def schemaError =
    """
    {
      "message": "#string"
    }
    """

    And match response == schemaError
    And match response.message == 'Este email já está sendo usado'