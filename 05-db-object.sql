--------------------
-- DB OBJECTS
--------------------

-- SYSTEM 계정 CREATE VIEW 권한 부여
GRANT CREATE VIEW TO C##KBJ;
-- 사용자 계정으로 복귀

-- SIMPLEVIEW
-- 단일 테이블, 함수나 연산식을 포함한 컬럼이 없는 단순 뷰
DROP TABLE emp123;
CREATE TABLE emp123
    AS SELECT * FROM employees
        WHERE department_id IN (10, 20, 30);
SELECT * FROM emp123;

-- emp123 테이블을 기반으로 30번 부서 사람들만 보여주는 View 생성
CREATE OR REPLACE VIEW emp10
    AS SELECT employee_id, first_name, last_name, salary
        FROM emp123
            WHERE department_id = 10;

DESC emp10;

-- VIEW는 테이블처럼 SELECT 가능
-- 다만 실제 데이터는 원본 테이블 내에 있는 데이터 활용
SELECT * FROM emp10;
SELECT first_name||' '||last_name, salary FROM emp10;

-- SIMPLE VIEW는 제약 사항에 위배되지 않는다면 내용 갱신 가능
-- salary를 2배로 올리자
SELECT first_name, salary FROM emp10;
UPDATE emp10 SET salary = salary*2;
SELECT first_name, salary FROM emp10;
SELECT first_name, salary FROM emp123; 
-- VIEW를 갱신했지만 emp10 view는 emp123 table을 참고하고 있으므로 table의 데이터도 변경
ROLLBACK;
-- VIEW는 가급적 조회용으로만 사용하도록 하자 (READ ONLY로 VIEW 생성)

CREATE OR REPLACE VIEW emp10
    AS SELECT employee_id, first_name, last_name, salary
        FROM emp123
        WHERE department_id = 10
    WITH READ ONLY;
    
SELECT * FROM emp10;

UPDATE emp10 SET salary = salary*2;
-- 복합 뷰
DESC author;
DESC book;
-- author와 book의 join 정보를 출력하는 복합 뷰
CREATE OR REPLACE VIEW book_detail
    (book_id, title, author_name, pub_date)
    AS SELECT book_id,
            title,
            author_name,
            pub_date
        FROM book b, author a
        WHERE b.author_id = a.author_id;
        
DESC book_detail;

SELECT * FROM book_detail;

UPDATE book_detail SET author_name = "Unknown";
-- 복합 뷰에서는 기본적으로 DML 수행할 수 없다