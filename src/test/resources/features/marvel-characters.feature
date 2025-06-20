Feature: Pruebas API Marvel Characters
  Pruebas automatizadas para los endpoints principales de la API de personajes de Marvel.

  Background:
    * url baseUrl

  Scenario: Obtener todos los personajes (GET)
    # No agregamos path para evitar el slash final
    When method get
    Then status 200
    And match response == []

  Scenario: Crear personaje exitoso (POST)
    Given request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    And match response.name == 'Iron Man'
    And match response.alterego == 'Tony Stark'
    And match response.powers contains 'Armor'
    * def characterId = response.id

  Scenario: Actualizar personaje exitoso (PUT)
    # Creamos el personaje primero
    * def characterName = 'Iron Man-' + java.util.UUID.randomUUID().toString()
    Given request { name: '#(characterName)', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    * def characterId = response.id
    # Ahora actualizamos
    Given path characterId
    And request { name: '#(characterName)', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    And header Content-Type = 'application/json'
    When method put
    Then status 200
    And match response.description == 'Updated description'

  Scenario: Eliminar personaje exitoso (DELETE)
    # Primero creamos el personaje para asegurar que existe
    * def characterName = 'Iron Man-' + java.util.UUID.randomUUID().toString()
    Given request { name: '#(characterName)', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    * def characterId = response.id
    # Ahora eliminamos
    Given path characterId
    When method delete
    Then status 204