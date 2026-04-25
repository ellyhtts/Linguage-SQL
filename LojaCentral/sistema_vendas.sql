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


