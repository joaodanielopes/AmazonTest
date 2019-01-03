# encoding: utf-8
When(/^Na página inicial, procuro empregos por$/) do |table|
  table = table.hashes.first
  @jobs = Amazon::Jobs.new
  @jobs.pesquisar_na_pagina_inicial(table)
end

Then(/^Valido que (não |)?existem empregos$/) do |empregos|
  if empregos.empty?
    assert(@jobs.existem_empregos?, "A pesquisa não devolveu resultados.")
  else
    assert(!@jobs.existem_empregos?, "A pesquisa devolveu resultados.")
  end
end

When(/^Filtro por$/) do |table|
  table = table.hashes.first
  @jobs = Amazon::Jobs.new
  @jobs.filtrar(table)
end

When(/^Procuro empregos por$/) do |table|
  table = table.hashes.first
  @jobs = Amazon::Jobs.new
  @jobs.pesquisar(table)
end