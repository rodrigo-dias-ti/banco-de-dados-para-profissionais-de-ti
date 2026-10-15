-- SQL Server 2022. Somente laboratório. Execução nativa pendente nesta distribuição.
USE TERE_CREDITO_LAB;
GO
-- 1: uma linha por conjunto, sem JOIN multiplicador.
SELECT COUNT(*) AS QuantidadePropostas, SUM(ValorSolicitado) AS ValorTotalSolicitado FROM dbo.PROPOSTA;
-- 2: um cliente pode ter várias propostas.
SELECT c.IdCliente,c.NomeCliente,p.IdProposta,p.StatusProposta
FROM dbo.CLIENTE AS c JOIN dbo.PROPOSTA AS p ON p.IdCliente=c.IdCliente
WHERE c.IdCliente=1 ORDER BY p.IdProposta;
-- 3: 70000 no conjunto de contratos; 110000 depois do JOIN ingênuo.
SELECT SUM(ValorContratado) AS TotalContratos FROM dbo.CONTRATO;
SELECT SUM(c.ValorContratado) AS TotalMultiplicado
FROM dbo.CONTRATO AS c JOIN dbo.PARCELA AS p ON p.IdContrato=c.IdContrato;
-- Pré-agregação para uma linha por contrato no lado das parcelas.
WITH ParcelasPorContrato AS (
 SELECT IdContrato,COUNT(*) AS QuantidadeParcelas,SUM(ValorParcela) AS ValorParcelasAmostra
 FROM dbo.PARCELA GROUP BY IdContrato
)
SELECT c.IdContrato,c.ValorContratado,p.QuantidadeParcelas,p.ValorParcelasAmostra
FROM dbo.CONTRATO AS c LEFT JOIN ParcelasPorContrato AS p ON p.IdContrato=c.IdContrato
ORDER BY c.IdContrato;
-- 4: pagamentos agregados, ausência preservada e saldo por parcela.
WITH Recebimentos AS (
 SELECT IdParcela,SUM(ValorPago) AS TotalPago FROM dbo.PAGAMENTO GROUP BY IdParcela
)
SELECT p.IdParcela,p.ValorParcela,COALESCE(r.TotalPago,0) AS TotalPago,
 p.ValorParcela-COALESCE(r.TotalPago,0) AS Saldo
FROM dbo.PARCELA AS p LEFT JOIN Recebimentos AS r ON r.IdParcela=p.IdParcela
ORDER BY p.IdParcela;
-- 5: a cópia é criada ANTES da transação para sobreviver ao ROLLBACK.
IF OBJECT_ID('tempdb..#ParcelaExercicio') IS NOT NULL
 THROW 50010,'A tabela temporária já existe nesta sessão.',1;
SELECT IdParcela,ValorParcela INTO #ParcelaExercicio FROM dbo.PARCELA WHERE IdParcela=1002;
SET XACT_ABORT ON;
BEGIN TRY
 BEGIN TRANSACTION;
 UPDATE #ParcelaExercicio SET ValorParcela=1100 WHERE IdParcela=1002;
 IF @@ROWCOUNT<>1
  THROW 50011,'Quantidade de linhas inesperada.',1;
 SELECT * FROM #ParcelaExercicio; -- 1100 dentro da transação.
 ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
 IF XACT_STATE()<>0 ROLLBACK TRANSACTION;
 THROW;
END CATCH;
SELECT * FROM #ParcelaExercicio; -- 1000 após a reversão.
