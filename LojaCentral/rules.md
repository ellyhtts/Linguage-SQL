# Sistema de Vendas com Procedure (PostgreSQL)

Um projeto prático de banco de dados para gerenciar o estoque e registrar vendas de produtos, aplicando regras de negócio diretamente no banco utilizando PL/pgSQL.

## Sobre o Projeto

Este repositório contém a modelagem e a implementação de um sistema simplificado de vendas. O foco principal é a utilização de **Procedures** para garantir a integridade dos dados no momento da transação.

### Tecnologias Utilizadas
* **PostgreSQL** (SGBD)
* **DBeaver** (Cliente SQL)
* **PL/pgSQL** (Linguagem procedural)

## Estrutura do Banco de Dados

* **Tabela `produtos`**: Armazena o ID, nome, preço e a quantidade em estoque.
* **Tabela `vendas`**: Registra cada transação, vinculando ao produto (FK), quantidade, valor total e a data/hora exata da operação.

## Funcionalidades (Procedures)

O script principal contém duas procedures:

1.  `realizar_venda(produto_id, quantidade)`: Valida se o produto existe, verifica se há estoque disponível, calcula o valor total, registra a venda e debita o estoque automaticamente.
2.  `crud_produtos(acao, id, nome, preco, estoque)`: Uma procedure "dispatcher" para gerenciar o cadastro, listagem, atualização e exclusão de produtos (CRUD).

## Como Executar

1.  Clone este repositório usando o GitHub Desktop.
2.  Abra o arquivo `sistema_vendas.sql` no DBeaver (conectado a um banco PostgreSQL).
3.  Execute o script inteiro para criar as tabelas e popular os dados iniciais.
4.  Utilize o comando `CALL` no final do script para testar as transações.