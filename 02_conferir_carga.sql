-- SQL Server 2022. Somente laboratório. Execução nativa pendente nesta distribuição.
USE TERE_CREDITO_LAB;
GO
SELECT COUNT(*) AS Clientes FROM dbo.CLIENTE; -- 3
SELECT COUNT(*) AS Propostas, SUM(ValorSolicitado) AS ValorSolicitado FROM dbo.PROPOSTA; -- 4 e 105000
SELECT COUNT(*) AS Contratos, SUM(ValorContratado) AS ValorContratado FROM dbo.CONTRATO; -- 2 e 70000
SELECT COUNT(*) AS Parcelas FROM dbo.PARCELA; -- 3
SELECT COUNT(*) AS Pagamentos, SUM(ValorPago) AS ValorPago FROM dbo.PAGAMENTO; -- 2 e 1500
