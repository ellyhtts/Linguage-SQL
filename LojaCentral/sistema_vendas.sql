DROP TABLE IF EXISTS vendas;

create table produtos (
id SERIAL primary key,
nome varchar(100) not null,
preco numeric(10,2),
estoque int not null
);

create table vendas (
id serial primary key,
produto_id int references produtos(id),
cliente_id int references clintes(id),
quantidade int not null,
valor_total numeric(10,2) not null,
data_venda timestamp default current_timestamp
);

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20)
);

insert into produtos (nome, preco, estoque) values 
('produto A', 10.00, 100),
('produto B', 20.00, 50),
('produto C', 5.00, 200);

INSERT INTO clientes (nome, email, telefone) VALUES 
('Ana Souza', 'ana@email.com', '11999998888'),
('Carlos Lima', 'carlos@email.com', '11977776666');
select * from produtos;

INSERT INTO vendas (cliente_id, produto_id, quantidade, valor_total) 
VALUES (1, 1, 2, 20.00)