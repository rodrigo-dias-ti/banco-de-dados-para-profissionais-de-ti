-- SQL Server 2022. Somente laboratório. Execução nativa pendente.
-- Tabela separada: não modifica o conjunto canônico dos exercícios.
USE TERE_CREDITO_LAB;
GO
IF OBJECT_ID(N'dbo.PROPOSTA_VOLUME',N'U') IS NOT NULL
 THROW 50002,'PROPOSTA_VOLUME já existe.',1;
CREATE TABLE dbo.PROPOSTA_VOLUME (
 IdProposta bigint NOT NULL PRIMARY KEY,
 StatusProposta varchar(30) NOT NULL,
 DataProposta datetime2(0) NOT NULL,
 ValorSolicitado decimal(18,2) NOT NULL
);
WITH Digitos AS (
 SELECT n FROM (VALUES(0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) d(n)
), Numeros AS (
 SELECT a.n+10*b.n+100*c.n+1000*d.n+10000*e.n AS n
 FROM Digitos a CROSS JOIN Digitos b CROSS JOIN Digitos c
 CROSS JOIN Digitos d CROSS JOIN Digitos e
)
INSERT dbo.PROPOSTA_VOLUME
SELECT n+1, CASE WHEN n%100=0 THEN 'PENDENTE_DOCUMENTO' ELSE 'APROVADA' END,
 DATEADD(minute,n,CONVERT(datetime2(0),'20260101')),
 CAST(10000+n%5000 AS decimal(18,2))
FROM Numeros WHERE n<50000;
SET STATISTICS IO ON;
SELECT COUNT(*) FROM dbo.PROPOSTA_VOLUME WHERE StatusProposta='PENDENTE_DOCUMENTO';
CREATE INDEX IX_VOLUME_Status_Data ON dbo.PROPOSTA_VOLUME (StatusProposta,DataProposta);
SELECT COUNT(*) FROM dbo.PROPOSTA_VOLUME WHERE StatusProposta='PENDENTE_DOCUMENTO';
SET STATISTICS IO OFF;
-- Esperado: 500 pendentes. Compare leituras e plano na mesma população.
-- Não limpe caches compartilhados. O tempo depende do ambiente de estudo.
