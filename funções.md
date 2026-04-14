# Guia de SQL (Operações SET, Funções e GROUP BY)

* Operações SET
* Funções de linha única
* Funções de agregação
* GROUP BY

---

# 1. JOINS vs Operações SET

## Conceito

Enquanto os **JOINS** combinam tabelas horizontalmente (colunas), os **Operadores SET** combinam resultados verticalmente (linhas).

## Operadores SET

### UNION

Combina resultados de duas consultas removendo duplicatas.

```sql
SELECT nome FROM clientes
UNION
SELECT nome FROM fornecedores;
```

### UNION ALL

Mantém duplicatas.

```sql
SELECT nome FROM clientes
UNION ALL
SELECT nome FROM fornecedores;
```

### INTERSECT

Retorna apenas valores comuns entre consultas.

```sql
SELECT nome FROM clientes
INTERSECT
SELECT nome FROM fornecedores;
```

### EXCEPT

Retorna valores da primeira consulta que não existem na segunda.

```sql
SELECT nome FROM clientes
EXCEPT
SELECT nome FROM fornecedores;
```

---

# 2. Funções de Linha Única

## Conceito

Executadas **linha por linha**, retornando um valor para cada registro.

## Tipos principais

### Funções de Texto

```sql
SELECT UPPER(nome) AS nome_maiusculo,
       LOWER(nome) AS nome_minusculo,
       LEN(nome) AS tamanho_nome
FROM clientes;
```

### CONCAT

```sql
SELECT CONCAT(nome, ' - ', cidade) AS descricao
FROM clientes;
```

### Funções de Data

```sql
SELECT DATEDIFF(day, data_inicio, data_fim) AS dias
FROM projetos;
```

```sql
SELECT DATEADD(day, 7, data_pedido) AS nova_data
FROM pedidos;
```

### Tratamento de Nulos

```sql
SELECT COALESCE(telefone, 'Não informado') AS telefone
FROM clientes;
```

### CASE (Lógica Condicional)

```sql
SELECT nome,
       CASE
           WHEN idade < 18 THEN 'Menor'
           WHEN idade BETWEEN 18 AND 60 THEN 'Adulto'
           ELSE 'Idoso'
       END AS classificacao
FROM clientes;
```

---

# 3. Funções de Agregação e GROUP BY

## Conceito

As funções de agregação resumem dados em um único valor.

## Funções principais

### COUNT

```sql
SELECT COUNT(*) AS total_clientes
FROM clientes;
```

### SUM e AVG

```sql
SELECT SUM(valor) AS total_vendas,
       AVG(valor) AS media_vendas
FROM vendas;
```

### MAX e MIN

```sql
SELECT MAX(valor) AS maior_venda,
       MIN(valor) AS menor_venda
FROM vendas;
```

---

## GROUP BY

Agrupa registros para aplicar funções de agregação por categoria.

```sql
SELECT cidade, COUNT(*) AS total_clientes
FROM clientes
GROUP BY cidade;
```

### Exemplo com soma

```sql
SELECT regiao, SUM(valor) AS faturamento_total
FROM vendas
GROUP BY regiao;
```

---

## Regras importantes!

* Toda coluna no SELECT deve estar no GROUP BY ou em uma função de agregação
* WHERE filtra antes do agrupamento
* HAVING filtra depois do agrupamento

### Exemplo com HAVING

```sql
SELECT cidade, COUNT(*) AS total
FROM clientes
GROUP BY cidade
HAVING COUNT(*) > 5;
```

---

💡 **Pratique criando consultas reais para fixar melhor o conteúdo!**
