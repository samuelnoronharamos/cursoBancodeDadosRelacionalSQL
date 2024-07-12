--select * from funcionarios;

select count(*) from funcionarios;
select count(*) from departamentos;
select count(*) from localizacao;

select count(*) as total,sexo from funcionarios
group by sexo


select count(*) as total,departamento from funcionarios
group by departamento



select max(salario) as "maximo salario" from funcionarios


select max(salario) as "maximo salario", min(salario) as "salario minimo", departamento  from funcionarios
group by departamento

select max(salario) as "maximo salario", min(salario) as "salario minimo", sexo  from funcionarios
group by sexo


-- Mostrando uma quantidade limitada de linhas 

select * from funcionarios
limit 10;

-- Qual o gasto total de salario pago pela empresa?

select sum(salario) from funcionarios


-- Qual o montante total que cada depertamento recebe de salario?

select sum(salario) as montante,departamento from funcionarios
group by departamento

-- Por departamento, qual o total e a media paga para os funcionarios?


select departamento, sum(salario) as montante,avg(salario) as "media salarial" from funcionarios
group by departamento

-- Ordenando

select departamento, sum(salario) as montante,avg(salario) as "media salarial" from funcionarios
group by departamento
order by 3;

select departamento, sum(salario) as montante,avg(salario) as "media salarial" from funcionarios
group by departamento
order by 3 asc;

select departamento, sum(salario) as montante,avg(salario) as "media salarial" from funcionarios
group by departamento
order by 3 desc;

-- Modelagem Banco de dados x Data Science

/* Banco de dados ->  1,2 e 3 formas normais
Evitam redudancia, consequentemente poupam espaço em disco.
Consomem muito processamento em função de joins, Queries lentas.

Data Science e B.I -> Focam em agregacoes e perfomance. Nao se Preocupam
com espaço em disco. Em bi, modelagem minima (dw)
 e data science, preferencialmente modelagem colunar */

-- importando arquivos csv

create table maquinas(
	maquina varchar(30),
	dia int,
	qtde numeric(10,2)
)

copy maquinas
from 'C:\data science\LogMaquinas.csv'
delimiter ','
csv header;

select * from maquinas;

-- Qual a media de cada maquina 

select maquina,avg(qtde) as media from maquinas
group by maquina
order by 2 desc;


-- Arrendondando

--round (coluna,2)

select maquina,round(avg(qtde),2) as media from maquinas
group by maquina
order by 2 desc;

-- qual é a moda de quantidades 

select maquina, qtde, count (*) as moda
from maquinas
group by maquina,qtde
order by 3 desc


-- qual é a moda de quantidades  de cada maquina

select maquina, qtde, count (*) as moda
from maquinas
where maquina = 'Maquina 01'
group by maquina,qtde
order by 3 desc
limit 1;


select maquina, qtde, count (*) as moda
from maquinas
where maquina = 'Maquina 02'
group by maquina,qtde
order by 3 desc
limit 1;

select maquina, qtde, count (*) as moda
from maquinas
where maquina = 'Maquina 03'
group by maquina,qtde
order by 3 desc
limit 1;

-- moda do dataset inteiro

select qtde, count (*) as moda
from maquinas
group by qtde
order by 2 desc

-- qual o maximo e minimo e amplitude de cada maquina

select maquina,
		max(qtde) as maximo,
		min(qtde) as minimo,
		max(qtde) - min(qtde) as amplitude
		from maquinas
		group by maquina
		order by 4 desc;

-- acrescentado a media
select maquina, round(avg(qtde),2) as media,
		max(qtde) as maximo,
		min(qtde) as minimo,
		max(qtde) - min(qtde) as amplitude
		from maquinas
		group by maquina
		order by 4 desc;

-- desvio padrão e variancia

STDDEV_POP (coluna)

var_pop (coluna)

