# Guia de Fundamentos de linguagem SQL

## 1. Introdução

No ecossistema tecnológico atual, a capacidade de "falar com os dados" é o que separa observadores de especialistas. Para isso, utilizamos o SQL, uma linguagem que permite extrair desde métricas simples até cálculos complexos de "Gasto Total" em volumes massivos de informação. Ela é o padrão absoluto utilizado por gigantes como Power BI, Tableau, Kafka, Spark e Synapse.

SQL (Structured Query Language): Frequentemente pronunciada como "SeQuel", é a linguagem padrão da indústria projetada para interagir, gerenciar e recuperar dados estruturados em sistemas de banco de dados.

Dominar o SQL abre as portas para as quatro carreiras mais estratégicas da atualidade:

**💻 Desenvolvedores de Software:** Para criar aplicações que persistem e recuperam informações de forma eficiente.

**📊 Analistas de Dados:** Para transformar dados brutos em insights e relatórios para a tomada de decisão.

**🧪 Cientistas de Dados:** Para limpar, preparar e modelar grandes conjuntos de dados estatísticos.

**⚙️ Engenheiros de Dados:** Para projetar e construir as infraestruturas e pipelines que sustentam o fluxo de dados.

--------------------------------------------------------------------------------

## 2. O Sistema de Gerenciamento de Banco de Dados (DBMS)

O DBMS (Database Management System) atua como a interface inteligente entre o usuário e o armazenamento físico. Ele não apenas organiza os arquivos, mas gerencia a concorrência, permitindo que centenas de usuários e aplicativos acessem os dados simultaneamente sem corrompê-los.

Características essenciais de um DBMS:

**Intermediação:** Ele traduz as solicitações de aplicativos (APP </>), ferramentas de BI ou usuários em ações diretas no banco.
**Hospedagem:** Localizado em servidores robustos ou na nuvem, garantindo poder de processamento.
**Disponibilidade 24/7:** Projetado para operação ininterrupta, garantindo que o dado esteja lá quando você precisar.

|Fluxo de Interação | Usuário/App/BI ➔| Consulta SQL ➔| DBMS (O Cérebro) ➔| Banco de Dados (O Disco) ➔|
|:---:|:---:|:---:|:---:|:---:|
--------------------------------------------------------------------------------

## 3. A Hierarquia Organizacional: Do Servidor à Tabela

Imagine o banco de dados como uma infraestrutura de caixas organizadas de forma lógica:

**1. Servidor:** O host principal (físico ou cloud) que abriga todo o ecossistema.

**2. Banco de Dados:** Um contêiner de alto nível para projetos específicos (ex: Banco "Vendas").

**3. Esquema (Schema):** Um agrupamento lógico dentro do banco, funcionando como pastas para organizar temas (ex: Esquema "Clientes").

**4. Tabela:** O destino final, onde os dados são gravados fisicamente no disco.

--------------------------------------------------------------------------------

## 4. Anatomia de uma Tabela: Os Blocos de Construção

A tabela é o local onde o armazenamento físico realmente acontece. Compreender sua anatomia é vital para qualquer profissional de dados:

- **Colunas:** São as categorias verticais que definem o tipo de informação que a tabela pode conter (ex: Nome, Preço).

- **Linhas:** São os registros ou instâncias individuais inseridas (ex: a venda de um Laptop específico).

- **Célula:** A unidade mínima de dado, localizada no cruzamento exato entre uma linha e uma coluna.

- **Chave Primária:** É o identificador único indispensável para cada registro. Sem ela, a integridade do dado é comprometida, pois não haveria forma garantida de distinguir dois registros semelhantes.

--------------------------------------------------------------------------------

## 5. Tipos de Dados: Definindo a Natureza da Informação

Definir o tipo de dado correto é uma questão de performance e integridade.

