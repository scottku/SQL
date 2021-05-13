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
Select first_name, salary, TO_CHAR(hire_date,'YYYY-MM'), department_id
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

----------
-- 변환 함수
----------

-- TO_NUMBER(s, fmt) : 문자열 -> 수치형
-- TO_DATE(s, fmt) : 문자열 -> 날짜형
-- TO_CHAR(o, fmt) : 숫자, 날짜 -> 문자형

-- TO_CHAR
SELECT first_name, hire_date, TO_CHAR(hire_date,'YYYY-MM-DD HH24:MI:SS')
FROM employees;

-- 현재 날짜의 포맷
SELECT sysdate, TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS')
FROM dual;

SELECT TO_CHAR(123456789.0123, '999,999,999.99')
FROM dual;

-- 연봉 정보 문자열로 formating
SELECT first_name, TO_CHAR(salary*12, '$999,999.99') "SAL"
FROM employees;

-- TO_NUMBER : 문자열 -> 숫자
SELECT TO_NUMBER('1,999', '999,999'), TO_NUMBER('$1,350.99', '$999,999.99')
FROM dual;

-- TO_DATE : 문자열 -> 날짜
SELECT TO_DATE('2021-05-05 12:30', 'YYYY-MM-DD HH24:MI')
FROM dual;

-- Date 연산
-- Date +(-) Number : 날짜에 일 수 더하기(빼기) -> Date
-- Date - Date : 날짜에서 날짜를 뺀 일 수
-- Date + Number / 24 : 날짜에 시간을 더할 때 -> 시간을 24로 나눈 값을 더한다(뺀다)

SELECT TO_CHAR(sysdate, 'YY/MM/DD HH24:MI'),
    sysdate + 1, -- 1일 후
    sysdate - 1, -- 1일 전
    sysdate - TO_DATE('2012-09-24','YYYY-MM-DD'),
    TO_CHAR(sysdate + 13/24, 'YY/MM/DD HH24:MI') -- 13시간 후
FROM dual;

----------
-- NULL 관련 함수
----------

-- nvl 함수
SELECT first_name, salary, commission_pct, salary + (salary * nvl(commission_pct,0))
FROM employees;

-- nvl2 함수
-- nvl2 (표현식, null이 아닐때의 식, null일 때의 식)
SELECT first_name, salary, commission_pct, salary + nvl2(commission_pct, salary*commission_pct, 0)
FROM employees;

-- CASE 함수
-- 보너스를 지급
-- AD 관련 직원에게는 20%, SA 관련 직원에게는 10%, IT 관련 직원에게는 8%, 나머지는 5%
SELECT first_name, job_id, salary, SUBSTR(job_id, 1, 2),
    CASE SUBSTR(job_id, 1, 2) WHEN 'AD' THEN salary * 0.2
                            When 'SA' THEN salary * 0.1
                            When 'IT' THEN salary * 0.08
                            ELSE salary * 0.05
    END as bonus
From employees;

-- DECODE
SELECT first_name, job_id, salary, SUBSTR(job_id, 1, 2),
    DECODE(SUBSTR(job_id, 1, 2), --> 이 글자가
            'AD', salary * 0.2, --> 'AD' 이면 0.2배
            'SA', salary * 0.1, --> 'SA' 이면 0.1배
            'IT', salary * 0.08, --> 'IT' 이면 0.08배
            salary * 0.05) as bonus
FROM employees;

-- 부서 코드: 10~30 = A, 40~50 = B, 60~100 = C, 나머지 = Remainder
SELECT first_name, department_id,
    CASE WHEN department_id <= 30 THEN 'A-GROUP'
    WHEN department_id <= 50 THEN 'B-GROUP'
    WHEN department_id <= 100 THEN 'C-GROUP'
    ELSE 'REMAINDER'
    END as team
FROM employees
ORDER BY team;

-- 연습문제 01 (이어서)
-- 08
SELECT * 
FROM departments
ORDER BY length(department_name);

-- 09
SELECT UPPER(country_name)
FROM countries
ORDER BY country_name;

-- 10
SELECT first_name, salary, REPLACE(phone_number,'.','-'), hire_date
FROM employees
WHERE hire_date <= TO_DATE('03/12/31','YY/MM/DD');

