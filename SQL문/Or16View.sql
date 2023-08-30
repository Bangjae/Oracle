/********************************
파일명 : Or16View.sql

View(뷰)

설명 : View는 테이블로부터 생성된 가상의 테이블로 물리적으로는 존재하지않고
    논리적으로 존재하는 테이블이다.
***************************************/
--hr계정에서 진행합니다.

/*
뷰의 생성
형식] 
    create[or replace] view 뷰이름[(컬럼1,컬럼2,...)]
    as
    select * from 테이블명 where 조건
        혹은 join문도 가능함.
*/

/*
시나리오] hr계정의 사원테이블에서 담당업무가 ST_cLERK인 사원정보를
조회할 수 있는 VIEW를 생성하시오.
    출력항목 : 사원아이디, 이름, 직무아이디,입사일,부서아이디
*/

--1. 조건대로 select하기
select 
    employee_id, first_name, job_id, hire_date, department_id
    from employees
    where job_id='ST_CLERK'; --20개 인출

--2. 뷰 생성하기
create view view_employees
    as 
    select employee_id, first_name, job_id, hire_date, department_id
    from employees
    where job_id='ST_CLERK';
    
select * from view_employees;


/*
뷰 수정하기
    :뷰 생성문장에 or replace만 추가하면된다.
    해당 뷰를 존재하면 수정되고, 존재하지않으면 새롭게 생성된다.
    따라서 처음 뷰를 생성할 때부터 사용해도 무방하다.
*/

/*
시나리오]앞에서 생성한 뷰를 다음과 같이 수정하시오.
    기존컬럼인 employee_id, first_name, job_id, hire_date, department_id를
    id, fname,hdate,deptid로 수정하여 뷰를 생성하시오.
*/
create or replace view view_employees
    (id, fname, jobid, hdate, deptid)
    as 
    select employee_id, first_name, job_id, hire_date, department_id
    from employees
    where job_id='ST_CLERK';
    
select * from view_employees;

/*
퀴즈] 위에서 생성한 view_employees 뷰를 아래 조건에 맞게 수정하시오.
    직무아이디 ST_MAN인 사원의 사원번호, 이름, 이메일, 매니저아이디를 조회할 수 
    있도록 수정하시오.
    뷰의 컬럼명은 e_id, name, email, m_id로 지정한다. 단, 이름은
    first_name과 last_name이 연결된 형태로 출력하시오.
*/

--문제의 조건대로 select문 작성
select 
    employee_id, concat(first_name||' ', last_name), email, manager_id
    from employees where job_id='ST_MAN';
--뷰 생성시 컬럼의 별칭을 부여한다.
create or replace view view_employees (e_id, name,email,m_id)
    as 
    select
    employee_id, concat(first_name||' ', last_name), email, manager_id
    from employees where job_id='ST_MAN';

select * from view_employees;

/*
퀴즈] 사원번호,이름,연봉을 계산하여 출력하는 뷰를 생성하시오.
    컬럼의 이름은 emp_id, l_name, annul_sal로 지정하시오.
    연봉계산식은 -> (급여+급여+보너스율)*12
    뷰이름 : v_emp_salary
    단, 연봉은 세자리마다 컴마가 삽입되어야한다.
*/

select employee_id, last_name,
    rtrim(to_char((salary+(salary*nvl(commission_pct,0)))*12, '$999,000')) "연봉"
    from employees order by "연봉" asc;
    
create or replace view v_emp_salary (emp_id, l_name, annul_sal)
    as
select employee_id, last_name,
    rtrim(to_char((salary+(salary*nvl(commission_pct,0)))*12, '$999,000')) "연봉"
    from employees order by "연봉" asc;
    
select * from v_emp_salary;

/*
-조인을 통한 view 생성
시나리오] 사원테이블과 부서테이블, 지역테이블을 조인하여 다음조건에 맞는 뷰를
        생성하시오.
    출력항목 : 사원번호, 전체이름, 부서번호, 부서명, 입사일자, 지역명
    뷰의명칭 : v_emp_join
    뷰의컬럼 : empid, fullname, deptid,deptname,hdate, locname
    컬럼의 출력형태 :
        fullname => first_name + last_name
        hdate => 0000년00월00일
        locname => XXX주의 YYY
*/

--1.문제의 조건에 해당하는 select문 작성
select
    employee_id, first_name||' '||last_name, department_id, department_name,
    to_char(hire_date, 'yyyy"년" mm"월" dd"일"'),
    state_province||'주의 '||city as "지역"
    from employees
    inner join departments using(department_id)
    inner join locations using(location_id);
 
--2.view만들기
create or replace view v_emp_join
(empid, fullname, deptid,deptname,hdate, locname)
as
select
    employee_id, first_name||' '||last_name, department_id, department_name,
    to_char(hire_date, 'yyyy"년" mm"월" dd"일"'),
    state_province||'주의 '||city as "지역"
    from employees
    inner join departments using(department_id)
    inner join locations using(location_id);
--3. 복잡한 쿼리문을 view를 통해 간단히 조회할 수 있다.
select * from v_emp_join;