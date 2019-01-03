Feature: Testes ao site da Amazon.co.uk

  Background:
    Given Abro o navegador firefox
    And Navego para o site https://www.amazon.co.uk/


  Scenario: Criar conta nova com user existente
    When Crio uma conta nova com a seguinte informação
      | nome          | email                               | password        |
      | testGoContact | teste.1.teste.2.teste.123@gmail.com | test_go_contact |
    Then Verifico que a conta é criada sem sucesso
    And Fecho o navegador


  Scenario: Fazer login com password errada
    When Faço login com a seguinte informação
      | email                               | password               |
      | teste.1.teste.2.teste.123@gmail.com | test_go_contact_errada |
    Then Verifico que o login é realizado sem sucesso
    And É apresentada a mensagem de erro "Your password is incorrect" no login
    And Fecho o navegador


  Scenario: Fazer login com sucesso
    When Faço login com a seguinte informação
      | email                               | password        |
      | teste.1.teste.2.teste.123@gmail.com | test_go_contact |
    Then Verifico que o login é realizado com sucesso
    And Fecho o navegador


  Scenario: Pesquisar livro
    And Faço login com a seguinte informação
      | email                               | password        |
      | teste.1.teste.2.teste.123@gmail.com | test_go_contact |
    When Faço uma pesquisa por "chasing Excellence"
    Then Verifico que houve resultados
    And Filtro por "Bergeron"
    And Seleciono o primeiro resultado obtido
    When Pesquiso por comentários do utilizador "Cerith Leighton Watkins"
    Then Insiro o comentário "gostei de ler"
    When Pesquiso por comentários de "1" estrela
    Then Valido que existe comentário com a data "17 September 2017"
    And Fecho o navegador


  Scenario: Pesquisar filme
    When Faço uma pesquisa por "avengers"
    Then Verifico que houve resultados
    And Seleciono "Avengers Assemble"
    And Verifico que a descrição contém o texto "S.H.I.E.L.D"
    And Faço uma captura de "10" segundos do trailer
    And Fecho o navegador


  Scenario: Shop by Department
    When Escolho no departamento "Sports & Outdoors" a área "Fitness"
    Then Verifico que existe a marca "Adidas"
    And Tiro uma captura de ecrã
    And Fecho o navegador