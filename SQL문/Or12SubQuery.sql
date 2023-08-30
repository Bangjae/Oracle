/*************************************************
파일명 : Or12SubQuery.sql
 서브쿼리
설명 : 쿼리문 안에 또 다른 쿼리문이 들어가는 형태의 select문
    where구에 select문이 온다.
**************************************************/

-- HR계정에서 진행합니다.


/*
단일행 서브쿼리
    단 하나의 행만 반환하는 서브쿼리로 비교연산자(=,<,<=,>,>=,<>)를 사용한다
    
    형식] 
        select * from 테이블명 where 컬럼 =(
            select 컬럼 from 테이블명 where 조건
            );
*/
/*
시나리오] 사원테이블에서 전체사원의 평균급여보다 낮은 급여를 받는 사원들을
    추출하여 출력하시오.
    출력항목 : 사원번호, 이름, 이메일, 연락처, 급여    
*/
--1. 평균급여구하기 : 6462
select avg(salary) from employees;
--2. 해당 쿼리문은 문맥상 맞는 듯하지만 그룹함수를 단일행에 적용한 잘못된 쿼리문.
select * from employees where salary<avg(salary); --에러발생

--3. 앞에서 구한 평균 급여를 조건으로 select문을 작성하시오.
select * from employees where salary<6462;
--4. 2개의 쿼리문을 하나의 서브쿼리문으로 합쳐서 결과를 확인한다.
select employee_id, first_name, email, phone_number, salary
    from employees where salary<(
    select avg(salary) from employees)
    --위 문장은 결과가 1개만 나와서 단일행
    order by salary;
    
/*
 퀴즈] 전체 사원 중 급여가 가장작은 사원의 이름과 급여를 출력하는 서브쿼리문을
    작성하시오.
    출력항목 : 이름1,이름2,이메일,급여
*/
-- 1단계 : 최소급여를 확인한다.
select min(salary) from employees;
-- 2단계 : 2100을 받는 직원의 정보를 인출한다.
select * from employees where salary=2100;
-- 3단계 : 2개의 쿼리문을 하나로 합쳐서 서브쿼리를 만든다.
select * from employees where salary=(
    select min(salary) from employees
);

/*
시나리오] 평균급여가 많은 급여를 받는 사원들의 명단을 조회할 수 있는 서브쿼리문을 
    작성하시오.
    출력내용: 이름1, 이름2, 담당업무명, 급여
    * 담당업무명은 jobs 테이블에 있으므로 join해야한다.
*/

--1단계 : 평균급여 환산하기
select round(avg(salary)) from employees;
--2단계 : 테이블을 조인한다.
select 
    first_name, last_name, job_title, salary
 from employees inner join jobs using(job_id)
 where salary>(select round(avg(salary)) from employees);
 
/*
복수형 서브쿼리 : 다중행 서브쿼리라고도 하고 여러개의 행을 반환하는 것으로
    in, any,all,exits를 사용해야한다. 
    형식] select * from 테이블명 where 컬럼 in(
        select 컬럼 from 테이블명 where 조건);
        *괄호안의 서브쿼리는 2개이상의 결과를 인출해야한다.
*/

/*
시나리오] 담당업무별로 가장 높은 급여를 받는 사원의 명단을 조회하시오.
    출력목록: 사원아이디, 이름, 담당업무아이디, 급여
*/
-- 1단계 : 담당업무별 가장 높은 급여를 확인한다.
select job_id, max(salary) from employees group by job_id;
-- 2단계 : 위의 결과를 단순한 or 조건으로 묶어본다.
-- 19개의 결과가 인출되지만 4갲어도만 기술해본다.
select * from employees
    where
        (job_id='SH_CLERK' and salary=4200) or
        (job_id='AD_ASST' and salary=4400) or
        (job_id='MK_MAN' and salary=1300) or
        (job_id='MK_REP' and salary=600);

-- 3단계 : 복수형 연산자를 통해 서브쿼리로 병합한다.
select employee_id, first_name, job_id, salary
    from employees where 
    (job_id, salary) in (select job_id, max(salary) 
    from employees group by job_id) order by salary;
    
/*
복수행 연산자 : any(어떤것이라도)의 개념은 or과 비슷하다.
    메인쿼리의 비교조건이 서브쿼리의 검색결과와 하나이상 일치하면
    참이되는 연산자.  즉 , 둘 중 하나만 만족하면 해당레코드를 인출한다.
*/
/*
시나리오] 전체 사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를 받는
    직원들을 인출하는 서브쿼리문을 작성하시오.
        단, 둘 중 하나만 만족하더라도 인출하시오.
*/
--1단계 : 20부서부터 급열르 확인한다.
select first_name, salary from employees where department_id=20;
--2단계 : 1번의 결과를 단순한 or절로 작성해본다.
select first_name, salary from employees where salary>13000 or salary>6000;
--3단계 : 둘중하나만 만족하면 되므로 복수행 연산자 any를 이용해서
--서브쿼리를 만들면된다. 즉 6000보다크고 또는 13000보다 큰 조건으로 생성된다.
select first_name, salary from employees 
where salary>any(
    select salary from employees where department_id=20);
    
/*
결과적으로 600보다 크면 조건에 만족한다 결과:55명
*/

/*
복수행연산자 3: all은 and의 개념과 유사하다.
메인쿼리의 비교조건이 서브쿼리의 검색결과와 모두 값이 일치해야 레코드를 인출한다.
*/

/*
시나리오] 전체 사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를 받는
    직원들을 인출하는 서브쿼리문을 작성하시오. 단, 둘다 만족하는 레코드만 인출하시오.
*/
select first_name, salary from employees 
where salary>all(
    select salary from employees where department_id=20);

/*
 6000이상이고 동시에 13000이상보다 커야하므로 결과적으로 13000이상인 레코드만 인출
*/

/*
rownum : 테이블에서 레코드를 조회한 순서대로 순번이 부여되는 가상의 컬럼을 말한다.
    해당컬럼은 모든 테이블에 논리적으로 존재한다.
*/
--모든 계정에 논리적으로 존재하는 테이블
select * from dual;
--레코드의 정렬없이 모든 레코드를 가져와서 rownum으로 부여한다.
-- 이경우 rownum은 순서대로 출력한다.
select employee_id, first_name, rownum from employees;
-- 이름의 오름차순으로 정렬하면 rownum이 섞여서 이상하게 나온다.
select employee_id, first_name, rownum from employees
    order by first_name asc;

/*
rownum을 우리가 정렬한 순서대로 재부여하기위해 서브쿼리를 사용한다.
from절에는 테이블이 들어와야하는데, 아래의 서브쿼리에서는 사원테이블의 
전체 레코드를 대상으로 하되 이름의 오름차순으로 정렬된 상태로 
레코드를 가져와서 테이블처럼 사용한다.
*/
select first_name, rownum from(select * from employees 
    order by first_name asc);







































