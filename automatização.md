## 1. Views (Visões)

Uma **View** é essencialmente uma "tabela virtual". Diferente de uma tabela comum, ela não armazena os dados fisicamente no disco rígido do servidor (com exceção de *Materialized Views* em alguns SGBDs específicos). Em vez disso, uma View armazena uma instrução `SELECT` predefinida. Toda vez que você consulta a View, o banco de dados executa essa query subjacente e retorna os dados em tempo real.

**Principais Vantagens:**
* **Simplificação de Consultas Complexas:** Evita que desenvolvedores tenham que reescrever `JOINs` longos, agrupamentos (`GROUP BY`) e filtros repetidamente. A lógica fica encapsulada.
* **Camada de Segurança:** Permite que você dê acesso a uma View para um usuário específico, mas não à tabela base. Isso é útil para ocultar colunas sensíveis (ex: mostrar apenas o nome do funcionário, ocultando seu salário).
* **Manutenção Centralizada:** Se a regra de negócio do relatório mudar, basta alterar a View no banco de dados, e todas as aplicações que a consomem receberão a atualização.

### Exemplo de Código: View
No exemplo abaixo, criamos uma View que consolida o histórico de compras dos clientes. Assim, a aplicação pode apenas fazer um `SELECT` simples na View em vez de lidar com múltiplos `JOINs`.

```sql
CREATE OR REPLACE VIEW vw_resumo_pedidos_clientes AS
SELECT 
    c.id AS cliente_id,
    c.nome AS cliente_nome,
    COUNT(p.id) AS total_pedidos_realizados,
    SUM(p.valor_total) AS total_gasto_acumulado
FROM 
    clientes c
LEFT JOIN 
    pedidos p ON c.id = p.cliente_id
GROUP BY 
    c.id, c.nome;

-- Utilizando a View na prática (como se fosse uma tabela)
SELECT * FROM vw_resumo_pedidos_clientes 
WHERE total_gasto_acumulado > 500.00;

```

---

## 2. Functions (Funções)

As **Functions** (ou Funções Definidas pelo Usuário - UDFs) são blocos de código SQL e/ou procedural armazenados no banco de dados que têm o propósito de calcular e **obrigatoriamente retornar um valor** ou um conjunto de resultados.

**Características Essenciais:**

* **Obrigatoriedade de Retorno:** Toda Function precisa da cláusula `RETURNS` indicando o tipo de dado devolvido, e finalizar seu escopo com o comando `RETURN`.
* **Versatilidade de Uso:** Por retornarem valores diretos, podem ser invocadas no meio de uma consulta comum (`SELECT`, `WHERE`, `ORDER BY`).
* **Restrições Comuns:** A maioria dos SGBDs bloqueia ou desencoraja fortemente o uso de Functions para alterar dados de forma definitiva (`INSERT`, `UPDATE`, `DELETE` em tabelas físicas principais) e não permite o gerenciamento de transações (`COMMIT` ou `ROLLBACK` internamente).

### Exemplo de Código: Function

Abaixo, criamos uma função para calcular o desconto de um produto com base em uma porcentagem, garantindo que a regra matemática fique padronizada no banco.

```sql
CREATE OR REPLACE FUNCTION fn_calcular_desconto(preco DECIMAL(10,2), desconto_percentual DECIMAL(5,2))
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    valor_com_desconto DECIMAL(10,2);
BEGIN
    -- Validação: Ignorar descontos negativos ou maiores que 100%
    IF desconto_percentual < 0 OR desconto_percentual > 100 THEN
        RETURN preco;
    END IF;

    -- Cálculo do valor final
    valor_com_desconto := preco - (preco * (desconto_percentual / 100));
    RETURN valor_com_desconto;
END;
$$;

-- Utilizando a Função dentro de um SELECT
SELECT 
    nome, 
    preco AS preco_original, 
    fn_calcular_desconto(preco, 15.00) AS preco_com_15_desconto 
FROM produtos;

```

---

## 3. Stored Procedures (Procedimentos Armazenados)

