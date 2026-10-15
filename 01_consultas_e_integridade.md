# Consultas e integridade no TerêBanco

Materiais de Rodrigo de Araujo Dias. Cenário e dados fictícios. Use apenas TERE_CREDITO_LAB em SQL Server 2022. Revisão lógica realizada; execução nativa ainda pendente nesta distribuição.

## Como estudar

Antes de consultar, escreva qual é a unidade de cada linha esperada: cliente, proposta, contrato, parcela ou pagamento. Compare o resultado com sua previsão e explique divergências. Datas técnicas são UTC; vencimentos são datas civis.

## Exercício 1 O universo das propostas

Marina, da área de Crédito, precisa da quantidade de propostas e do total solicitado. Devolva os dois indicadores em uma linha. Esperado: quatro propostas e R$ 105.000. Explique por que contar propostas não equivale a contar clientes.

## Exercício 2 Um cliente pode ter várias propostas

Lara, analista N1, recebe o chamado fictício INC-LAB-001. Marina esperava duas propostas da cliente Helena Serra, mas o relatório apresenta uma. Relacione cliente e proposta, filtrando IdCliente = 1. Devem aparecer 101 e 102. Verifique os estados: o filtro APROVADA exclui a proposta em análise. Registre hipótese, evidência e conclusão; encaminhe ao N2 se restar divergência não explicada pelo filtro.

## Exercício 3 O total que um JOIN multiplica

Some os valores dos contratos sem relacioná-los às parcelas: esperado R$ 70.000. Faça JOIN com parcelas e repita a soma: aparecem R$ 110.000 porque o contrato 501 participa de duas linhas. Explique a granularidade e agregue parcelas antes do JOIN. SUM(DISTINCT ValorContratado) não é solução geral: contratos diferentes podem ter o mesmo valor.

## Exercício 4 Saldo por parcela

Relacione parcelas e pagamentos preservando parcelas sem recebimentos. Agregue pagamentos por parcela antes do JOIN. Saldos esperados de 1001, 1002 e 1003: zero, R$ 1.000 e R$ 1.000. Explique COALESCE quando não há pagamento. O conjunto não representa um cronograma completo de amortização.

## Exercício 5 Uma mudança que será revertida

Copie a parcela 1002 para uma tabela temporária. Em uma transação, altere o valor da cópia, consulte, execute ROLLBACK e consulte novamente. Preserve a tabela original. Explique por que consultar dentro da transação não comprova persistência após a reversão.

## Autor

[LinkedIn](https://www.linkedin.com/in/rodrigo-dias-ti/) · [GitHub](https://github.com/rodrigo-dias-ti)
