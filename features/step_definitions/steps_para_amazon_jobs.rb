# encoding: utf-8
When(/^Na página inicial, procuro empregos por$/) do |table|
  table = table.hashes.first
  @jobs ||= AmazonJobs::Home.new($browser)
  @jobs.search(table)
end

Then(/^Valido que (não |)?existem empregos$/) do |empregos|
  @search ||= AmazonJobs::Search.new($browser)
  if empregos.empty?
    assert(@search.jobs_available?, "A pesquisa não devolveu resultados.")
  else
    assert(!@search.jobs_available?, "A pesquisa devolveu resultados.")
  end
end

When(/^Filtro por$/) do |table|
  table = table.hashes.first
  @search ||= AmazonJobs::Search.new($browser)
  @search.filter(table)
end

When(/^Procuro empregos por$/) do |table|
  table = table.hashes.first
  @search ||= AmazonJobs::Search.new($browser)
  @search.search(table)
end