As **Stored Procedures** são rotinas completas programadas no banco de dados. Diferente das Functions, o foco principal de uma Procedure é **executar ações e regras de negócio**, e não necessariamente devolver um cálculo matemático.

**Por que usar Procedures em vez de Functions?**

* **Sem obrigação de retorno:** Não precisam ter a cláusula `RETURN`. Se houver necessidade de devolver algo, utilizam-se parâmetros do tipo `OUT`.
* **Manipulação de Dados Livres:** São o lugar ideal para agrupar operações pesadas de `INSERT`, `UPDATE` e `DELETE`.
* **Controle Transacional:** Podem iniciar transações, fazer verificações e aplicar `COMMIT` se tudo der certo, ou `ROLLBACK` em caso de erro, garantindo a integridade em operações que envolvem várias tabelas de uma só vez.
* **Modo de Chamada:** São invocadas via instrução específica (como `CALL` ou `EXECUTE`), e nunca dentro de uma cláusula `SELECT`.

### Exemplo de Código: Stored Procedure

Esta Procedure executa o fechamento de um pedido: ela atualiza o status do pedido para 'Concluído' e, em seguida, dá baixa no estoque dos produtos comprados. Tudo em uma única rotina.

```sql
CREATE OR REPLACE PROCEDURE pr_processar_fechamento_pedido(p_pedido_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- 1. Atualizar o status do pedido na tabela 'pedidos'
    UPDATE pedidos 
    SET status = 'Concluído', data_atualizacao = NOW() 
    WHERE id = p_pedido_id;

    -- 2. Atualizar o estoque na tabela 'produtos' (dando baixa nas quantidades vendidas)
    UPDATE produtos pr
    SET estoque = pr.estoque - ip.quantidade
    FROM itens_pedido ip
    WHERE ip.produto_id = pr.id AND ip.pedido_id = p_pedido_id;

    -- Uma procedure permite que você faça COMMIT aqui dentro se necessário
END;
$$;

-- Chamando a Procedure isoladamente
CALL pr_processar_fechamento_pedido(1024);

```

---

## 4. Triggers (Gatilhos)

### Explicação Detalhada

Um **Trigger** é um procedimento especial que é disparado de forma totalmente **automática** e invisível pelo SGBD quando ocorre um evento de modificação de dados (`INSERT`, `UPDATE` ou `DELETE`) em uma tabela ou view específica.

**Como e quando funcionam?**

* **Temporalidade:** Podem ser acionados `BEFORE` (antes) ou `AFTER` (depois) da modificação do dado.
* *BEFORE:* Ótimo para consistência, validar regras antes de salvar, formatar textos (ex: forçar e-mail para minúsculo).
* *AFTER:* Perfeito para logs de auditoria, disparar alertas ou atualizar tabelas de histórico que dependem da confirmação do dado.


* **Contexto de Linha:** Possuem variáveis embutidas para acessar o estado da linha. Em operações de alteração, você consegue ler os dados da variável `NEW` (valores que estão entrando) e da variável `OLD` (valores que já existiam antes do evento).

### Exemplo de Código: Trigger

Abaixo, criamos uma regra automática: toda vez que o preço de um produto for modificado (`UPDATE`), o banco deve salvar o preço antigo e o novo em uma tabela de auditoria sem que o usuário precise pedir isso manualmente.

```sql
CREATE OR REPLACE FUNCTION fn_log_alteracao_preco()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verifica se o preço na nova atualização (NEW) é diferente do antigo (OLD)
    IF OLD.preco <> NEW.preco THEN
        INSERT INTO log_auditoria (produto_id, preco_antigo, preco_novo, data_alteracao, usuario)
        VALUES (OLD.id, OLD.preco, NEW.preco, NOW(), CURRENT_USER);
    END IF;
    
    RETURN NEW; -- Necessário para Triggers continuarem a operação
END;
$$;

-- Associação do Trigger à tabela correspondente
CREATE TRIGGER tg_auditoria_preco_produto
AFTER UPDATE ON produtos
FOR EACH ROW
EXECUTE FUNCTION fn_log_alteracao_preco();

```
## Agora Vamos testar!
---
