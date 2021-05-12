-- C## 없이 기존 방식대로  사용자 생성
ALTER SESSION SET "_ORACLE_SCRIPT" = true;

-- 연습용 데이터베이스 생성
@?\demo\schema\human_resources\hr_main.sql

-- 계정(schema) 내의 테이블 확인
-- SQL은 값이 아니라면 대소문자 구분 x
Select * From tab;
-- 테이블의 구조 확인
Desc employees;

-----------------------------------
-- Select ~ From
-----------------------------------

-- 가장 기본적인 Select : 전체 데이터 조회
Select * From employees;
Select * From departments;

-- 테이블 내에 정의된 컬럼의 순서대로
-- 특정 컬럼만 선별적으로 Projections
-- 모든 사원의 first_name, 입사일, 급여 출력
Select first_name, hire_date, salary
From employees;

-- 기본적 산술연산을 수행
-- 산술식 자체가 특정 테이블에 소속된 것이 아닐 때 = dual
Select 10 + 20 From dual; --> 가상 테이블

-- 특정 컬럼의 값을 수치로 산술계산을 할 수 있다
-- 직원들의 연봉 계산
Select first_name, salary, salary*12 From employees;

-- 
Select first_name, job_id * 12 From employees; -- 에러 발생
Desc employees; -- job_id는 문자열 -> 산술연산 수행 불가

-- 연습
-- employees 테이블,  first_name, phoen_number, hire_date, salary를 출력
Select first_name, phone_number, hire_date, salary From employees;

-- 사원의 first_name, last_name, salary, phone_number, hire_date를 출력
Select first_name, last_name, salary, phone_number, hire_date From employees;
--

-- Null을 포함한 산술식은 Null
-- 문자열의 연결 ||
-- first_name , last _nam을 연결하여 출력
Select firstname|| ' ' || last_name from employees;

-- 커미션 포함 실질 급여
Select first_name, salary, salary+salary*commission_pct From employees; 
-- 중요★ : 산술 연산식에 null 포함시 결과는 항상 null
-- nvl(ex1, ex2) : ex1이 null이면 ex2를 선택한다.
Select first_name, salary, salary+salary*nvl(commission_pct, 0) From employees;

-- Alias (별칭)
Select first_name, last_name as 성, first_name || ' ' || last_name "Full Name" -- 별칭 내에 공복, 특수문자가 포함될 경우 "로 묶는다.
From employees;

-- 필드 표시명은 일반적으로 한글 등은 쓰지 말자!

----------
-- Where 
----------
-- 조건을 기준으로 레코드 선택(Selection)
-- 급여가 15000 이상인 사원의 이름과 연봉
Select first_name, salary*12 "Annual Salary" 
From employees
Where salary >= 15000;

-- 07/01/01 이후 입사한 사원의 이름과 입사일
Select first_name, hire_date
From employees
Where hire_date >= '07/01/01';

-- 이름이 Lex인 사원의 연봉, 입사일, 부서 id
Select salary*12 "Annual Salary", hire_date, department_id
From employees
Where first_name = 'Lex';

-- 부서 id가 10인 사원의 명단
Select * From employees
Where department_id = 10;

-- 논리 조합
-- 급여가 14000이하 or 17000이상인 사원의 이름과 급여
Select first_name, salary 
From employees
Where salary Between 1400 And 1700;