|Tipo |	Sigla SQL | Exemplo |
|:--------:|:--------:|:--------:|
| Numérico | INT |	Números inteiros (ex: quantidade em estoque).|
| Numérico | DECIMAL |	Números com frações (ex: preços, coordenadas).|
| Texto | String	CHAR |	Texto de comprimento fixo (ex: siglas de estados).|
| Texto | String	VARCHAR	|Texto de comprimento variável (ex: nomes, e-mails).|
| Data & Hora	| DATE |	Formato ‘YYYY-MM-DD’.|
| Data & Hora	| TIME | Formato ‘HH:MM:SS’.|

**Pro-Tip de Engenharia: Nunca utilize INT para valores monetários. Use sempre DECIMAL para evitar erros de arredondamento que podem arruinar a precisão financeira do sistema.**

--------------------------------------------------------------------------------


## 6. As Cinco Linguagens do SQL: Comandos de Ação

O SQL é dividido em subconjuntos especializados para diferentes tarefas de gestão:

### 1. DDL (Linguagem de Definição de Dados): Gerencia o "esqueleto" e a estrutura dos objetos.
  * CREATE: Constrói novos objetos (Bancos, Tabelas, Schemas).
```sql
-- Cria um novo objeto (Banco ou Tabela).
CREATE TABLE Funcionarios (id INT PRIMARY KEY, nome VARCHAR(50));
```
  * ALTER: Modifica estruturas existentes (ex: adicionar uma coluna).
```sql
-- Modifica a estrutura de uma tabela existente.
ALTER TABLE Funcionarios ADD COLUMN salario DECIMAL(10,2);
```
  * DROP: Exclui permanentemente um objeto e seus dados.
```sql
-- Exclui permanentemente um objeto e seus dados.
DROP TABLE Funcionarios;
```
    
### 2. DML (Linguagem de Manipulação de Dados): Gerencia o conteúdo interno das tabelas.
  * INSERT: Adiciona novas linhas. Pode ser feito via Entrada Manual (VALUES) ou via Consulta (SELECT) de outra tabela.
```Sql
-- Inserindo um único registro
INSERT INTO Funcionarios (id, nome, salario) 
VALUES (1, 'Carlos Silva', 5000.00);

-- Inserindo múltiplos registros de uma vez
INSERT INTO Funcionarios (id, nome, salario) 
VALUES (2, 'Ana Souza', 6500.00), (3, 'Bruno Lima', 4200.00);
```
  * UPDATE: Modifica registros já existentes.
```sql
-- ⚠️ IMPORTANTE: Sempre use WHERE para não alterar a tabela inteira
UPDATE Funcionarios 
SET salario = 5500.00 
WHERE id = 1;
```
  * DELETE: Remove registros específicos.
```sql
-- Removendo um funcionário específico
DELETE FROM Funcionarios 
WHERE id = 3;
```

3. DQL (Linguagem de Consulta de Dados): A ferramenta de busca.
  * SELECT: O comando fundamental para visualizar e filtrar informações.
```sql
-- Selecionar colunas específicas e renomeá-las (Alias)
SELECT nome AS "Nome do Colaborador", salario 
FROM Funcionarios 
WHERE salario > 4000.00 
ORDER BY salario DESC;

-- Selecionar sem duplicatas
SELECT DISTINCT departamento FROM Funcionarios;
```
--------------------------------------------------------------------------------


## 7. Como o Banco de Dados "Pensa": A Ordem Lógica de Avaliação

**A Ordem Lógica de Execução:**

**1. FROM:** O banco localiza a tabela de origem.

**2. WHERE:** O banco filtra as linhas (antes mesmo de olhar para as colunas).

**3. SELECT:** O banco finalmente escolhe quais colunas serão retornadas e aplica funções ou o comando DISTINCT.

**4. ORDER BY:** Por último, o resultado é organizado visualmente para o usuário.

Uma instrução SQL completa também utiliza Identificadores (nomes de tabelas/colunas), Operadores (comparações), Literais (valores fixos) e Aliases (AS) para tornar o resultado legível.

**Exemplo Prático de Consulta Segura:**

```SQL
SELECT DISTINCT ProductName AS Produto, Price AS Preço
FROM Products
WHERE Price > 1000.00
ORDER BY Price DESC
LIMIT 10; -- Retorna apenas os 10 primeiros registros
```
## AGORA VAMOS PRÁTICAR!
