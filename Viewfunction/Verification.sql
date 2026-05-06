CREATE OR REPLACE PROCEDURE add_user(
    p_name VARCHAR(100),
    p_email VARCHAR(100),
    p_active BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN

    IF p_email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN 
        INSERT INTO users (name, email, active) VALUES (p_name, p_email, p_active);
        RAISE NOTICE 'Usuário % cadastrado com sucesso!', p_name;
    ELSE
        RAISE EXCEPTION 'Erro: O formato do e-mail % é inválido!', p_email;
    END IF;
END;
$$;

CREATE OR REPLACE VIEW active_users_view AS
SELECT 
    id, 
    name, 
    email
FROM 
    users
WHERE 
    active = true;

SELECT * FROM active_users_view;