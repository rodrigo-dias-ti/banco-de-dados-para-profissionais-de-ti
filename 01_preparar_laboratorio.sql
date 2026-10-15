-- SQL Server 2022. Apenas ambiente de estudo. Dados fictícios.
-- Conferência editorial realizada; execução nativa pendente nesta distribuição.
-- Preparação administrativa opcional em instância de estudo:
-- CREATE DATABASE TERE_CREDITO_LAB;
-- GO
USE TERE_CREDITO_LAB;
GO
SET XACT_ABORT ON;
IF OBJECT_ID(N'dbo.CLIENTE', N'U') IS NOT NULL
 OR OBJECT_ID(N'dbo.PROPOSTA', N'U') IS NOT NULL
 OR OBJECT_ID(N'dbo.ANALISE_CREDITO', N'U') IS NOT NULL
 OR OBJECT_ID(N'dbo.HISTORICO_PROPOSTA', N'U') IS NOT NULL
 OR OBJECT_ID(N'dbo.CONTRATO', N'U') IS NOT NULL
 OR OBJECT_ID(N'dbo.PARCELA', N'U') IS NOT NULL
 OR OBJECT_ID(N'dbo.PAGAMENTO', N'U') IS NOT NULL
 THROW 50000, 'A base precisa estar vazia para este laboratório.', 1;
