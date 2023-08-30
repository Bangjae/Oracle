/***************************************************************
파일명 : Or08GroupBy.sql
그룹 함수 (Group by)
설명: 전체 레코드(로우(행)(가로줄))에서 통계적인 결과를 구하기 위해 
    하나 이상의 레코드를 그룹으로 묶어서 연산 후 결과를 반환하는 함수 혹은 쿼리문
***************************************************************/
--hr계정

-- 사원테이블에서 담당업무 인출 :  총 107개가 인출됩니다.

select job_id from employees;

/*
distinct
    - 동일한 값이 있는 경우 중복된 레코드를 제거한 후 하나의 레코드만 보여준다.
    - 하나의 순수한 레코드이므로 통계적인 값을 계산할 수 있다.
 */
 
select distinct job_id from employees;

/*
group by
    - 동일한 값이 있는 레코드를 하나의 그룹으로 묶어서 가져온다.
    - 보여지는건 하나의 레코드지만, 다수의 레코드가 하나의 그룹으로 묶여진
    결과이므로 통계적인 값을 계산할 수 있다.
    - 최대, 최소, 평균, 합산 등의 연산이 가능하다.
*/
-- 각 담당업무별 직원수가 몇 명인지 카운트한다.
select job_id, count(*) from employees group by job_id; 

--검증을 위해 해당 업무를 통해 select 해서 인출되는 행의 개수와 비교해본다.
select first_name, job_id from employees where job_id='FI_ACCOUNT'; --5개 
select first_name, job_id from employees where job_id='ST_CLERK'; -- 20명

/*
group 절이 포함된 select 문의 형식
    Select
        컬럼1, 컬럼2, ...혹은 전체(*)
    from 
        테이블명
    where 
        조건1 and 조건2 or 조건3
    group by 
        레코드 그룹화를 위한 컬럼명
    having 
        그룹에서의 조건
    order by
        정렬을 위한 컬럼명과 정렬방식(asc 혹은 desc)
* 쿼리의 실행 순서
    from (테이블) -> where(조건) -> group by(그룹화) -> having(그룹조건)
    -> select(컬럼지정).> order by(정렬방식)    
*/

/*
sum() : 합계를 구할 때 사용하는 함수
    - Number 타입의 컬럼에서만 사용할 수 있다.
    - 필드명이 필요한 경우, as를 이용해서 별칭을 부여할 수 있다.
*/

--전체 직원의 급여의 합계를 출력하시오.
--where 절이 없으므로 전체 직원을 대상으로한다.
select 
    sum(salary) as "sumsalary1",
    to_char(sum(salary), '999,000') as "sumsalary2",
    ltrim(to_char(sum(salary), 'L999,000')) as "sumsalary3",
    ltrim(to_char(sum(salary), '$999,000')) as "sumsalary4"
    from employees;

--10번 부서에 근무하는 사원들의 급여의 합계는 얼마인지 출력하시오.

select 
    sum(salary) as "급여합계",
    to_char(sum(salary), '999,000') as "세자리 컴머",
    ltrim(to_char(sum(salary), 'L999,000')) as "좌측공백제거",
    ltrim(to_char(sum(salary), '$999,000')) as "통화기호삽입"
    from employees where department_id =10;
    
--sum()과 같은 그룹함수는 number타입인 컬럼에서만 사용할 수 있다.
select sum(first_name) from employees; --에러발생 number타입인 컬럼이 아니라서.!

/*
count() : 그룹화된 레코드의 개수를 카운트할 때 사용하는 함수.
*/
select count(*) from employees;
select count(employee_id) from employees;

/*
    count() 함수를 사용할 때는 위 2가지 방법 모두 가능하지만 *를 사용할 것을
    권장한다. 컬럼의 특성 혹은 데이터에 따른 방해를 받지 않으므로, 실행속도가
    빠르다.
*/

