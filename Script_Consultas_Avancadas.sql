drop table if exists pedidos;
drop table if exists produtos;
drop table if exists leads_potenciais;
drop table if exists clientes;

CREATE TABLE public.clientes (
	id int NOT NULL,
	nome varchar(50) NOT NULL,
	cidade varchar(50) NULL,
	CONSTRAINT clientes_pkey PRIMARY KEY (id)
);

CREATE TABLE public.produtos (
	id int NOT NULL,
	nomeproduto varchar(100) NOT NULL,
	precopadrao numeric(10, 2) NULL,
	CONSTRAINT produtos_pkey PRIMARY KEY (id)
);

CREATE TABLE public.leads_potenciais (
	id int NOT NULL,
	nome varchar(50) NULL,
	email varchar(50) NULL,
	CONSTRAINT leads_potenciais_pkey PRIMARY KEY (id)
);

CREATE TABLE public.pedidos (
	id int NOT NULL,
	clienteid int NULL,
	produtoid int NULL,
	quantidade int NULL,
	precovenda numeric(10, 2) NULL,
	CONSTRAINT pedidos_pkey PRIMARY KEY (id),
	CONSTRAINT fk_cliente_pedido FOREIGN KEY (clienteid) REFERENCES public.clientes(id),
	CONSTRAINT fk_produto_pedido FOREIGN KEY (produtoid) REFERENCES public.produtos(id)
);

INSERT INTO Produtos (Id, NomeProduto, PrecoPadrao) VALUES
(10, 'Notebook Pro', 4500.00),
(11, 'Rato Sem Fio', 120.00),
(12, 'Monitor 24"', 950.00),
(13, 'Teclado Mecânico', 350.00);

INSERT INTO Clientes (Id, Nome, Cidade) VALUES
(1, 'Maria Silva', 'São Paulo'),
(2, 'João Pereira', 'Rio de Janeiro'),
(3, 'Ana Costa', 'Curitiba'),
(4, 'Ricardo Santos', 'Belo Horizonte');

INSERT INTO Pedidos (Id, ClienteID, ProdutoID, Quantidade, PrecoVenda) VALUES
(101, 1, 10, 1, 4500.00), 
(102, 1, 11, 2, 110.00),  
(103, 2, 12, 1, 950.00),  
(104, 4, 13, 1, 350.00);  

INSERT INTO Leads_Potenciais (Id, Nome, Email) VALUES
(1, 'Maria Silva', 'maria@email.com'),     
(2, 'João Pereira', 'joao@email.com'),     
(3, 'Roberto Alves', 'roberto@test.com');  

SELECT 
    c.nome AS Nome_Cliente,
    p.nomeproduto AS Produto,
    ped.precovenda AS Valor_Pago
FROM pedidos ped
INNER JOIN clientes c ON ped.clienteid = c.id
INNER JOIN produtos p ON ped.produtoid = p.id;

SELECT Nome, 'Cliente' AS Categoria 
FROM clientes
UNION
SELECT Nome, 'Lead' AS Categoria 
FROM leads_potenciais;

SELECT Nome FROM clientes
INTERSECT
SELECT Nome FROM leads_potenciais;