select maquina, 
		round(avg(qtde),2) as media, 
		max(qtde) as maximo,
		min(qtde) as minimo,
		max(qtde) - min(qtde) as amplitude,
		round(STDDEV_POP (qtde),2) as DESV_PAD,
		round(var_pop (qtde),2) AS VARIANCIA
		from maquinas
		group by maquina
		order by 4 desc;


-- funcao e analise mediana no arrquivo 02 - funcao mediana.aql

/* 
	QUANTIDADE
	TOTAL
	MEDIA
	MINIMO
	MAXIMO
	AMPLITUDE
	VARIANCIA
	DESVIO PADRAO
	MEDIANA
	COEF VARIACAO

*/


/*CREATE AGGREGATE median(NUMERIC) (
  SFUNC=array_append,
  STYPE=NUMERIC[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);
					
										 
SELECT MEDIAN(QTDE) AS MEDIANA
FROM MAQUINAS;

SELECT MEDIAN(QTDE) AS MEDIANA
FROM MAQUINAS
WHERE MAQUINA = 'Maquina 01';

*/


select 	maquina,
		count(qtde) as Quantidade,
		sum(qtde) as total,
		round(avg(qtde),2) as media, 
		max(qtde) as maximo,
		min(qtde) as minimo,
		max(qtde) - min(qtde) as amplitude,
		round(STDDEV_POP (qtde),2) as DESV_PAD,
		round(var_pop (qtde),2) AS VARIANCIA,
		round(MEDIAN(QTDE),2) AS MEDIANA,
		round(((STDDEV_POP(qtde)/ avg(qtde))*100),2) as "COEF.VARIACAO",
		MODE() WITHIN GROUP (ORDER BY QTDE) AS "MODA"
		from maquinas
		group by maquina
		order by 1;

-- MODA - MODE() WITHIN GROUP (ORDER BY COLUNA) AS "MODA" FROM MAQUINAS;

SELECT * FROM MAQUINAS;

SELECT MAQUINA, MODE() WITHIN GROUP (ORDER BY QTDE) AS "MODA" FROM MAQUINAS
group by maquina;

-- CRIAÇÃO DAS TABELAS E ETC NO ARQUIVO DE SCRIPT DAS AULAS

SELECT F.NOME, G.NOME, L.DATA, L.DIAS, L.MIDIA
FROM GENERO G
INNER JOIN FILME F
ON G.IDGENERO = F.ID_GENERO
INNER JOIN LOCACAO L
ON L.ID_FILME = F.IDFILME;

/* create table as select */

/*Podemos criar uma tabela com o resultado de uma querie
e essa é a forma de realizar uma modelagem colunar 
CREATE TABLE AS SELECT
*/

CREATE TABLE REL_LOCADORA AS 
SELECT F.NOME AS FILME, G.NOME AS GENERO, L.DATA AS DATA, L.DIAS AS DIAS, L.MIDIA AS MIDIA
FROM GENERO G
INNER JOIN FILME F
ON G.IDGENERO = F.ID_GENERO
INNER JOIN LOCACAO L
ON L.ID_FILME = F.IDFILME;

SELECT * FROM REL_LOCADORA;
-- EXPORTANDO PARA CSV
COPY REL_LOCADORA TO 
'C:\data science\REL_LOCADORA.csv'
DELIMITER ';'
CSV HEADER;

/* SINCRONIZANDO TABELAS E RELATORIOS */

DROP TABLE LOCACAO;

CREATE TABLE LOCACAO(
	IDLOCACAO INT PRIMARY KEY,
	DATA TIMESTAMP,
	MIDIA INT,
	DIAS INT,
	ID_FILME INT,
	FOREIGN KEY(ID_FILME)
	REFERENCES FILME(IDFILME)

);

CREATE SEQUENCE SEQ_LOCACAO;

--NEXTVAl('SEQ_LOCACAO');




INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/08/2018',23,3,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',56,1,400);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'02/07/2018',23,3,400);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'02/02/2018',43,1,500);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'02/02/2018',23,2,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'03/07/2018',76,3,700);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'03/02/2018',45,1,700);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'04/08/2018',89,3,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'04/02/2018',23,3,800);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'05/07/2018',23,3,500);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'05/02/2018',38,3,800);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/10/2018',56,1,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'06/12/2018',23,3,400);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',56,2,300);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'04/10/2018',76,3,300);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/09/2018',32,2,400);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'08/02/2018',89,3,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',23,1,200);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'08/09/2018',45,3,300);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/12/2018',89,1,400);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'09/07/2018',23,3,1000);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/12/2018',21,3,1000);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',34,2,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'09/08/2018',67,1,1000);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',76,3,1000);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',66,3,200);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'09/12/2018',90,1,400);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'03/02/2018',23,3,100);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/12/2018',65,5,1000);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'03/08/2018',43,1,1000);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),'01/02/2018',27,31,200);


SELECT * FROM LOCACAO;
SELECT * FROM GENERO;
SELECT * FROM FILME;
SELECT * FROM REL_LOCADORA;


DROP TABLE REL_LOCADORA;

SELECT L.IDLOCACAO, F.NOME AS FILME, G.NOME AS GENERO, L.DATA AS DATA, L.DIAS AS DIAS, L.MIDIA AS MIDIA
FROM GENERO G
INNER JOIN FILME F
ON G.IDGENERO = F.ID_GENERO
INNER JOIN LOCACAO L
ON L.ID_FILME = F.IDFILME;

CREATE TABLE RELATORIO_LOCADORA AS
SELECT L.IDLOCACAO, F.NOME AS FILME, G.NOME AS GENERO, L.DATA AS DATA, L.DIAS AS DIAS, L.MIDIA AS MIDIA
FROM GENERO G
INNER JOIN FILME F
ON G.IDGENERO = F.ID_GENERO
INNER JOIN LOCACAO L
ON L.ID_FILME = F.IDFILME;

SELECT * FROM RELATORIO_LOCADORA;

SELECT * FROM LOCACAO;
-- SELECT PARA TRAZER OS REGISTROS NOVOS
SELECT MAX (IDLOCACAO) AS RELATORIO, (SELECT MAX (IDLOCACAO) FROM LOCACAO) AS LOCACAO
FROM RELATORIO_LOCADORA

INSERT INTO RELATORIO_LOCADORA	
SELECT L.IDLOCACAO, F.NOME AS FILME, G.NOME AS GENERO, L.DATA AS DATA, L.DIAS AS DIAS, L.MIDIA AS MIDIA
FROM GENERO G
INNER JOIN FILME F
ON G.IDGENERO = F.ID_GENERO
INNER JOIN LOCACAO L
ON L.ID_FILME = F.IDFILME
WHERE IDLOCACAO NOT IN (SELECT IDLOCACAO FROM RELATORIO_LOCADORA);

SELECT MAX (IDLOCACAO) AS RELATORIO, (SELECT MAX (IDLOCACAO) FROM LOCACAO) AS LOCACAO
FROM RELATORIO_LOCADORA

-- VAMOS DEIXAR ESSE PROCEDIMENTO AUTOMATICO POR MEIO DE UMA TRIGGER

CREATE OR REPLACE FUNCTION ATUALIZA_REAL()
RETURNS TRIGGER AS $$
BEGIN

INSERT INTO RELATORIO_LOCADORA	
SELECT L.IDLOCACAO, F.NOME AS FILME, G.NOME AS GENERO, L.DATA AS DATA, L.DIAS AS DIAS, L.MIDIA AS MIDIA
FROM GENERO G
INNER JOIN FILME F
ON G.IDGENERO = F.ID_GENERO
INNER JOIN LOCACAO L
ON L.ID_FILME = F.IDFILME
WHERE IDLOCACAO NOT IN (SELECT IDLOCACAO FROM RELATORIO_LOCADORA);

