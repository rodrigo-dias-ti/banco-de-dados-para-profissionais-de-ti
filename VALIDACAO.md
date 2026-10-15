# Estado da validação

Distribuição inicial de 15 de outubro de 2026. SQL Server 2022, banco de estudo TERE_CREDITO_LAB.

Preparação, gabarito e escala tiveram seus comandos conferidos contra os materiais locais. Preparação e escala correspondem ao Apêndice A do livro. Execução nativa em SQL Server ainda pendente nesta distribuição.

Resultados previstos: três clientes; quatro propostas totalizando 105000; dois contratos totalizando 70000; três parcelas; dois pagamentos totalizando 1500. JOIN ingênuo de contratos e parcelas soma 110000. Saldos: 0, 1000 e 1000. São previsões conferidas logicamente, não resultados de execução nativa.

Execute na ordem do README somente em laboratório. Para classificar a distribuição como validada, registrar versão do mecanismo, ferramenta, data, resultados, restrições e rollback. PostgreSQL e Oracle exigem scripts próprios; não há portabilidade direta destes scripts T-SQL.
