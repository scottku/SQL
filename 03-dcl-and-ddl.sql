----------------
-- ����� ����
----------------
-- SYSTEM �������� ���� --
-- CREATE(����), ALTER(����), DROP(����) Ű����

-- ����� ����
CREATE USER C##KBJ IDENTIFIED BY 1234;
-- ��й�ȣ ����
ALTER USER C##KBJ IDENTIFIED BY test;
-- ������� ����
DROP USER C##KBJ;
-- ��쿡 ���� ���ο� ���̺� �� �����ͺ��̽� ��ü�� ������ �����
DROP USER C##KBJ CASCADE; -- ������

-- �ٽ� ����� ������
CREATE USER C##KBJ IDENTIFIED BY 1234;
-- SQLPlus�� ���� �õ�
-- ����ڸ� �����ص�, ""����""�� �ο����� ������ �ƹ� �ϵ� �� �� ����

-- ����� ������ Ȯ��
-- USER_USERS : ���� ����� ���� ����
-- ALL_USERS : ��ü ����� ����
-- DBA_USERS : ��� ������� �� ����(DBA ����)
DESC USER_USERS;
SELECT * FROM USER_USERS;

SELECT * FROM ALL_USERS;

DESC DBA_USERS;
SELECT * FROM DBA_USERS;

-- ����� �������� ���� ���� �ο�
GRANT create session TO C##KBJ;
-- �Ϲ������� �����ͺ��̽� ����, ���̺� ����� ����Ϸ���
-- connect, resource ���� �ο�
ALTER USER C##KBJ IDENTIFIED BY test;
GRANT connect, resource TO C##KBJ;
-- Oracle 12 �̻󿡼��� ����� ���̺� �����̽��� ���� �ο� �ʿ�
ALTER USER C##KBJ DEFAULT TABLESPACE USERS QUOTA unlimited ON USERS;

-- �ý��� ������ �ο�
-- GRANT ����(����)�� TO �����;
-- �ý��� ������ ��Ż
-- REVOKE ����(����)�� FROM �����;

-- ��Ű�� ��ü�� ���� ������ �ο�
-- GRANT ���� ON ��ü TO �����;
-- ��Ű�� ��ü�� ���� ������ ��Ż
-- REVOKE ���� ON ��ü FROM �����;
GRANT select ON hr.employees TO C##KBJ;
GRANT select ON hr.departments TO C##KBJ;

-- ���� ����� �������� ����
SELECT * FROM hr.employees;
SELECT * FROM hr.departments;

-- �ٽ� System �������� hr.departments�� select ��ȯ ȸ��
REVOKE select ON hr.departments FROM c##KBJ;

-- �ٽ� ����� ����
SELECT * FROM hr.departments; -- ���� ��Ż�� �Ұ���

---------------
-- DDL
---------------
CREATE TABLE book ( -- �÷��� ����
  book_id NUMBER(5), -- 5�ڸ� ���� Ÿ�� -> PK ���� ����
  title VARCHAR2(50), -- 50�ڸ� ���� ���ڿ�
  author VARCHAR2(10), -- 10�ڸ� ���� ���ڿ�
  pub_date DATE DEFAULT sysdate -- ��¥ Ÿ��(�⺻�� -> ���� ��¥�� �ð�)
);
DESC book;

-- ���� ������ �̿��� �� ���̺� ����
-- hr.employees ���̺��� �Ϻ� �����͸� ����, �� ���̺� �����
SELECT * FROM hr.employees WHERE job_id LIKE 'IT%'; -- �������� ����� �� ���̺� ����

CREATE TABLE it_emp AS (
  SELECT * FROM hr.employees 
  WHERE job_id LIKE 'IT_%'
);
DESC it_emp;
SELECT * FROM it_emp;

-- ���� ���� ���̺��� ���
SELECT * FROM tab;

-- ���̺� ����
DROP TABLE it_emp;
SELECT * FROM tab; --> �̻��� table ���� -> ������ó�� ������ ���� �ѹ� ������Ŵ
-- ������ ����
PURGE RECYCLEBIN;
SELECT * FROM tab;

-- ���̺� �߰�
CREATE TABLE author (
  author_id NUMBER(10),
  author_name VARCHAR2(100) NOT NULL, -- �÷� ���� ���� (not null)
  author_desc VARCHAR2(500),
  PRIMARY KEY (author_id) -- ���̺� ���� ����
);
DESC book;
DESC author;

-- book ���̺��� author �÷� ����
-- ���߿� author ���̺�� ����
ALTER TABLE book DROP COLUMN author;
DESC book;

-- author.author_id�� �����ϱ� ���� author_id �÷��� book ���̺� �߰�
ALTER TABLE book ADD (author_id NUMBER(10));
DESC book;

-- book.book_id�� NUMBER(10)���� ����
ALTER TABLE book MODIFY (book_id NUMBER(10));
DESC book;

-- book.author_id -> author.author_id�� �����ϵ��� ����
ALTER TABLE book 
ADD CONSTRAINT -- �������� �߰�
  fk_author_id FOREIGN KEY(author_id)
                  REFERENCES author(author_id);
-- book table�� author_id �÷���
--    author ���̺��� author_id(PK)�� �����ϴ� �ܷ� Ű(FK) �߰�
DESC book;

---------------
-- DATA DICTIONARY
---------------
-- ����Ŭ�� �����ϴ� �����ͺ��̽� ���� �������� ��Ƶ� Ư���� �뵵�� ���̺�
-- USER_ : ���� �α����� ����� ������ ��ü��
-- ALL_ : ����� ��ü ����� ����
-- DBA_ : �����ͺ��̽� ��ü�� ���õ� ����(������ ����)

-- ��� ��ųʸ� Ȯ��
SELECT * FROM DICTIONARY;

-- ������� ��Ű�� ��ü Ȯ��: USER_OBJECTS
SELECT * FROM USER_OBJECTS;
SELECT object_name, object_type FROM USER_OBJECTS;

-- ���� ���� �������� : USER_CONSTRAINTS
SELECT * FROM USER_CONSTRAINTS;

-- BOOK ���̺� �ɷ� �ִ� �������� Ȯ��
SELECT constraint_name,
    constraint_type,
    search_condition
FROM USER_CONSTRAINTS
WHERE table_name = 'BOOK';