COPY RELATORIO_LOCADORA TO 
'C:\data science\RELATORIO_LOCADORA.csv'
DELIMITER ';'
CSV HEADER; 

RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

-- COMANDO PARA APAGAR UMA TRIGGER 

DROP TRIGGER TG_RELATORIO ON LOCACAO;

CREATE TRIGGER TG_RELATORIO 
AFTER INSERT ON LOCACAO
FOR EACH ROW
	EXECUTE PROCEDURE ATUALIZA_REAL();

-- INSERINDO NOVOS REGISTROS

INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),NOW(),100,7,300);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),NOW(),500,1,200);
INSERT INTO LOCACAO VALUES(NEXTVAL('SEQ_LOCACAO'),NOW(),800,6,500);

SELECT * FROM LOCACAO;
SELECT * FROM RELATORIO_LOCADORA;

-- SINCRONIZANDO COM REGISTROS DELETADOS

CREATE OR REPLACE FUNCTION DELETE_LOCACAO()
RETURNS TRIGGER AS $$
BEGIN

DELETE FROM RELATORIO_LOCADORA
WHERE IDLOCACAO = OLD.IDLOCACAO;

COPY RELATORIO_LOCADORA TO 
'C:\data science\RELATORIO_LOCADORA.csv'
DELIMITER ';'
CSV HEADER;
	
RETURN OLD;
END;
$$
LANGUAGE PLPGSQL

CREATE TRIGGER DELETE_REG
	BEFORE DELETE ON LOCACAO
	FOR EACH ROW
	EXECUTE PROCEDURE DELETE_LOCACAO();

SELECT * FROM LOCACAO;

SELECT * FROM RELATORIO_LOCADORA;

DELETE FROM LOCACAO
WHERE IDLOCACAO = 1;

-- EXERCICIOS
SELECT * FROM FUNCIONARIOS;

/*
select 	maquina,
		count(qtde) as Quantidade,
		sum(qtde) as total,
		round(avg(qtde),2) as media, 
		max(qtde) as maximo,
		min(qtde) as minimo,
		max(qtde) - min(qtde) as amplitude,
		round(STDDEV_POP (qtde),2) as DESV_PAD,
		round(var_pop (qtde),2) AS VARIANCIA,
		round(MEDIAN(QTDE),2) AS MEDIANA,
		round(((STDDEV_POP(qtde)/ avg(qtde))*100),2) as "COEF.VARIACAO",
		MODE() WITHIN GROUP (ORDER BY QTDE) AS "MODA"
		from maquinas
		group by maquina
		order by 1;
*/

-- MODA DOS SALARIOS
SELECT MODE() WITHIN GROUP (ORDER BY SALARIO) AS "MODA" 
FROM FUNCIONARIOS

-- MODA POR DEPARTAMENTO
-- JARDIM
	
SELECT DEPARTAMENTO,MODE() WITHIN GROUP (ORDER BY SALARIO) AS "MODA" 
FROM FUNCIONARIOS
GROUP BY DEPARTAMENTO
ORDER BY 2 DESC;

-- DESVIO PADRAO DE CADA DEPARTAMENTO

SELECT DEPARTAMENTO,round(STDDEV_POP (SALARIO),2) as DESV_PAD
FROM FUNCIONARIOS
GROUP BY DEPARTAMENTO

-- MEDIANA SALARIAL DE TODO O SET DE DADOS
SELECT round(MEDIAN(SALARIO),2) AS MEDIANA
FROM FUNCIONARIOS

-- QUAL A AMPLITUDE DE TODOS OS SALARIOS

SELECT max(SALARIO) - min(SALARIO) as amplitude
FROM FUNCIONARIOS

-- PRINCIPAIS ESTATISTICAS POR DEPARTAMENTO

