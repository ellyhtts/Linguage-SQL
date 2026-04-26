-- Modelagem do Banco
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

-- Inserção de Dados
insert into produtos (nome, preco, estoque) values 
('produto A', 10.00, 100),
('produto B', 20.00, 50),
('produto C', 5.00, 200);

select * from produtos;

-- Procedure de Venda
CREATE OR REPLACE PROCEDURE public.realizar_venda(IN p_produto_id integer, IN p_quantidade integer)
LANGUAGE plpgsql
AS $procedure$
DECLARE
	v_preco numeric(10, 2);
	v_estoque_atual int;
	v_valor_total numeric(10,2);
BEGIN
 	SELECT preco, estoque INTO v_preco, v_estoque_atual
	FROM produtos
	WHERE id = p_produto_id;

    IF NOT FOUND THEN
	    RAISE EXCEPTION 'erro: produto com id % não exixte.', p_produto_id;
    END IF;

    IF v_estoque_atual < p_quantidade THEN
        RAISE EXCEPTION 'Erro: Estoque insuficiente! Estoque atual: %', v_estoque_atual;
    END IF;

    v_valor_total := v_preco * p_quantidade;

    INSERT INTO vendas (produto_id, quantidade, valor_total)
    VALUES (p_produto_id, p_quantidade, v_valor_total);

    UPDATE produtos
    SET estoque = estoque - p_quantidade
    WHERE id = p_produto_id;

    RAISE NOTICE 'Venda realizada com sucesso! Valor Total: R$ %', v_valor_total;
END;
$procedure$;

-- CRUD (CREATE, READ,UPTADE, DELETE)

CREATE OR REPLACE PROCEDURE crud_produtos(
    p_acao VARCHAR, 
    p_id INT, 
    p_nome VARCHAR, 
    p_preco NUMERIC, 
    p_estoque INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_produto RECORD; 
BEGIN
    IF (p_acao = 'C') THEN
        INSERT INTO produtos (nome, preco, estoque) VALUES (p_nome, p_preco, p_estoque);
        RAISE NOTICE 'Produto cadastrado com sucesso!';
        
    ELSEIF (p_acao = 'L' AND p_id IS NULL) THEN
        RAISE NOTICE 'LISTA DE TODOS OS PRODUTOS';
        FOR v_produto IN SELECT * FROM produtos ORDER BY id LOOP
            RAISE NOTICE 'ID: % | Nome: % | Preço: R$ % | Estoque: %', v_produto.id, v_produto.nome, v_produto.preco, v_produto.estoque;
        END LOOP; 
    ELSEIF (p_acao = 'L' AND p_id IS NOT NULL) THEN
        SELECT * INTO v_produto FROM produtos WHERE id = p_id;
        IF FOUND THEN
            RAISE NOTICE 'PRODUTO ENCONTRADO';
            RAISE NOTICE 'ID: % | Nome: % | Preço: R$ % | Estoque: %', v_produto.id, v_produto.nome, v_produto.preco, v_produto.estoque;
        ELSE
            RAISE NOTICE 'Aviso: Produto com ID % não encontrado.', p_id;
        END IF;
    ELSEIF (p_acao = 'A') THEN
        UPDATE produtos SET nome = p_nome, preco = p_preco, estoque = p_estoque WHERE id = p_id;
        RAISE NOTICE 'Produto alterado com sucesso!';
    ELSEIF (p_acao = 'E') THEN
        DELETE FROM vendas WHERE produto_id = p_id; 
        DELETE FROM produtos WHERE id = p_id;
        RAISE NOTICE 'Produto (e suas vendas atreladas) excluídos com sucesso!';    
    END IF;
END;
$$;

-- Chamadas de teste das procedures

CALL realizar_venda(1, 2); 
SELECT * FROM produtos;
SELECT * FROM vendas;
CALL realizar_venda(2, 60);
CALL realizar_venda(99, 1);

CALL crud_produtos('C', NULL, 'Teclado Mecânico', 150.00, 20);
CALL crud_produtos('L', NULL, NULL, NULL, NULL);
CALL crud_produtos('A', 1, 'Produto A Modificado', 12.50, 100);
CALL crud_produtos('E', 3, NULL, NULL, NULL);
