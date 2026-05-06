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