SELECT DEPARTAMENTO,
	MODE() WITHIN GROUP (ORDER BY SALARIO) AS "MODA" ,
	sum(SALARIO) as total,
	round(avg(SALARIO),2) as media, 
	max(SALARIO) as maximo,
	min(SALARIO) as minimo,
	max(SALARIO) - min(SALARIO) as amplitude,
	round(STDDEV_POP (SALARIO),2) as DESV_PAD,
	round(var_pop (SALARIO),2) AS VARIANCIA,
	round(MEDIAN(SALARIO),2) AS MEDIANA,
	round(((STDDEV_POP(SALARIO)/ avg(SALARIO))*100),2) as "COEF.VARIACAO",
	MODE() WITHIN GROUP (ORDER BY SALARIO) AS "MODA"

	FROM FUNCIONARIOS
GROUP BY DEPARTAMENTO
ORDER BY 11 ASC;

-- OUTDOORS PQ O COEF DE VARIACAO É MENOR

/* UTILIZANDO O CASE */

SELECT NOME, SEXO FROM FUNCIONARIOS;


SELECT NOME, CARGO,
CASE
	WHEN CARGO = 'Financial Advisor' THEN 'Condicao 01'
	WHEN CARGO = 'Structural Engineer'THEN 'Condicao 02'
	WHEN CARGO = 'Executive Secretary'THEN 'Condicao 03'
	ELSE 'OUTRAS CONDICOES'
	
END AS "CONDICOES"
FROM FUNCIONARIOS;

SELECT CARGO FROM FUNCIONARIOS;

SELECT NOME,
CASE
		WHEN SEXO = 'Masculino' THEN 'M'
		ELSE 'F'
END AS "SEXO"
FROM FUNCIONARIOS;

-- Utilizando valores booleanos -- VARIABLE DUMMY

