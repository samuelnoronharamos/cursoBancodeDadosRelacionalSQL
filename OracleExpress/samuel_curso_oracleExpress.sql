CREATE TABLESPACE RECURSOS_HUMANOS
DATAFILE 'C:/DATA/RH_01.DBF'
SIZE 100M AUTOEXTEND 
ON NEXT 100M
MAXSIZE 4096M

ALTER TABLESPACE RECURSOS_HUMANOS
ADD DATAFILE 'C:/DATA/RH_02.DBF'
SIZE 200M AUTOEXTEND 
ON NEXT 100M
MAXSIZE 4096M

SELECT TABLESPACE_NAME, FILE_NAME FROM DBA_DATA_FILES;

-- SEQUENCES

CREATE SEQUENCE SEQ_GERAL
START WITH 100
INCREMENT BY 10;

-- CRIANDO UMA TABELA NA TABLESPACE

CREATE TABLE FUNCIONARIOS(
    IDFUNCIONARIO INT PRIMARY KEY,
    NOME VARCHAR2(30)

) TABLESPACE RECURSOS_HUMANOS;

INSERT INTO FUNCIONARIOS VALUES (SEQ_GERAL.NEXTVAL,'JOAO');
INSERT INTO FUNCIONARIOS VALUES (SEQ_GERAL.NEXTVAL,'CLARA');
INSERT INTO FUNCIONARIOS VALUES (SEQ_GERAL.NEXTVAL,'LILIAM');

SELECT * FROM FUNCIONARIOS;

-- CRIANDO UMA TABLESPACE DE MARKETING

CREATE TABLESPACE MARKETING
DATAFILE 'C:/DATA/MKT_01.DBF'
SIZE 100M AUTOEXTEND 
ON NEXT 100M
MAXSIZE 4096M

CREATE TABLE CAMPANHAS(
    IDCAMPANHA INT PRIMARY KEY,
    NOME VARCHAR2(30)

) TABLESPACE MARKETING;

INSERT INTO CAMPANHAS VALUES (SEQ_GERAL.NEXTVAL,'PRIMAVERA');
INSERT INTO CAMPANHAS VALUES (SEQ_GERAL.NEXTVAL,'VERAO');
INSERT INTO CAMPANHAS VALUES (SEQ_GERAL.NEXTVAL,'INVERNO');

SELECT * FROM FUNCIONARIOS;
SELECT * FROM CAMPANHAS;

--COLOCANDO A TABLESPACE OFFLINE

ALTER TABLESPACE RECURSOS_HUMANOS OFFLINE;

-- APONTAR PARA O DICIONARIO DE DADOS
ALTER TABLESPACE RECURSOS_HUMANOS
RENAME DATAFILE 'C:/DATA/RH_01.DBF' TO 'C:/PRODUCAO/RH_01.DBF';

ALTER TABLESPACE RECURSOS_HUMANOS
RENAME DATAFILE 'C:/DATA/RH_02.DBF' TO 'C:/PRODUCAO/RH_02.DBF';

--TORNANDO A TABLESPACE ONLINE

ALTER TABLESPACE RECURSOS_HUMANOS ONLINE;

SELECT * FROM FUNCIONARIOS;
SELECT * FROM CAMPANHAS;

DROP TABLE ALUNO;

CREATE TABLE ALUNO(
    IDALUNO INT PRIMARY KEY,
    NOME VARCHAR2(30),
    EMAIL VARCHAR2(30),
    SALARIO NUMBER(10,2)
);


CREATE SEQUENCE SEQ_EXEMPLO;

INSERT INTO ALUNO VALUES(SEQ_EXEMPLO.NEXTVAL,'JOAO','JOAO@GMAIL.COM',1000.00);
INSERT INTO ALUNO VALUES(SEQ_EXEMPLO.NEXTVAL,'CLARA','CLARA@GMAIL.COM',2000.00);
INSERT INTO ALUNO VALUES(SEQ_EXEMPLO.NEXTVAL,'CELIA','CELIA@GMAIL.COM',3000.00);

SELECT * FROM ALUNO;

CREATE TABLE ALUNO2(
    IDALUNO INT PRIMARY KEY,
    NOME VARCHAR2(30),
    EMAIL VARCHAR2(30),
    SALARIO NUMBER(10,2)
);

INSERT INTO ALUNO2 VALUES(SEQ_EXEMPLO.NEXTVAL,'JOAO','JOAO@GMAIL.COM',1000.00);
INSERT INTO ALUNO2 VALUES(SEQ_EXEMPLO.NEXTVAL,'CLARA','CLARA@GMAIL.COM',2000.00);
INSERT INTO ALUNO2 VALUES(SEQ_EXEMPLO.NEXTVAL,'CELIA','CELIA@GMAIL.COM',3000.00);


SELECT * FROM ALUNO2;

-- ROW ID E ROWNUM

SELECT ROWID,IDALUNO,NOME, EMAIL FROM ALUNO

-- ROWNUM PRA PAGINAR
SELECT ROWID,ROWNUM,IDALUNO,NOME, EMAIL FROM ALUNO2;

SELECT NOME,EMAIL FROM ALUNO WHERE ROWNUM <=2;

-- PROCEDURE

CREATE OR REPLACE PROCEDURE BONUS(P_IDALUNO ALUNO.IDALUNO%TYPE, P_PERCENT NUMBER)
AS
    BEGIN
            UPDATE ALUNO SET SALARIO = SALARIO + ( SALARIO * (P_PERCENT/100))
            WHERE P_IDALUNO = P_IDALUNO;    

    END;
    /
SELECT * FROM ALUNO;

