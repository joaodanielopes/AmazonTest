Feature: Testes ao site da Amazon.jobs/en-gb

  Background:
    Given Abro o navegador firefox
    And Navego para o site https://www.amazon.jobs/en-gb/

  Scenario: Procurar empregos
    When Na página inicial, procuro empregos por
      | localizacao       |
      | Portugal, setubal |
    Then Valido que existem empregos
    When Filtro por
      | distancia |
      | 5 mi      |
    Then Valido que não existem empregos
    When Procuro empregos por
      | tipo     | tipo_autocomplete    |
      | software | Software Development |
    Then Valido que existem empregos
    And Filtro por
      | categoria           | cidade        |
      | Solutions Architect | San Francisco |
    And Fecho o navegador