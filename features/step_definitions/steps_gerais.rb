# encoding: utf-8
Given(/^Abro o navegador (firefox|chrome)$/) do |browser|
  case browser
    when 'firefox'
      obj = Navegador::Firefox.new
    else
      assert(false, "Navegador '#{browser}' ainda não é suportado para execução de testes.")
  end
  assert(!obj.nil?, "Erro a abrir navegador.")
end

And (/^Navego para o site (.*)$/) do |url|
  assert($browser.goto(url) == url, "Não foi possível aceder ao endereço '#{url}'.")
end

And (/^Fecho o navegador$/) {
  assert($browser.close, "Erro a fechar navegador.")
}

And(/^Tiro uma captura de ecrã$/) do
  $browser.screenshot.save 'screenshot.png'
end