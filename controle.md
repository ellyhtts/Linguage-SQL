## TCL (Transaction Control Language)

O **TCL** (Linguagem de Controle de Transações) gerencia o agrupamento lógico de comandos. O objetivo principal é garantir o conceito "Tudo ou Nada" (Atomicidade). Imagine uma transferência bancária: tirar dinheiro de uma conta e colocar em outra. Se o sistema falhar na metade, o banco não pode ficar com o dinheiro no "limbo". Ou ambas as ações funcionam, ou ambas são canceladas.

**Comandos Fundamentais:**

* **START TRANSACTION / BEGIN:** Avisa ao banco que um pacote de comandos está começando.
* **COMMIT:** Dá o "salvamento final". Grava no disco permanentemente todas as alterações desde o último `BEGIN`.
* **ROLLBACK:** O "botão de pânico". Cancela todas as alterações em memória desde o último `BEGIN`, voltando o banco ao estado original.
* **SAVEPOINT:** Cria um "marcador" na transação para permitir `ROLLBACKs` parciais.

### Exemplo de Código: TCL

Este exemplo mostra um bloco seguro de inserção onde controlamos a transação manualmente.

```sql
BEGIN; -- Inicia o controle transacional

-- Passo 1: Inserir o cabeçalho do pedido
INSERT INTO pedidos (id, cliente_id, data_pedido, valor_total, status)
VALUES (5001, 12, NOW(), 250.00, 'Pendente');

-- Criar um ponto de restauração
SAVEPOINT pedido_criado;

-- Passo 2: Tentar inserir os itens do pedido
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario)
VALUES (5001, 4, 2, 125.00);

-- Cenário A: Ocorreu um erro no estoque ao inserir itens
-- ROLLBACK TO SAVEPOINT pedido_criado; -- Desfaz a inserção dos itens, mas mantém o cabeçalho

-- Cenário B: Deu tudo errado, falha total
-- ROLLBACK; -- Cancela o pedido e os itens, não salva nada

-- Cenário C (Caminho feliz): Tudo ocorreu como esperado
COMMIT; -- Efetiva permanentemente o pedido e os itens no banco

```

---

## DCL (Data Control Language)


O **DCL** (Linguagem de Controle de Dados) trata exclusivamente de **Segurança e Acesso**. Ele define quem pode entrar no banco e o que cada usuário tem permissão de fazer, operando através de um sistema de concessão e revogação de privilégios em cima dos objetos (tabelas, views, procedures).

**Comandos Fundamentais:**

* **GRANT:** Dá permissões. Você especifica qual o privilégio (ex: ler, escrever, deletar, executar) e em qual objeto.
* **REVOKE:** Retira permissões previamente concedidas, devolvendo a restrição de segurança ao usuário.

### Exemplo de Código: DCL

Aqui criamos regras de acesso distintas para um analista de suporte (que só precisa ler dados) e um administrador (que tem acesso total).

```sql
-- 1. Criação dos usuários no banco de dados
CREATE USER analista_suporte WITH PASSWORD 'SenhaSegura123';
CREATE USER admin_dados WITH PASSWORD 'AdminMaster456';

-- 2. Concedendo privilégios (GRANT)
-- O analista pode ler clientes, pedidos e executar a função de desconto
GRANT SELECT ON TABLE clientes TO analista_suporte;
GRANT SELECT ON TABLE pedidos TO analista_suporte;
GRANT EXECUTE ON FUNCTION fn_calcular_desconto TO analista_suporte;

-- O administrador recebe controle total sobre todas as tabelas no schema público
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_dados;

-- 3. Revogando privilégios (REVOKE)
-- Digamos que o analista de suporte mudou de setor e não pode mais ver clientes
REVOKE SELECT ON TABLE clientes FROM analista_suporte;

```

## Agora vamos testar esses conhecimentos!
