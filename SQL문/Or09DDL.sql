/***************************************************
파일명 : Or09DDL.sql
DDL : Data Definition Language(데이터 정의어)
설명 : 테이블, 뷰와 같은 객체를 생성 및 변경하는 쿼리문을 말한다.

****************************************************/
--system 계정

/*
system계정으로 연결한 후 아래 명령을 실행한다.
새로운 사용자 계정을 생성한 후 접속권한과 테이블 생성권한등을 부여한다.
*/
-- oracle21c 이상부터는 계정생성 전 해당명령을 실행해야한다.
alter session set "_ORACLE_SCRIPT" = true;
-- study 계정을 생성하고, 패스워드를 1234를 부여한다.
create user study identified by 1234;
-- 생성한 계정에 몇가지 권한을 부여한다.
grant connect, resource to study;

---------------------------------------------------------------------
--study 계정을 연결한 후 실습을 진행합니다.
select * from dual;

--해당 계정에 생성된 테이블의 목록을 저장한 시스템 테이블
--이와 같은 테이블을 "데이터사전"이라고 한다.
select * from tab;

/*
    테이블 생성하기
        형식] create table 테이블명( 
                컬럼명1 자료형,
                컬럼명2 자료형,
                ... 
                primary kit(컬럼명) 등의 제약조건추가);
*/
create table tb_member(
    idx number(10), --10자리의 정수를 표현
    userid varchar2(30), -- 문자형으로 30byte 저장가능
    passwd varchar2(50), 
    username varchar2(30),
    mileage number(7,2) -- 앞에숫자는 자리수, 뒷자리숫자는 소수점 몇번째자리. 
   );                   -- 실수표현, 전체 7자리, 소수이하 2자리 표현

--현재 접속한 계정에 생성된 테이블 목록을 확인합니다.
select * from tab;

-- 테이블의 구조(스키마) 확인. 컬럼명, 자료형 ,크기 등을 확인한다.
desc tb_member;

/*
기존 생성된 테이블에 새로운 컬럼 추가하기
    -> tb_member 테이블에 email 컬럼을 추가하시오.
  형식] alter table 테이블명 add 추가할 컬럼 자료형(크기) 제약조건;
*/
alter table tb_member add email varchar2(100);
desc tb_member;

/*
기존 생성된 테이블의 컬럼 수정하기 
    -> tb_member 테이블의 email 컬럼의 사이즈를 200으로 확장하시오.
    또한 이름이 저장되는 username컬럼도 60으로 확장하시오.
 
  형식] alter table 테이블명 modify 수정할 컬럼명 자료형(크기);
*/
alter table tb_member modify email varchar2(200);
alter table tb_member modify username varchar2(60);
desc tb_member;

/*
기존 생성된 테이블에서 컬럼을 삭제하기.
    -> tb_member 테이블의 mileage 컬럼을 삭제하시오.

 형식] alter talbe 테이블명 drop column 삭제할 컬럼명;
*/
alter table tb_member drop column mileage;
desc tb_member;

/*
퀴즈] 테이블 정의서로 작성한 employees 테이블을 해당 study 계정에 그대로 
     생성하시오. 단, 제약조건을 명시하지 않습니다.
*/

create table employees (
    employee_id number(6),
    first_name varchar2(20),
    last_name varchar2(25),
    email varchar2(25),
    phone_number varchar2(20),
    hire_date date,
    job_id varchar2(10),
    salary number(8,2),
    commission_pct number(2,2),
    manager_id number(6),
    department_id number(4)
);

desc employees;

/*
테이블 삭제하기
        -> employees 테이블은 더 이상 사용하지 않으므로 삭제하시오.
    형식] drop table 삭제할 테이블명;
*/
select * from tab;
-- 테이블 삭제
drop table employees;
-- 삭제 후 테이블 목록에서는 보이지 않는다. 휴지통에 들어간 상태.
select * from tab;
-- 객체가 존재하지 않는다는 오류가 발생한다.
desc employees;

/*
tb_member 테이블에 새로운 레코드를 삽입한다.(DML 부분에서 학습할 예정)
하지만 테이블 스페이스라는 권한이 없어 삽입할 수 없는 상태이다.
*/

insert into tb_member values
    (1, 'hong', '1234', '홍길동', 'hong@naver.com');

/*
오라클 11g에서는 새로운 계정을 생성한 후 connect, resource를 (Roule)만
부여하면 테이블 생성 및 삽입까지 되지만, 그 이후 버전에서는 테이블 스페이스 관련
오류가 발생한다. 따라서 아래와 같이 테이블 스페이스에 대한 권한도 부여해야한다.
해당 명령은 system 계정으로 접속한 후 실행해야 한다.
*/
------------system 계정-----------------------

grant unlimited tablespace to study;

--다시 study 계정으로 접속한 후 레코드에 접속한다.
insert into tb_member values
    (1, 'hong','1234','홍길동','hong@naver.com');
insert into tb_member values
    (2, 'yu','9867','유미','hong@hanmial.net');

--상입된 레코드를 확인한다.
select * from tb_member;

/*
    select문으로 기술할 때 where절이 없으면 모든 레코드를 출력하라는 명령이므로
    아래에서는 모든 레코드를 가져와서 복사본 테이블을 생성한다.
    즉, 레코드까지 복사된다.
*/

create table tb_member_copy
    as
    select * from tb_member;
desc tb_member_copy;
select * from tb_member_copy;

--테이블 복사하기2: 레코드는 제외하고 테이블 구조만 복사
create table tb_member_empty
    as
    select * from tb_member where 1=0;
desc tb_member_empty;

/*
DDL문 : 테이블을 생성 및 조작하는 쿼리문이다.
(Data Definition Language) 
     테이블 생성: create table 테이블명
     테이블 수정
        컬럼 추가: alter table 테이블명 add 컬럼명
        컬럼 수정: alter table 테이블명 modify 컬럼명
        컬럼 삭제: alter table 테이블명 drop colummn 컬럼명
     테이블 삭제: drop table 테이블명
*/

---------------------------study계정------------------------

/*







