# Guia Avançado: Modelagem e Consultas SQL

## 1. Relacionamentos: O Poder das Chaves Estrangeiras

[cite_start] A chave estrangeira (Foreign Key) é um campo de uma tabela que aponta para a chave primária de outra tabela [cite: 34, 35, 36].
[cite_start] Ela serve para criar relacionamento entre tabelas, sendo o elemento que “liga” uma tabela à outra em um banco de dados relacional [cite: 37, 38, 39].

**Por que precisamos dela?**

Sem chave estrangeira:
* [cite_start] As tabelas ficam isoladas[cite: 41, 42].
* [cite_start] Não há garantia de que os dados combinam[cite: 43].
* [cite_start] Podem existir registros “órfãos” (sem relação real)[cite: 44].

Com chave estrangeira:
* [cite_start] O banco garante integridade dos dados [cite: 45, 46].
* [cite_start] Evita erros e inconsistências[cite: 47].
* [cite_start] Representa relações do mundo real (cliente → pedido, aluno → matrícula, etc.)[cite: 48].

**Exemplo Prático (Visão de Tabelas):**

[cite_start] **Tabela de Clientes** [cite: 49]
| Id (PK) | Nome |
|:---:|:---|
| 1 | [cite_start]Ana Silva [cite: 52, 53] |
| 2 | [cite_start]João Souza [cite: 54, 55] |

[cite_start] **Tabela de Pedidos** [cite: 56]
| Id (PK) | clienteId (FK) | Total |
|:---:|:---:|:---:|
| 1001 | 1 | [cite_start]3500 [cite: 60, 61, 62] |
| 1002 | 2 | [cite_start]200 [cite: 63, 64, 65] |
| 1003 | 1 | [cite_start]1200 [cite: 66, 67, 68] |

**Exemplo em Código (DDL):**
```sql
CREATE TABLE Pedidos (
    id INT PRIMARY KEY,
    clienteId INT,
    Total DECIMAL(10,2),
    -- Criando a amarra entre as duas tabelas
    CONSTRAINT fk_cliente_pedido FOREIGN KEY (clienteId) REFERENCES Clientes(id)
);
```

## 2. Normalização: A Arte da Organização

Normalizar um banco de dados é organizar as informações para que cada dado exista apenas uma vez, evitando repetição, erros e bagunça nas tabelas. O processo é dividido em etapas conhecidas como Formas Normais:

### Forma Não Normalizada (UNF)
Todos os dados estão misturados em uma única tabela, com grupos repetidos. Dados do cliente repetidos tornam difícil consultar e manter.

| OrderID | CustomerName | CustomerPhone | Products | Total |
| :---: | :--- | :--- | :--- | :---: |
| 1001 | Ana Silva | 9999-1111 | Notebook, Mouse | 3500 |

### Primeira Forma Normal (1FN)

* **Regra:** Os campos devem ser atômicos (um único valor por célula).
* **Problema restante:** Os dados do cliente continuam duplicados e o total pertence apenas ao pedido, mantendo responsabilidades misturadas na mesma tabela.

| OrderID | CustomerName | CustomerPhone | Product | Total |
| :---: | :--- | :--- | :--- | :---: |
| 1001 | Ana Silva | 9999-1111 | Notebook | 3500 |
| 1001 | Ana Silva | 9999-1111 | Mouse | 3500 |

### Segunda Forma Normal (2FN)

* **Regras:** Deve estar na 1FN e removermos dependências parciais. Cada entidade passa a ter sua própria tabela e ter sua própria chave primária.

**Tabela Customers** | CustomerID | Nome | Telefone |
|:---:|:---|:---|
| 1 | Ana Silva | 9999-1111  |

**Tabela Orders** | OrderID | CustomerID | Total |
|:---:|:---:|:---:|
| 1001 | 1 | 3500  |

**Tabela Order_Products (Itens)** | OrderID | Produto |
|:---:|:---|
| 1001 | Notebook  |
| 1001 | Mouse  |

* **Problema restante:** "Produto" é um texto livre, está "solto" no banco.

### Terceira Forma Normal (3FN)

* **Regras:** Deve estar na 2FN. Remover dependências transitivas. Campos não-chave DEVEM depender apenas da chave. Criamos uma tabela exclusiva para Produtos e a referenciamos por ID.

**Tabela Products** | ProductID | NomeProduto |
|:---:|:---|
| 10 | Notebook  |
| 11 | Mouse  |

**O Resultado Final:** O banco de dados agora possui ausência de redundância, relacionamentos claros (Chaves Estrangeiras) e estrutura relacional correta. Mais eficiente, confiável, fácil de escalar e de entender.

---

## 3. JOINS: Adição de Colunas (Combinação Horizontal)

Conectamos tabelas lateralmente através de uma coluna comum (Chave). Ao escrevermos um JOIN, devemos especificar a relação.

* **Inner Join:** Apenas o que existe em ambas as tabelas.
* **Left Join:** Mantemos tudo da tabela à esquerda e trazemos o que houver da direita.
* **Right Join:** Mantemos tudo da direita e trazemos o que houver da esquerda.
* **Full Join:** Trazemos tudo de ambos os lados, independentemente de haver correspondência.

**Exemplos Práticos em Código:**

```sql
-- 1. INNER JOIN: Mostra apenas clientes que fizeram pedidos
SELECT c.Nome, p.Total 
FROM Clientes c
INNER JOIN Pedidos p ON c.Id = p.clienteId;

-- 2. LEFT JOIN: Mostra TODOS os clientes, mesmo os que NÃO fizeram pedidos (o Total virá como NULL)
SELECT c.Nome, p.Total 
FROM Clientes c
LEFT JOIN Pedidos p ON c.Id = p.clienteId;

``
