create table produtos (
id SERIAL primary key,
nome varchar(100) not null,
preco numeric(10,2),
estoque int not null
);

create table vendas (
id serial primary key,
produto_id int references produtos(id),
quantidade int not null,
valor_total numeric(10,2) not null,
data_venda timestamp default current_timestamp
);

insert into produtos (nome, preco, estoque) values 
('produto A', 10.00, 100),
('produto B', 20.00, 50),
('produto C', 5.00, 200);

select * from produtos;