SELECT NOME, CARGO, (SEXO = 'Masculino' as Masculino, (SEXO = 'Feminino') as Feminino
FROM FUNCIONARIOS;

-- Mesclando as tecnias 

SELECT NOME, CARGO,
CASE

	WHEN (SEXO = 'Masculino') = true THEN 1
	ELSE 0
END AS "MASCULINO",
CASE
	WHEN (SEXO = 'Feminino') = true THEN 1
	ELSE 0
END AS "FEMININO"
FROM FUNCIONARIOS;

-- FILTROS DE GRUPO

-- FILTROS BASEADOS EM VALORES NUMERICOS

SELECT NOME,DEPARTAMENTO, SALARIO
FROM FUNCIONARIOS
WHERE SALARIO > 100000;

-- FILTROS BASEADOS EM STRINGS

SELECT NOME,DEPARTAMENTO, SALARIO
FROM FUNCIONARIOS
WHERE DEPARTAMENTO = 'Ferramentas';

-- FILTROS BASEADOS EM MULTIPLOS TIPOS E COLUNA - CONSIDERAR OR E AND

SELECT NOME,DEPARTAMENTO, SALARIO
FROM FUNCIONARIOS
WHERE DEPARTAMENTO = 'Ferramentas'
and SALARIO > 100000;

-- FILTRO BASEADO EM UM UNICO TIPO E COLUNA - ATENCAO PARA REGRA DO AND E DO OR
-- EM RELACIONAMENTOS 1X1 FILTRO AND TRATANDO DE UMA UNICA COLUNA SEMPRE DARA FALSO

SELECT NOME,DEPARTAMENTO, SALARIO
FROM FUNCIONARIOS
WHERE DEPARTAMENTO = 'Ferramentas'
and 
DEPARTAMENTO = 'Books';

-- FILTROS BASEADOS EM PADRAO DE CARACTERES

SELECT DEPARTAMENTO,SUM(SALARIO) AS "TOTAL"
FROM FUNCIONARIOS
WHERE 
DEPARTAMENTO LIKE  'B%'
GROUP BY DEPARTAMENTO;


-- FILTROS BASEADOS EM PADRAO DE CARACTERES COM MAIS LETRAS


SELECT DEPARTAMENTO,SUM(SALARIO) AS "TOTAL"
FROM FUNCIONARIOS
WHERE 
DEPARTAMENTO LIKE  'Be%'
GROUP BY DEPARTAMENTO;


-- FILTROS BASEADOS EM CARACTERE CORINGA NO MEIO DA PALAVRA

SELECT DEPARTAMENTO,SUM(SALARIO) AS "TOTAL"
FROM FUNCIONARIOS
WHERE 
DEPARTAMENTO LIKE  'B%s'
GROUP BY DEPARTAMENTO;


-- e se filtrar o agrupamento pelo salario, por exemplom maior que '40.000.000'
-- Colunas nao agregadas - WHERE
-- Colunas agregadas - Having


SELECT DEPARTAMENTO,SUM(SALARIO) AS "TOTAL"
FROM FUNCIONARIOS
WHERE 
DEPARTAMENTO LIKE  'B%'
GROUP BY DEPARTAMENTO
HAVING SUM(SALARIO) > 4000000;

-- MULTIPLOS CONTADORES -- FILTER SÓ SE USA COM COUNT

SELECT COUNT(*) FROM FUNCIONARIOS;

SELECT COUNT(*) AS "QUANTIDADE TOTAL",
COUNT('Masculino') as "Masculino"
FROM FUNCIONARIOS;

SELECT SEXO, COUNT(*)
FROM FUNCIONARIOS
WHERE SEXO = 'Masculino'
GROUP BY SEXO;

SELECT COUNT(*) AS "QUANTIDADE TOTAL",
(SELECT COUNT(*) 
FROM FUNCIONARIOS
WHERE SEXO = 'Masculino'
GROUP BY SEXO) AS "Masculino"
FROM FUNCIONARIOS;

-- FILTER FUNCIONAL
SELECT COUNT(*) AS "QUANTIDADE TOTAL",
COUNT(*) FILTER (WHERE SEXO = 'Masculino') AS "MASCULINO",
COUNT(*) FILTER (WHERE DEPARTAMENTO = 'Books') AS "Books",
COUNT(*) FILTER (WHERE SALARIO > 140000) AS "SALARIO > 140K"
FROM FUNCIONARIOS;

-- REFORMATAÇÃO DE STRINGS
--LISTANDO
SELECT DEPARTAMENTO FROM FUNCIONARIOS;

-- DISTINCT

SELECT DISTINCT DEPARTAMENTO FROM FUNCIONARIOS;

-- UPPER CASE

SELECT DISTINCT UPPER(DEPARTAMENTO) FROM FUNCIONARIOS;

-- LOWER CASE

SELECT DISTINCT LOWER(DEPARTAMENTO) FROM FUNCIONARIOS;

-- CONCATENACAO STRINGS 

SELECT CARGO || ' - ' || DEPARTAMENTO 
FROM FUNCIONARIOS;

SELECT Upper(CARGO || ' - ' || DEPARTAMENTO)  AS "Cargo Completo"
FROM FUNCIONARIOS;

-- REMOVER ESPAÇOS

SELECT '       UNIDADOS   ';

SELECT LENGTH ('       UNIDADOS   '); 

SELECT TRIM ('       UNIDADOS   '); 

SELECT LENGTH(TRIM ('       UNIDADOS   ')); 


-- Desafio - Criar uma coluna ao lado da coluna cargo que diga se a pessoa é assistente ou nao

SELECT * FROM FUNCIONARIOS;

SELECT NOME,CARGO
FROM FUNCIONARIOS
WHERE Cargo LIKE '%Assistant%'



SELECT NOME,CARGO,
CASE
	WHEN (CARGO LIKE '%Assistant%') = true THEN 'SIM'
	ELSE 'NÃO'
END AS "Assistente?"
FROM FUNCIONARIOS;	




