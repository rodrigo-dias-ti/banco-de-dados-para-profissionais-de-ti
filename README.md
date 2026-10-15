# Banco de Dados para Profissionais de TI

Materiais de exercícios do livro de **Rodrigo de Araujo Dias** para estudantes e profissionais de TI em formação. O cenário TerêBanco e seus registros são fictícios. Pré-requisitos: informática básica e lógica de programação.

## Primeira distribuição dos laboratórios

Este pacote contém o laboratório relacional em **SQL Server 2022**, cinco exercícios progressivos, respostas comentadas e uma carga opcional de 50 mil propostas. O livro apresenta PostgreSQL 18 e Oracle 19c em capítulos específicos; estes scripts T-SQL exigem adaptações para esses produtos.

Prepare uma instância de estudo e uma base vazia chamada TERE_CREDITO_LAB. Use SSMS ou uma ferramenta que reconheça GO. A criação da base está comentada no arquivo de preparação; execute-a somente com autorização no ambiente de estudo. O script recusa tabelas existentes e não oferece limpeza automática.

Execute nesta ordem:

1. [Preparação e dados](01_preparar_laboratorio.sql).
2. [Conferência da carga](02_conferir_carga.sql).
3. [Exercícios de consultas e integridade](01_consultas_e_integridade.md). Tente resolver antes de abrir as [respostas comentadas](03_respostas_comentadas.sql).
4. Opcionalmente, [laboratório de escala](04_escala_opcional.sql), em tabela separada do conjunto canônico.

## Estado da validação

Os comandos foram conferidos contra os materiais locais e os resultados previstos foram revisados logicamente. **A execução nativa em SQL Server ainda está pendente nesta distribuição.** Não confunda essa conferência com teste executado. Consulte [VALIDACAO.md](VALIDACAO.md). Execute somente em laboratório.

## Autor

[LinkedIn](https://www.linkedin.com/in/rodrigo-dias-ti/) · [GitHub](https://github.com/rodrigo-dias-ti)

O livro comercial, suas revisões e seus documentos editoriais são mantidos separadamente deste repositório.