BEGIN TRY
 BEGIN TRANSACTION;
 CREATE TABLE dbo.CLIENTE (
 IdCliente int NOT NULL,
 NomeCliente nvarchar(100) NOT NULL,
 DocumentoFicticio varchar(20) NOT NULL,
 DataCadastro datetime2(0) NOT NULL,
 CONSTRAINT PK_CLIENTE PRIMARY KEY (IdCliente),
 CONSTRAINT UQ_CLIENTE_Documento UNIQUE (DocumentoFicticio)
 );
 CREATE TABLE dbo.PROPOSTA (
 IdProposta bigint NOT NULL,
 NumeroProposta varchar(20) NOT NULL,
 IdCliente int NOT NULL,
 StatusProposta varchar(30) NOT NULL,
 ValorSolicitado decimal(18,2) NOT NULL,
 DataProposta datetime2(0) NOT NULL,
 DataDecisao datetime2(0) NULL,
 DataAtualizacao datetime2(0) NOT NULL,
 VersaoStatus int NOT NULL,
 CONSTRAINT PK_PROPOSTA PRIMARY KEY (IdProposta),
 CONSTRAINT UQ_PROPOSTA_Numero UNIQUE (NumeroProposta),
 CONSTRAINT FK_PROPOSTA_CLIENTE FOREIGN KEY (IdCliente) REFERENCES dbo.CLIENTE (IdCliente),
 CONSTRAINT CK_PROPOSTA_Valor CHECK (ValorSolicitado > 0),
 CONSTRAINT CK_PROPOSTA_Versao CHECK (VersaoStatus > 0),
 CONSTRAINT CK_PROPOSTA_Status CHECK (StatusProposta IN
 ('EM_ANALISE','APROVADA','RECUSADA','PENDENTE_DOCUMENTO','CANCELADA'))
 );
 CREATE TABLE dbo.ANALISE_CREDITO (
 IdAnalise bigint NOT NULL PRIMARY KEY,
 IdProposta bigint NOT NULL,
 Resultado varchar(30) NOT NULL,
 DataAnalise datetime2(0) NOT NULL,
 CONSTRAINT FK_ANALISE_PROPOSTA FOREIGN KEY (IdProposta) REFERENCES dbo.PROPOSTA (IdProposta)
 );
 CREATE TABLE dbo.HISTORICO_PROPOSTA (
 IdHistorico bigint NOT NULL PRIMARY KEY,
 IdProposta bigint NOT NULL,
 StatusAnterior varchar(30) NOT NULL,
 StatusNovo varchar(30) NOT NULL,
 VersaoStatus int NOT NULL,
 DataEvento datetime2(0) NOT NULL,
 CONSTRAINT FK_HISTORICO_PROPOSTA FOREIGN KEY (IdProposta) REFERENCES dbo.PROPOSTA (IdProposta),
 CONSTRAINT UQ_HISTORICO_Versao UNIQUE (IdProposta, VersaoStatus)
 );
 CREATE TABLE dbo.CONTRATO (
 IdContrato bigint NOT NULL PRIMARY KEY,
 IdProposta bigint NOT NULL UNIQUE,
 NumeroContrato varchar(20) NOT NULL UNIQUE,
 StatusContrato varchar(20) NOT NULL,
 ValorContratado decimal(18,2) NOT NULL,
 DataContrato datetime2(0) NOT NULL,
 CONSTRAINT FK_CONTRATO_PROPOSTA FOREIGN KEY (IdProposta) REFERENCES dbo.PROPOSTA (IdProposta),
 CONSTRAINT CK_CONTRATO_Valor CHECK (ValorContratado > 0)
 );
 CREATE TABLE dbo.PARCELA (
 IdParcela bigint NOT NULL PRIMARY KEY,
 IdContrato bigint NOT NULL,
 NumeroParcela int NOT NULL,
 DataVencimento date NOT NULL,
 ValorParcela decimal(18,2) NOT NULL,
 StatusParcela varchar(20) NOT NULL,
 CONSTRAINT FK_PARCELA_CONTRATO FOREIGN KEY (IdContrato) REFERENCES dbo.CONTRATO (IdContrato),
 CONSTRAINT UQ_PARCELA_Numero UNIQUE (IdContrato, NumeroParcela),
 CONSTRAINT CK_PARCELA_Valor CHECK (ValorParcela > 0),
 CONSTRAINT CK_PARCELA_Numero CHECK (NumeroParcela > 0),
 CONSTRAINT CK_PARCELA_Status CHECK (StatusParcela IN ('ABERTA','PARCIAL','PAGA'))
 );
 CREATE TABLE dbo.PAGAMENTO (
 IdPagamento bigint NOT NULL PRIMARY KEY,
 IdParcela bigint NOT NULL,
 ReferenciaExterna varchar(40) NOT NULL UNIQUE,
 ValorPago decimal(18,2) NOT NULL,
 DataPagamento datetime2(0) NOT NULL,
 CONSTRAINT FK_PAGAMENTO_PARCELA FOREIGN KEY (IdParcela) REFERENCES dbo.PARCELA (IdParcela),
 CONSTRAINT CK_PAGAMENTO_Valor CHECK (ValorPago > 0)
 );
 INSERT dbo.CLIENTE (IdCliente,NomeCliente,DocumentoFicticio,DataCadastro) VALUES
 (1,N'Helena Serra','CLI-001','2026-09-01T12:00:00'),
 (2,N'Caio Vale','CLI-002','2026-09-02T12:00:00'),
 (3,N'Nina Ponte','CLI-003','2026-09-03T12:00:00');
 INSERT dbo.PROPOSTA (IdProposta,NumeroProposta,IdCliente,StatusProposta,
 ValorSolicitado,DataProposta,DataDecisao,DataAtualizacao,VersaoStatus) VALUES
 (101,'TP-2026-000184',1,'APROVADA',40000,'2026-10-01T12:00:00','2026-10-12T13:02:00','2026-10-12T13:02:00',2),
 (102,'TP-2026-000185',1,'EM_ANALISE',15000,'2026-10-02T12:00:00',NULL,'2026-10-02T12:00:00',1),
 (103,'TP-2026-000186',2,'APROVADA',30000,'2026-10-01T14:00:00','2026-10-02T13:00:00','2026-10-02T13:00:00',2),
 (104,'TP-2026-000187',3,'PENDENTE_DOCUMENTO',20000,'2026-10-02T14:00:00',NULL,'2026-10-02T14:00:00',1);
 INSERT dbo.ANALISE_CREDITO (IdAnalise,IdProposta,Resultado,DataAnalise) VALUES
 (201,101,'APROVADA','2026-10-12T13:02:00'),(202,103,'APROVADA','2026-10-02T13:00:00');
 INSERT dbo.HISTORICO_PROPOSTA (IdHistorico,IdProposta,StatusAnterior,StatusNovo,VersaoStatus,DataEvento) VALUES
 (301,101,'EM_ANALISE','APROVADA',2,'2026-10-12T13:02:00'),
 (302,103,'EM_ANALISE','APROVADA',2,'2026-10-02T13:00:00');
 INSERT dbo.CONTRATO (IdContrato,IdProposta,NumeroContrato,StatusContrato,ValorContratado,DataContrato) VALUES
 (501,101,'TC-2026-000501','ATIVO',40000,'2026-10-12T14:45:00'),
 (502,103,'TC-2026-000502','ATIVO',30000,'2026-10-02T13:05:00');
 INSERT dbo.PARCELA (IdParcela,IdContrato,NumeroParcela,DataVencimento,ValorParcela,StatusParcela) VALUES
 (1001,501,1,'20261015',1000,'PAGA'),(1002,501,2,'20261115',1000,'ABERTA'),(1003,502,1,'20261020',1500,'PARCIAL');
 INSERT dbo.PAGAMENTO (IdPagamento,IdParcela,ReferenciaExterna,ValorPago,DataPagamento) VALUES
 (7001,1001,'EXT-7001',1000,'2026-10-12T14:50:00'),(7002,1003,'EXT-7002',500,'2026-10-12T13:10:00');
 COMMIT TRANSACTION;
END TRY
BEGIN CATCH
 IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
 THROW;
END CATCH;
GO
