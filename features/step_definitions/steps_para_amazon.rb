# encoding: utf-8
When(/^Crio uma conta nova com a seguinte informação$/) do |table|
  dados       = table.hashes.first
  @nova_conta = Amazon::NovaConta.new
  @nova_conta.criar(dados)
end

Then(/^Verifico que a conta é criada (com|sem) sucesso$/) do |sucesso|
  case (sucesso)
    when 'com'
      assert(!@nova_conta.campos_errados?, "Site não permite criação da conta.")
    when 'sem'
      assert(@nova_conta.campos_errados?, "Site permite criação da conta.")
  end
end

When(/^Faço login com a seguinte informação$/) do |table|
  dados  = table.hashes.first
  @login = Amazon::Login.new
  @login.login(dados)
end

Then(/^Verifico que o login é realizado (com|sem) sucesso$/) do |sucesso|
  case (sucesso)
    when 'com'
      assert(!@login.sucesso?, "Login realizado sem sucesso")
    when 'sem'
      assert(@login.sucesso?, "Login realizado com sucesso.")
  end
end

And(/^É apresentada a mensagem de erro "([^"]*)" no login$/) do |sucesso|
  assert(@login.apresenta_mensagem?(sucesso), "Mensagem não apresentada.")
end

When(/^Faço uma pesquisa por "([^"]*)"$/) do |texto|
  @pesquisa = Amazon::Pesquisa.new
  @pesquisa.pesquisa(texto)
end

Then(/^Verifico que houve resultados$/) do
  assert(@pesquisa.existem_resultados?, "A pesquisa não obteve nenhum resultado.")
end

And(/^Filtro por "([^"]*)"$/) do |autor|
  assert(@pesquisa.filtrar(autor), "Filtro '#{autor}' não encontrado.")
end

And(/^Seleciono o primeiro resultado obtido$/) do
  @pesquisa.selecionar_resultado
  @produto = Amazon::Produto.new
end

And(/^Pesquiso por comentários do utilizador "([^"]*)"$/) do |utilizador|
  @produto.pesquiso_comentario_do_utilizador(utilizador)
end

And(/^Insiro o comentário "([^"]*)"$/) do |comment|
  @produto.inserir_comentario(comment)
end

And(/^Pesquiso por comentários de "([^"]*)" estrela$/) do |estrelas|
  @produto.pesquiso_comentarios_por_estrela(estrelas)
end

And(/^Valido que existe comentário com a data "([^"]*)"/) do |data|
  assert(@produto.pesquiso_comentario_por_data(data), "Nenhum comentário encontrado para a data '#{data}'")
end

And(/^Seleciono "([^"]*)"/) do |titulo|
  @produto ||= Amazon::Produto.new
  assert(@produto.clicar_em_titulo(titulo), "Filme #{titulo} não encontrado")
end

And(/^Verifico que a descrição contém o texto "([^"]*)"/) do |texto|
  assert(@produto.descricao_contem_texto?(texto), "'#{texto}' não está presente na descrição do filme.")
end

And(/^Faço uma captura de "([^"]*)" segundos do trailer/) do |duracao|
  @produto.capturar_trailer(duracao)
end

When(/^Escolho no departamento "([^"]*)" a área "([^"]*)"$/) do |departamento, area|
  @shop = Amazon::ShopByDepartment.new
  @shop.selecionar(departamento, area)
end

Then(/^Verifico que existe a marca "([^"]*)"$/) do |marca|
  assert(@shop.marca_existe?(marca), "A marca '#{marca}' não foi encontrada.")
end