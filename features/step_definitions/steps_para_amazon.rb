# encoding: utf-8
When(/^Crio uma conta nova com a seguinte informação$/) do |table|
  info         = table.hashes.first
  @new_account ||= Amazon::NewAccount.new($browser)
  @new_account.create_account(info)
end

Then(/^Verifico que a conta é criada (com|sem) sucesso$/) do |op|
  case (op)
    when 'com'
      assert(!@new_account.has_wrong_fields?, "Site não permite criação da conta.")
    when 'sem'
      assert(@new_account.has_wrong_fields?, "Site permite criação da conta.")
  end
end

When(/^Faço login com a seguinte informação$/) do |table|
  info   = table.hashes.first
  @login ||= Amazon::Login.new($browser)
  @login.login(info)
end

Then(/^Verifico que o login é realizado (com|sem) sucesso$/) do |op|
  case (op)
    when 'com'
      assert(!@login.has_sucess?, "Login realizado sem sucesso")
    when 'sem'
      assert(@login.has_sucess?, "Login realizado com sucesso.")
  end
end

And(/^É apresentada a mensagem de erro "([^"]*)"$/) do |msg|
  assert(@login.alert_presented?(msg), "Mensagem '#{msg}' não apresentada.")
end

When(/^Faço uma pesquisa por "([^"]*)"$/) do |text|
  @search ||= Amazon::Search.new($browser)
  @search.search(text)
end

Then(/^Verifico que há resultados$/) do
  assert(@search.has_results?, "A pesquisa não obteve nenhum resultado.")
end

And(/^Filtro por "([^"]*)"$/) do |aut|
  assert(@search.filter(aut), "Filtro '#{aut}' não encontrado.")
end

And(/^Seleciono o primeiro resultado obtido$/) do
  @search.select_first_result
  @produto ||= Amazon::Produto.new($browser)
end

And(/^Pesquiso por comentários do utilizador "([^"]*)"$/) do |user|
  @produto.search_review_by_user(user)
end

And(/^Insiro o comentário "([^"]*)"$/) do |comment|
  @produto.insert_comment_to_review(comment)
end

And(/^Pesquiso por comentários de "([^"]*)" estrela$/) do |stars|
  @produto.filter_reviews_by_stars(stars)
end

And(/^Valido que existe comentário com a data "([^"]*)"/) do |data|
  assert(@produto.search_review_by_date(data), "Nenhum comentário encontrado para a data '#{data}'")
end

And(/^Seleciono "([^"]*)"/) do |text|
  @search.select(text)
  @produto ||= Amazon::Produto.new($browser)
end

And(/^Verifico que a descrição contém o texto "([^"]*)"/) do |text|
  assert(@produto.description_include?(text), "'#{text}' não está presente na descrição do produto.")
end

And(/^Faço uma captura de "([^"]*)" segundos do trailer/) do |dur|
  @produto.capture_trailer(dur)
end

When(/^Escolho no departamento "([^"]*)" a área "([^"]*)"$/) do |dep, area|
  @shop ||= Amazon::ShopByDepartment.new($browser)
  @shop.select_dep_and_area(dep, area)
end

Then(/^Verifico que existe a marca "([^"]*)"$/) do |marca|
  assert(@shop.brand_exists?(marca), "A marca '#{marca}' não foi encontrada.")
end