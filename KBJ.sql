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
Where salary <= 14000 or salary >= 17000;

-- 여집합
Select first_name, salary
From employees
Where Not (salary >= 14000 And salary <= 17000);

-- 부서 id가 90 이상인 사원 중, 급여가 20000 이상인 사원
Select *
From employees
Where department_id = 90 And salary >= 20000;

-- Between
-- 입사일이 07/01/01 ~ 07/12/31 구간에 포함된 사원
Select first_name, hire_date
From employees
Where hire_date Between '07/01/01' And '07/12/31';

-- In
-- 부서 id가 10, 20, 40인 사원의 명단
Select *
From employees
Where department_id In(10, 20, 40);

-- Manager Id가 100, 120, 147인 사원의 명단 (비교 + 논리 연산자)
Select *
From employees
Where manager_id = 100 Or
manager_id = 120 Or manager_id = 147;

-- In 연산자
Select *
From employees
Where manager_id In (100, 120, 147);

-- Like 검색
-- % = 임의의 길이의 지정되지 않은 문자열
-- _ = 한개의 임의의 문자
-- 이름에 am을 포함한 사원의 이름과 급여
Select first_name, salary
From employees
Where first_name Like '%am%';

-- 이름의 두번재 글자가 a인 사람의 이름과 급여
Select first_name, salary
From employees
Where first_name Like '_a%';

-- 이름의 4번째 글자가 a인 사원의 이름
Select first_name
From employees
Where first_name Like '___a%';

-- 이름이 4글자인 사원 중에서 끝에서 두번째 글자가 a인 사원의 이름
Select first_name
From employees
Where first_name Like '__a_';

-- Order By (ASC, DESC)
-- 부서 번호 오름차순으로 정렬 후 부서번호, 급여, 이름 출력
Select department_id, salary, first_name
From employees
Order by department_id;

-- 급여가 10000 이상인 직원의 이름을 급여 내림차순
Select first_name, salary
From employees
Where salary >= 10000 Order By salary DESC;

-- 부서번호 오름차순, 급여 내림차순, 이름
Select department_id, salary, first_name
From employees
Order By department_id, salary DESC;

-- practice 01
-- 01
Select first_name "이름", salary "월급", phone_number "전화번호", hire_date "입사일"
From employees
Order By hire_date;

-- 02
Select job_title, max_salary
From jobs
Order By max_salary DESC;

-- 03
Select first_name, manager_id, commission_pct, salary
From employees
Where (manager_id Is Not Null) And (commission_pct Is Null) And salary > 3000;

-- 04
Select job_title, max_salary
From jobs
Where max_salary >= 10000
Order by max_salary DESC;

-- 05
Select first_name, salary, NVL(commission_pct, 0)
From employees
Where salary Between 10000 And 14000;

-- 06 (날짜 변환 필요)
Select first_name, salary, hire_date, department_id
From employees
Where department_id In(10, 90, 100);

-- 07
Select first_name, salary
From employees
Where first_name Like '%s%' Or first_name Like '%S%';

-- 문자열 단일행 함수
Select first_name, last_name, 
    Concat(first_name, Concat(' ', last_name)), -- 결합
    Initcap(first_name || ' ' || last_name), -- 첫 글자는 대문자로
    Lower(first_name), -- 모두 소문자
    Upper(first_name), -- 모두 대문자
    LPAD(first_name, 20, '*'), -- 20자리 확보, 왼쪽을 *로 채움
    RPAD(first_name, 20, '*') -- 20자리 확보, 오른쪽을 *로 채움
From employees;

Select '            Oracle          ',
    '************Database**************'
From dual;

Select Ltrim('            Oracle          '), -- 왼쪽의 공백 제거
    Rtrim('            Oracle          '), -- 오른쪽의 공백 제거
    Trim('*' From  '************Database**************'), -- 양쪽의 지정된 문자 제거
    SUBSTR('Oracle Database', 8, 4), -- 8번째 글자부터 4글자 
    SUBSTR('Oracle Database', -8, 4) -- 뒤에서 8번째 글자부터 4글자
From dual;

-- 수치형 단일행 함수
SELECT ABS(-3.14), -- 절대값
    CEIL(3.14), -- 소숫점 올림
    FLOOR(3.14), -- 소숫점 버림
    MOD(7,3), -- 나머지
    POWER(2, 4), -- 제곱
    ROUND(3.5), -- 반올림
    ROUND(3.4567, 2), -- 소숫점 2째자리까지 반올림으로 변환
    TRUNC(3.5), -- 소숫점 아래 버림
    TRUNC(3.4567, 2) -- 소숫점 2째자리까지 버림
FROM dual;

------------------------
-- Date Format --
------------------------

-- 날짜 형식 확인
SELECT * FROM nls_session_parameters
Where parameter = 'NLS_DATE_FORMAT';

-- 현재 날짜와 시간
SELECT sysdate
FROM dual; -- dual 가상 테이블로부터 확인

SELECT sysdate
FROM employees; -- 테이블로부터 받아오므로 테이블 내 행 갯수만큼 반환

-- DATE 관련 함수
SELECT sysdate, -- 현재 날짜와 시간
    ADD_MONTHS(sysdate, 2), -- 2개월 후의 날짜
    MONTHS_BETWEEN('99/12/31',sysdate), -- 1999년 12월 31일 ~ 현재까지의 달 수
    NEXT_DAY(sysdate, 6), -- 현재 날짜 이후의 첫 번째 금요일(6)
    ROUND(TO_DATE('2021-05-17', 'YYYY-MM-DD'), 'MONTH'), -- MONTH 정보로 반올림
    TRUNC(TO_DATE('2021-05-17', 'YYYY-MM-DD'), 'MONTH') -- MONTH 정보로 버림
FROM dual;

-- 현재 날짜 기준, 입사한지 몇 개월이 지났는가?
SELECT first_name, hire_date, ROUND(MONTHS_BETWEEN(sysdate, hire_date))
FROM employees;