CALL BONUS(3,10);

-- TRIGGERS DEVE TER O TAMANHO MAXIMO DE 32KB E NAO EXECUTAM COMANDO DE DTL - COMMIT, ROLLBACK E SAVEPOINTS

CREATE OR REPLACE TRIGGER CHECK_SALARIO
BEFORE INSERT OR UPDATE ON ALUNO
FOR EACH ROW
BEGIN
        IF: NEW.SALARIO > 2000 THEN 
            RAISE_APPLICATION_ERROR(-20000,'VALOR INCORRETO');
        END IF;
        

END;
/

SHOW ERRORS;


CREATE OR REPLACE TRIGGER CHECK_SALARIO
BEFORE INSERT OR UPDATE ON ALUNO
FOR EACH ROW
BEGIN
        IF: NEW.SALARIO < 2000 THEN 
            RAISE_APPLICATION_ERROR(-20000,'VALOR INCORRETO');
        END IF;
        

END;
/

INSERT INTO ALUNO VALUES(SEQ_EXEMPLO.NEXTVAL,'MAFRA','MAFRA@GMAIL.COM',100.00);


SELECT TRIGGER_NAME, TRIGGER_BODY
FROM USER_TRIGGERS;


- TRIGGER DE EVENTOS

CREATE TABLE AUDITORIA(
    DATA_LOGIN DATE,
    LOGIN VARCHAR2(30)
);

CREATE OR REPLACE PROCEDURE LOGPROC IS 
BEGIN
    INSERT INTO AUDITORIA(DATA_LOGIN, LOGIN)
    VALUES (SYSDATE,USER)
END LOGPROC;
/

CREATE OR REPLACE TRIGGER LOGTRIGGER 
AFTER LOGON ON DATABASE
CALL LOGPROC
/

-- FALHA DE LOGON



CREATE OR REPLACE TRIGGER FALHA_LOGON 
AFTER SERVERERROR
ON DATABASE
BEGIN
    IF(IS_SERVERERROR(1017)) THEN
     INSERT INTO AUDITORIA(DATA_LOGIN, LOGIN)
     VALUES(SYSDATE,'ORA-1017);
    END IF;

END FALHA_LOGON;
/

-- 1004 default username feature not supported
-- 1005 password nulo
-- 1045 privilegio insuficiente

--  TRIGGER DE backups

CREATE TABLE USUARIO(
    ID INT,
    NOME VARCHAR2(30)
 );
 
 CREATE TABLE BKP_USER(
    ID INT,
    NOME VARCHAR2(30)
);
    INSERT INTO USUARIO VALUES(1,'JOAO');
    INSERT INTO USUARIO VALUES(2,'CLARA');
    COMMIT;
SELECT * FROM USUARIO;


CREATE OR REPLACE TRIGGER LOG_USUARIO
BEFORE DELETE ON USUARIO
FOR EACH ROW
BEGIN
    INSERT INTO BKP_USER VALUES
    (:OLD.ID, :OLD.NOME);


END;
/

DELETE FROM USUARIO WHERE ID = 1;
SELECT * FROM BKP_USER;
SELECT * FROM USUARIO;

INSERT INTO USUARIO VALUES(3,'DADE');
DELETE FROM USUARIO WHERE ID = 3;


-- DEFERRABLE CONSTRAINTS 

CREATE TABLE FUNCIONARIO(
    IDFUNCIONARIO INT CONSTRAINT PK_FUNCIONARIO PRIMARY KEY,
    NOME VARCHAR2(100)
);

CREATE TABLE TELEFONE(
    IDTELEFONE INT PRIMARY KEY,
    NUMERO VARCHAR2(10),
    ID_FUNCIONARIO INT
);

SELECT * FROM TELEFONE;

ALTER TABLE TELEFONE ADD CONSTRAINT FK_TELEFONE
FOREIGN KEY (ID_FUNCIONARIO) REFERENCES FUNCIONARIO;

INSERT INTO FUNCIONARIO VALUES (1,'MAURICIO');
INSERT INTO TELEFONE VALUES (10,'32323232',1);

 -- A CONSTRAINT DE INTEGRIDADE REFERENCIAL (FK)CHECAA INTEGRIDADE LOGO AP�S O COMANDO DE DML (INSERT/DELETE/UPDATE) 
 -- NAO POSSSIBILITANDO ASSIM A INSER��O DE REGISTROS SEM REFERENCIA 
 
 -- VERIFICANDO O ESTADO DAS CONTRAINTS
 
 SELECT CONSTRAINT_NAME, DEFERRABLE, DEFERRED
 FROM USER_CONSTRAINTS WHERE TABLE_NAME IN ('FUNCIONARIO','TELEFONE');
 
 ALTER TABLE TELEFONE  DROP CONSTRAINT FK_TELEFONE;
 
 -- RECRIANDO A CONSTRAINT 
 
 ALTER TABLE TELEFONE ADD CONSTRAINT FK_TELEFONE
 FOREIGN KEY(ID_FUNCIONARIO) REFERENCES FUNCIONARIO
 DEFERRABLE;
 
 SELECT CONSTRAINT_NAME, DEFERRABLE AS ATRASADA, DEFERRED AS VERIFICACAO
 FROM USER_CONSTRAINTS WHERE TABLE_NAME IN ('FUNCIONARIO','TELEFONE');
 
 INSERT INTO TELEFONE VALUES (4,'121212',10);
 
 -- MUDANDO PARA A DTL
 
 SET CONSTRAINTS ALL DEFERRED;
 
 

  INSERT INTO TELEFONE VALUES (4,'121212',10);
COMMIT;


 
 