/*
count() 함수의 사용법
    사용법 1: count(all 컬럼명)
        => 디폴트 사용법으로 컬럼 전체의 레코드를 기준으로 카운트한다.
    사용법 2: count(distinct 컬럼명)
        => 중복을 제거한 상태에서 카운트한다.
*/

select
    count(job_id) "담당업무 전체개수1",
    count(all job_id) "담당업무 전체개수2",
    count(distinct job_id) "순수담당 업무개수"
 from employees;
 
 /*
 avg() : 평균값을 구할 때 사용하는 함수
 */
 
-- 전체 사원의 평균 급여는 얼마인지 출력하는 쿼리문을 작성하시오,
select 
    count(*) "전체사원수",
    sum(salary) "사원급여의 합",
    sum(salary) / count(*) "평균급여 (직접계산)",
    avg(salary) "평균급여(avg()함수)",
    trim(to_char(avg(salary), '$999,000')) "서식 및 공백제거"
 from employees;
 
 --영업팀(salse)의 평균급여는 얼마인가요?
 -- 1. 부서테이블에서 영업팀의 부서번호가 무엇인지 확인한다.
 /*
   정보검색 시 대소문자 혹은 공백이 포함된 경우 모든 레코드에 대해 
   문자열을 확인하는 것은 불가능하므로 일괄적인 규칙의 적용을 위해 
   upper()와 같은 변환함수를 사용하여 검색하는 것이 좋다.
 */ 
 select * from departments where department_name=initcap('sales');
 select * from departments where lower(department_name)='sales';
 select * from departments where upper(department_name)=upper('sales');
 
--부서번호가 80인 것을 확인한 후 다음 쿼리문을 작성한다.
select ltrim(to_char(avg(salary), '$999,000.00'))
 from employees where department_id=80;
 
 /*
 min(), max() 함수 : 최대값, 최소값을 찾을 때 사용하는 함수
 */
 
 --전체 사원 중 가장 낮은 급여는 얼마인가요?
 select min(salary) from employees;
 
 -- 전체 사원 중 급여가 가장 낮은 직원은 누구인가요?
 -- 아래 쿼리문은 에러발생 됨. 그룹함수는 일반컬럼에 사용할 수 없습니다.
select first_name, salary from employees where salary=min(salary); --에러


--사원테이블에서 가장 낮은 급여인 2100을 받는 사원을 인출한다.
 select first_name, salary from employees where salary= 2100;

 /*
    사원 중 가장 낮은 급여는 min()으로 구할 수 있으나 가장 낮은 급여를 받는 
    사람은 아래와 같이 서브쿼리를 통해 구할 수 있다.
    따라서, 문제에 따라 서브쿼리를 사용할 지 여부를 결정해야한다.
*/
select first_name, salary from employees where salary=
        (select min(salary) from employees);
    
/*
group by절 : 여러개의 레코드를 하나의 그룹으로 그룹화아여 묶여진 결과를 
    반환하는 쿼리문
    *distinct는 단순히 중복값을 제거함.
*/
-- 사원테이블에서 각 부서별 급여의 합계는 얼마인가요?
-- IT 부서의 급여 합계
select sum(salary) from employees where department_id=60;

--Finance부서의 급여 합계
select sum(salary) from employees where department_id=100;

/*
step1 : 부서가 많은 경우 일일이 부서별로 확인할 수 없으므로 부서를 그룹화한다.
        중복이 제거된 결과로 보이지만 동일한 레코드가 하나의 그룹으로 합쳐진 결과가
        인출된다.
*/
select department_id from employees group by department_id;

/*
step2 : 각 부서별로 급여의 합계를 구할 수 있다. 4자리가 넘어간느 경우 가독성이
    떨어지므로 서식을 이용해서 세자리마다 콤마를 표시한다.
*/
select department_id, sum(salary), trim(to_char(sum(salary), '999,000'))
    from employees group by department_id order by sum(salary) desc;
    
