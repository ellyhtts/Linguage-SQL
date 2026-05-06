CREATE OR REPLACE FUNCTION check_user_status(p_id INT) 
RETURNS TEXT 
LANGUAGE plpgsql
AS $$
DECLARE
    v_active BOOLEAN;
BEGIN

    SELECT active INTO v_active 
    FROM users 
    WHERE id = p_id;

    IF NOT FOUND THEN
        RETURN 'Usuário não encontrado';
    ELSIF v_active = true THEN
        RETURN 'Usuário ativo';
    ELSE
        RETURN 'Usuário inativo';
    END IF;
END;
$$;

SELECT check_user_status(1); 
SELECT check_user_status(2);
SELECT check_user_status(99); 