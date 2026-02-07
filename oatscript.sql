create database supermercado;

create table cliente ( 
id int not null,
nome varchar(50) not null,
cpf varchar(11) not null,
constraint pk_id_cliente primary key (id)
);

create table  produto(
id int not null,
descricao varchar(100) not null,
cod_barras varchar(14),
valor decimal(16,2)
);

alter table produto add constraint pk_id_produto primary key (id);

alter table produto add column situacao boolean not null;

alter table produto alter column descricao type varchar(200);


drop table produto;