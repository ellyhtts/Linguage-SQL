CREATE TABLE clientes (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    cidade VARCHAR(100),
    idade INT,
    telefone VARCHAR(20)
);

CREATE TABLE fornecedores (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    cidade VARCHAR(100)
);

CREATE TABLE vendas (
    id INT PRIMARY KEY,
    cliente_id INT,
    regiao VARCHAR(50),
    valor DECIMAL(10,2),
    data_venda DATE
);

INSERT INTO clientes VALUES
(1, 'Ana', 'Salvador', 25, NULL),
(2, 'Bruno', 'Feira de Santana', 17, '9999-1111'),
(3, 'Carlos', 'Salvador', 65, NULL),
(4, 'Daniela', 'Feira de Santana', 40, '9888-2222');

INSERT INTO fornecedores VALUES
(1, 'Ana', 'Salvador'),
(2, 'Empresa X', 'São Paulo'),
(3, 'Carlos', 'Salvador');

INSERT INTO vendas VALUES
(1, 1, 'Nordeste', 150.00, '2025-01-10'),
(2, 2, 'Nordeste', 200.00, '2025-01-12'),
(3, 1, 'Nordeste', 300.00, '2025-02-01'),
(4, 3, 'Sudeste', 500.00, '2025-02-10');

SELECT nome FROM clientes
UNION
SELECT nome FROM fornecedores;

SELECT nome FROM clientes
UNION ALL
SELECT nome FROM fornecedores;

SELECT nome FROM clientes
INTERSECT
SELECT nome FROM fornecedores;

SELECT nome FROM clientes
EXCEPT
SELECT nome FROM fornecedores;

SELECT 
    nome,
    UPPER(nome) AS nome_maiusculo,
    LOWER(nome) AS nome_minusculo,
    LEN(nome) AS tamanho_nome
FROM clientes;

SELECT 
    CONCAT(nome, ' - ', cidade) AS descricao
FROM clientes;

SELECT 
    nome,
    COALESCE(telefone, 'Não informado') AS telefone
FROM clientes;

SELECT 
    nome,
    idade,
    CASE
        WHEN idade < 18 THEN 'Menor'
        WHEN idade BETWEEN 18 AND 60 THEN 'Adulto'
        ELSE 'Idoso'
    END AS classificacao
FROM clientes;

SELECT COUNT(*) AS total_vendas FROM vendas;

SELECT 
    SUM(valor) AS total,
    AVG(valor) AS media
FROM vendas;

SELECT 
    MAX(valor) AS maior_venda,
    MIN(valor) AS menor_venda
FROM vendas;

SELECT 
    regiao,
    SUM(valor) AS faturamento_total
FROM vendas
GROUP BY regiao;

SELECT 
    cidade,
    COUNT(*) AS total_clientes
FROM clientes
GROUP BY cidade;

SELECT 
    regiao,
    COUNT(*) AS quantidade
FROM vendas
GROUP BY regiao
HAVING COUNT(*) > 1;

SELECT 
    c.cidade,
    COUNT(v.id) AS total_vendas,
    SUM(v.valor) AS faturamento,
    AVG(v.valor) AS media_venda,
    MAX(v.valor) AS maior_venda,
    MIN(v.valor) AS menor_venda
FROM clientes c
JOIN vendas v ON c.id = v.cliente_id
GROUP BY c.cidade
HAVING SUM(v.valor) > 200;
