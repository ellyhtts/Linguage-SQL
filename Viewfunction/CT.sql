CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    active BOOLEAN
);

INSERT INTO users (name, email, active) VALUES 
('Alice Silva', 'alice@email.com', true),
('Bruno Souza', 'bruno@email.com', false),
('Carlos Maia', 'carlos@email.com', true);