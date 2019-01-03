Site: 
https://www.amazon.co.uk
Pré-requisito: criar conta valida na amazon.co.uk
1 - Validar cenário de Criar conta nova: Criar conta nova com user já existente => validar que o site não permite
2 - tentar fazer login com o user e criado mas com password errada => deve falhar
3 - tentar fazer login com o user e criado e com password correta => deve ter sucesso
4 - pesquisar pelo livro: chasing Excellence
4.1 Confirmar que tenho resultado
4.2 Procurar pelo nome do autor. Validar se tem no nome Bergeron
4.3 Procurar nos comentários: identificar se temos comentário de user: Cerith Leighton Watkins
4.4 Inserir comentário: "gostei de ler"
4.5 Pesquisar por comentários com 1 estrela: 
4.6 Validar se existe algum comentário com a data de 17 September 2017
5. Pesquisar por "avengers"
5.1 verificar se o filme "Avengers Assemble" aparece nos resultados
5.2 clicar nesse titulo. Verificar se a descrição tem a string "S.H.I.E.L.D"
5.3 clicar em "watch Trailer". Tirar uma captura de ecran dos 10 segundos
6. No Shop by Department: selecionar Sports & Outdoors -> fitness
Procurar nas featured Brands se temos "Adidas" -> tirar foto

>>>> cucumber features/amazon.feature


7. https://www.amazon.jobs/en-gb
7.1 Pesquisar por empregos em "Portugal, setubal" => verificar que tenho 1 ou mais
7.2 Alterar o filtro para 5 mi => verificar que não tenho nenhum resultado
7.3 Pesquisar por "software" -> verificar que o autocomplete sugere software Development
7.4 Clicar na sugestão => software development e pesquisar. Na category filtrar por "Solutions Architect" => verificar se tenho algum para "San Francisco"

>>>> cucumber features/amazon_jobs.feature
