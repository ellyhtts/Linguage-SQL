# Modelagem de Dados e Consultas Avançadas

## 1. Chaves Estrangeiras (Foreign Keys)
[cite_start]A chave estrangeira é um campo de uma tabela que aponta para a chave primária de outra tabela[cite: 36]. [cite_start]Ela serve para criar relacionamento entre tabelas[cite: 37]. [cite_start]Em outras palavras, a chave estrangeira é o que “liga” uma tabela à outra em um banco de dados relacional[cite: 39].

A utilização dessas chaves é fundamental para a arquitetura do banco:
* [cite_start]Sem chave estrangeira, as tabelas ficam isoladas e não há garantia de que os dados combinam, podendo existir registros “órfãos” (sem relação real)[cite: 41, 42, 43, 44].
* [cite_start]Com chave estrangeira, o banco garante integridade dos dados e evita erros e inconsistências[cite: 45, 46, 47]. 
* [cite_start]Ela representa relações do mundo real, como um cliente e seu pedido[cite: 48].

## 2. Normalização
[cite_start]Normalizar um banco de dados é organizar as informações para que cada dado exista apenas uma vez, evitando repetição, erros e bagunça nas tabelas[cite: 72]. O processo é dividido em formas normais:

* [cite_start]**Primeira Forma Normal (1FN):** Os campos devem ser atômicos, ou seja, possuir um único valor por célula[cite: 100, 101].
* [cite_start]**Segunda Forma Normal (2FN):** Deve estar na 1FN e remover dependências parciais[cite: 143, 144]. [cite_start]Cada entidade passa a ter sua própria tabela e ter sua própria chave primária[cite: 145].
* [cite_start]**Terceira Forma Normal (3FN):** Deve estar na 2FN e remover dependências transitivas[cite: 188, 189]. [cite_start]Campos não-chave devem depender apenas da chave[cite: 190].

[cite_start]O resultado da normalização é um banco de dados com ausência de redundância e relacionamentos claros através de chaves estrangeiras[cite: 242, 243]. [cite_start]Isso torna o banco de dados mais eficiente, mais confiável e de manutenção facilitada[cite: 246, 248, 249].

## 3. Consultas Avançadas: JOINS
[cite_start]Conectamos tabelas lateralmente através de uma coluna comum (Chave) utilizando Joins para adição horizontal de colunas[cite: 3, 4].
* [cite_start]**Inner Join:** Retorna apenas o que existe em ambas as tabelas[cite: 5].
* [cite_start]**Left Join:** Mantemos tudo da tabela à esquerda e trazemos o que houver da direita[cite: 6].
* [cite_start]**Right Join:** Mantemos tudo da direita e trazemos o que houver da esquerda[cite: 7].
* [cite_start]**Full Join:** Trazemos tudo de ambos os lados, independentemente de haver correspondência[cite: 8].

## 4. Consultas Avançadas: Operadores SET
[cite_start]Para adição vertical de linhas, empilhamos resultados de consultas diferentes, desde que tenham a mesma estrutura de colunas[cite: 16, 17]:
* [cite_start]**UNION:** Combina os resultados e remove duplicados[cite: 18].
* [cite_start]**UNION ALL:** Combina tudo, incluindo duplicados, e é mais rápido[cite: 19].
* [cite_start]**EXCEPT / MINUS:** Mostra o que existe no primeiro conjunto mas não no segundo[cite: 20].
* [cite_start]**INTERSECT:** Mostra apenas o que é comum a ambos os conjuntos[cite: 21].