/*
퀴즈] 사원테이블에서 각 부서별 사원수와 평균급여는 얼마인지 출력하는 쿼리문을 
    작성하시오. 
    출력결과 : 부서번호, 급여총합, 사원총합, 평균급여
    출력 시 부서번호를 기준으로 오름차순을 정렬하시오.
*/
--혼자 풀었을 때 결과.
select * from employees;
select department_id "부서번호", sum(salary) "급여총합", count(*) "사원총합",
    trim(to_char(avg(salary),'999,000')) "평균급여" 
    from employees group by department_id order by department_id asc;

 -- 다같이 했을 때 결과.
 select department_id "부서번호", rtrim(to_char(sum(salary),'999,000')) "급여총합",
 count(*) "사원수", rtrim(to_char(avg(salary),'999,000')) "평균급여" 
    from employees group by department_id order by department_id asc;
    
/*
앞에서 사용했던 쿼리문을 아래와 같이 수정하면 에러가 발생한다.
group by절에서 사용한 컬럼은 select 절에서 사용할 수 있으나, 그 외의 단일 컬럼은
selcet 절에서 사용할 수 없다.
그룹화된 상태에서 특정레코드 하나만 선택하는 것은 애매하기 때문이다.
*/
select department_id, sum(salary), count(*), avg(salary), first_name
    from employees group by department_id; 
--쉽게 말해 그룹화 되지않은 first_name이 포함되어있기 때문에 에러, 

/*
시나리오] 부서아이디가 50인 사원들의 직원총합, 평균 급여, 급여총합이 얼마인지
    출력하는 쿼리문을 작성하시오.
*/
select 
    '50번부서', count(*), round(avg(salary)), sum(salary)
    from employees where department_id=50
    group by department_id;
    
/*
having 절 : 물리적으로 존재하는 컬럼이 아닌 그룹함수를 통해 논리적으로
    생성된 컬럼의 조건을 추가할 때 사용한다.
    해당 조건을 where절에 추가하면 에러가 발생한다
*/

/*
시나리오] 사원테이블에서 각 부서별로 근무하고 있는 직원의 담당업무별 사원수와
    평균급여가 얼마인지 출력하는 쿼리문을 작성하시오.
*/
/*
 같은 부서에 근무하더라도 담당업무는 다를 수 있으므로 이 문제에서는 
 group by절에 2개의 컬럼을 명시해야한다. 즉 부서로 그룹화 한 후, 
 다시 담당업무별로 그룹화한다.
*/
select department_id, job_id, count(*), avg(salary)
 from employees
 where count(*)>10 --여기서 에러발생
 group by department_id, job_id;
 
 /*
    담당업무 별 사원수는 물리적으로 존재하는 컬럼이 아니므로(함수로 계산한거라서 
    테이블 내에 해당 데이터가 없음) where절에 쓰면 에러가 발생한다.
    이런 경우에는 having절에 조건을 추가해야한다.
    ex) 급여가 3000인 사원 => 물리적으로 존재하므로 where절 사용
       평균급여가 3000인 사원=> 논리적으로 존재하므로 having절 사용
                                즉, 그룹함수를 통해 구할 수 있는 데이터임.
 */
 
 select department_id, job_id, count(*), avg(salary)
 from employees group by department_id, job_id
 having count(*)>10;
 
 /*
  퀴즈] 담당업무별 사원의 최저급여를 출력하시오.
  단, (관리자(manager)가 없는 사원과 최저급여가 3000미만인 그룹)은 제외시키고,
  결과가 급여의 내림차순으로 정렬하여 출력하시오.
 */
 select job_id, min(salary) from employees
 where manager_id is not null
 group by job_id
 having not min(salary)<3000 order by min(salary) desc;
 
 /*
    문제에서는 급여의 내림차순으로 정렬하라는 지시사항이 있으나,
    현재 select되는 항목이 급여의 최소값이므로 order by절에는 min(salary)를 
    사용해야한다.
 */
 
 
--3번문제

select * from employees;
select job_id, count(*) from employees
    group by job_id order by count (*);
    

 
 
 
 
 