/********************************
파일명 : Or14Sequence&index.sql

시퀀스 & 인덱스
설명: 테이블의 기본키 필드에 순차적인 일련번호를 부여하는 시퀀스와
    검색속도를 향상시킬 수 있는 인덱스

***************************************/

--study 계정에서 진행합니다.

/*
시퀀스     
    -테이블의 컬럼(필드)에 중복되지 않는 순차적인 일련번호를 부여한다.
    -시퀀스는 테이블 생성 후 별도로 만들어야한다. 즉, 시퀀스는 테이블과 
    독립적으로 저장되고 생성된다.

[시퀀스 생성구문]
create sequence 시퀀스명
    [increment by N] -> 증가치 설정
    [Start with N] -> 시작값 지정
    [Minvalue n | NoMinvalue] -> 시퀀스 최소값 지정 : 디폴트1
    [Maxvalue n | NoMaxvalue] -> 시퀀스 최고값 지정 : 디폴트 1.0000E +28
    [Cycle | No Cycle] -> 최대/최소값에 도달할 경우 처음부터 다시 시작할 시 
                         여부를 결정(Cycle로 지정하면 최대값까지 증가 후  
                         다시 시작값부터 재시작됨.)
    [Cache | NoCache]  -> cache 메모리에 오라클 서버가 시퀀스 값을 할당하는
                          여부를 지정
                     
    주의사항
       1. start with에 minvalue보다 작은값을 지정할 수 없다.
       즉, start with에 값은 minvalue와 같거나 커야한다.
       2. nocycle로 설정하고 시퀀스를 계속 얻어올 때 maxvalue에 지정값을 초과하면
       에러가 발생한다.
       3. primary key에 cycle 옵션은 절대 지정하면 안된다.
*/

create table tb_goods(
    g_idx number(10) primary key,
    g_name varchar2(30));

insert into tb_goods values(1, '가나초콜렛');
insert into tb_goods values(1, '새우깡'); -- 입력실패 (제약조건위배)

--시퀀스 생성
create sequence seq_serial_num
    increment by 1  -- 증가치 : 1
    start with 100  -- 초기값 : 100
    minvalue 99     -- 최소값 : 99
    maxvalue 110    -- 최대값 : 110
    cycle           -- 최대값 도달 시 시작값부터 재시작할지 여부
    nocache;        -- 캐시메모리 사용 여부 : no
--데이터 사전에서 생성된 시퀀스 확인하기
select * from user_sequences;
 
/*
시퀀스 생성 후 최초 실행 시 오류가 발생한다. nestval을 먼저 실행한 후 
실행해야 문제없이 출력된다.
*/   
select seq_serial_num.currval from dual;

select seq_serial_num.nextval from dual;

insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기1');
insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기2');
insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기3');
insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기4');
insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기5');
insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기6');
insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기7');
insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기8');
insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기9');
insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기10');
insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기11');
insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기12');

select * from tb_goods;

/*
    시퀀스의 cycle 옵션에 의해 최대값에 도달하면 다시 처음부터 일련번호가
    생성되므로 무결성 제약조건에 위배된다.  즉, 기본키에 사용할 시퀀스는
    cycle 옵션을 사용하지 않아야한다.
*/

insert into tb_goods values (seq_serial_num.nextval, '꿀꽈배기13');

select * from tb_goods;
select seq_serial_num.currval from dual;

/*
시퀀스 수정
    : start with는 수정되지않는다.
*/
alter sequence seq_serial_num
    increment by 10
    minvalue 1
    nomaxvalue 
    nocycle
    nocache;
--수정 후 데이터사전에서 확인한다.
select * from user_sequences;
--증가치가 10으로 적용된 것을 확인한다.
select seq_serial_num.nextval from dual;

--시퀀스 삭제
drop sequence seq_serial_num;
select * from user_sequences;

--일반적인 시퀀스 생성은 아래와 같이 하면된다.
create sequence seq_serial_num
    start with 1
    increment  by 1
    minvalue 1
     nomaxvalue 
    nocycle
    nocache;

/*
인덱스 
    -행의 검색속도를 향상시킬 수 있는 객체 
    -인덱스는 명시적(create index)과 자동적(primary key,unique)
    으로 생성할 수 있다.
    -컬럼에 대한 인덱스가 없으면, 테이블 전체를 검색하게된다.
    -즉, 인덱스는 쿼리의 성능을 향상시키는 것이 목적이다.
    -인덱스는 아래와 같은 경우에 설정한다.
        1. where 조건이나 , join 조건에 자주 사용하는 컬럼
        2. 광범위한 값을 포함하는 컬럼
        3. 많은 null값을 포함하는 컬럼
*/

desc tb_goods;
select * from tb_goods;

--인덱스 생성하기. 특정 테이블의 컬럼을 지정하여 생성한다.
create index tb_goods_name_idx on tb_goods(g_name);
--생성한 인덱스 확인하기
/*
    데이터 사전에서 확인하면, PK혹은 unique로 지정된 컬럼은 자동으로 인덱스가
    생성되므로 이미 생성된 인덱스도 같이 확인된다.
*/
select * from user_ind_columns;

/*
특정 테이블의 인덱스 확인
    :데이터사전에 등록 시 대문자로 입력되므로 upper와 같은 변환함수를 사용하면
    편리하다.
*/

select * from user_ind_columns where table_name=upper('tb_goods');
-- 굉장히 많은 레코드가 있다고 가정했을 때 검색속도의 향상이 있다.
select * from tb_goods where g_name like '%꿀%';

--인덱스 삭제
drop index tb_goods_name_idx;

--인덱스 수정 : 수정은 불가능하다. 삭제 후 다시 생성해야한다.

