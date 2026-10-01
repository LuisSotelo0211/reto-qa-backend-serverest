Feature: Actualizar usuario

  Background:
    * url 'https://serverest.dev'


  @happyPath @actualizarUsuario
  Scenario: Actualizar la información de un usuario existente

    # Obtener un usuario existente
    * def resultado = call read('classpath:helpers/obtener-usuario.feature')
    * def idUsuario = resultado.usuario._id
    * print 'ID del usuario a actualizar:', idUsuario

    # Generar datos dinámicos
    * def DataGenerator = Java.type('helpers.DataGenerator')
    * def emailDinamico = DataGenerator.generarEmail()
    * def passwordDinamico = DataGenerator.generarPassword()

    * def usuarioActualizado =
    """
    {
      "nome": "Prueba Actualizada",
      "email": "#(emailDinamico)",
      "password": "#(passwordDinamico)",
      "administrador": "true"
    }
    """

    Given path 'usuarios', idUsuario
    And request usuarioActualizado
    When method PUT
    Then status 200

    # Validar esquema de respuesta
    * def schemaActualizacion =
    """
    {
      "message": "#string"
    }
    """

    And match response == schemaActualizacion
    And match response.message == 'Registro alterado com sucesso'


  @unHappyPath @actualizarEmailDuplicado
  Scenario: No actualizar un usuario con un email ya registrado

    * def resultado = call read('classpath:helpers/obtener-usuario.feature')
    * def usuarios = resultado.usuarios
    * assert usuarios.length > 1

    * def idUsuario = usuarios[0]._id
    * def emailDuplicado = usuarios[1].email

    * def usuarioActualizado =
    """
    {
      "nome": "Luis Actualizado",
      "email": "#(emailDuplicado)",
      "password": "teste0211",
      "administrador": "true"
    }
    """

    Given path 'usuarios', idUsuario
    And request usuarioActualizado
    When method PUT
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