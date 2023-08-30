/***************
파일명 :  Or07Date.sql
날짜함수
설명 : 년, 월, 일, 시, 분, 초의 포멧으로 날짜형식을 지정하거나
    날짜를 계산할때 활용하는 함수들
****************/
-- hr 계정

/*
months_between() : 현재날짜와 기준날짜 사이의 개월수를 반환한다.
    형식] months_between(현재날짜, 기준날짜[과거날짜]);
*/
-- 2020년 1월 1일부터 지금까지 지난 개월수는??
select
    months_between(sysdate, '2020-01-01') "기본날짜 서식",
    months_between(sysdate, 
        to_date('2020년01월10일', 'yyyy"년"mm"월"dd"일"')) "to_date사용",
    ceil(months_between(sysdate, 
        to_date('2020년01월10일', 'yyyy"년"mm"월"dd"일"'))) "소수점올림처리",
    add_months(sysdate, 4)
 from dual;

/*
퀴즈] employees 테이블에 입력된 직원들의 근속개월수를 계산하여 출력하시오
    단, 근속개월수의 오름차순으로 정렬하시오.
*/
select
    first_name, hire_date,
    months_between(sysdate, hire_date) "근속개월수1",
    trunc(months_between(sysdate, hire_date)) "근속개월수2"
 from employees
  order by "근속개월수2" asc;
-- order by trunc(months_between(sysdate, hire_date)) asc;
/*
select 결과를 정렬하기 위해 order by를 사용할때 컬러명은 위와같이
2가지 형태로 사용할 수 있다.
방법1 : 계산식이 포함된 컬럼을그대로 사용한다.
방법2 : 별칭을 사용한다.
*/

/*
next_day() : 현재날"짜를 기준으로 인자로 주어진 요일에 해당하는
    미래의 날짜를 반환하는 함수
    형식] next_day(현재날짜, '월요일')
        => 다음주 월용일은 몇일일까요?
*/
select
    to_char(sysdate, 'yyyy-mm-dd') "오늘날짜",
    next_day(sysdate, '월요일') "다음월요일",
    to_char(next_day(sysdate, '월요일'), 'yyyy-mm-dd') "날짜 서식지정"
 from dual;

/*
last_day() : 해당월의 마지막 날짜를 반환한다.
*/
select last_day('22-04-03') from dual; -- 22년 4월의 마지막은 30일
select last_day('22-02-03') from dual; -- 28일 출력
select last_day('20-02-03') from dual; -- 2020년은 운년이므로 29일 출력됨

-- 컬럼이 date타입인 경우 간단한 날자 연산이 가능하다.
select
    sysdate "오늘",
    sysdate+1 "내일",
    sysdate-1 "어제",
    sysdate+15 "보름후"
 from dual;

