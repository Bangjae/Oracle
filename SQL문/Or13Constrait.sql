/********************************
파일명 : Or12Constraint.sql

제약조건

설명 : 테이블 생성 시 필요한 여러가지 제약조건에 대해 학습한다.
***************************************/

--study 계정에서 진행합니다.

/*
primary key : 기본키
    -참조 무결성을 유지하기 위한 제약조건
    -하나의 테이블에 하나의 기본키만 설정할 수 있다.
    -기본키로 설정된 컬럼은 중복된 값이나, Null값을 입력할 수 없다.
*/

/*
형식1] 인라인 방식 :컬럼 생성 시 우측에 제약조건을 기술한다.
    create table 테이블명(
        컬럼명 자료형(크기) [constraint 제약명] primary key
        );
*/

create table tb_primary1 (
    idx number(10) primary key,
    user_id varchar2(30),
    user_name varchar2(50));

/*
제약 조건 및 테이블 목록 확인하기 
    tap : 현재 계정에 생성된 테이블의 목록을 확인할 수 있다.
    user_cons_columns : 테이블에 지정된 제약조건과 컬럼명의 간략한 정보를 저장
    user_constaints : 테이블에 지정된 제약조건의 보다 상세한 정보를 저장
    *이와같이 제약조건이나 뷰, 프로시저등의 정보를 저장하고 있는 시스템테이블을
    "데이터 사전"이라고한다.
*/
select * from tab; 
select * from user_cons_columns;
select * from user_constraints;

--레코드 입력
insert into tb_primary1 (idx, user_id, user_name)
    values(1, 'hapjung1', '합정');
insert into tb_primary1 (idx, user_id, user_name)
    values(2, 'seoulit1', '학원');

insert into tb_primary1 (idx, user_id, user_name)
    values(2, 'seoulit2', '오류발생');
/*
    무결성 제약조건 위배로 에러가 발생한다. PK로 지정된 컬럼 idx에는
    중복된 값을 입력할 수 없다.
*/
insert into tb_primary1 values(3, 'white', '화이트');
insert into tb_primary1 values('', 'black', '블랙'); --에러
--pk로 지정된 컬럼에는 null값을 입력할 수 없다. 
select * from tb_primary1;

update tb_primary1 set idx=2 where user_name='유산슬';
/*
    update문은 정상이지만 idx값이 이미 존재하는 2로 변경했으므로 
    제약 조건 위배로 오류가 발생한다. 
*/

/*
형식2] 아웃라인 방식 
    create table 테이블명(
        컬럼명 자료형(크기)
        [constraint 제약명] primary key(컬럼명));
*/

create table tb_primary2 (
    idx number(10),
    user_id varchar2(30),
    user_name varchar2(50),
    constraint my_pk1 primary key(user_id));
    
desc tb_primary2;
select * from user_cons_columns;
select * from user_constraints;

insert into tb_primary2 values(1, 'white', '화이트1');
insert into tb_primary2 values(2, 'white', '화이트2');

select * from tb_primary2;

/*
형식3] 테이블을 생성할 수 alter문으로 제약조건 추가 
    alter table 테이블명 add


*/
create table tb_primary3 (
    idx number(10),
    user_id varchar2(30),
    user_name varchar2(50)
    );
    
desc tb_primary3;
/*
    테이블을 생성한 후 alter 명령을 통해 제약조건을 부여할 수 있다.
    제약명의 경우 생략이 가능하다.
*/
alter table tb_primary3 add constraint tb_primary3_pk
    primary key(user_name);
--데이터 사전에서 제약조건 확인하기.
select * from user_constraints;
--제약조건은 테이블을 대상으로 하므로, 테이블이 삭제되면 같이 삭제된다.
drop table tb_primary3;
--확인 시 휴지통에 들어온 것을 확인할 수 있다.
select * from user_cons_columns;
purge recyclebin;

--pk는 테이블당 하나만 생성할 수 있다. 따라서 해당 문장은 에러가 발생한다.

create table tb_primary4 (
    idx number(10) primary key,
    user_id varchar2(30) pirmary key,
    user_name varchar2(50)
    );
    
/*
unique : 유니크
    -값의 중복을 허용하지 않는 제약조건으로 숫자,문자는 중복을 허용하지 않는다
    하지만 null값에 대해서는 중복을 허용한다. unique는 한 테이블에 2개 이상
    적용할 수 있다.
*/

create table tb_unique (
    -- idx컬럼은 단독으로 unique가 지정된다.
    idx number unique not null,
    name varchar2(30),
    telephone varchar2(20),
    nickname varchar2(30),
    /*
        2개의 컬럼을 합쳐서 지정한다. 이 경우 동일한 제약조건으로 
        unique가 지정된다.
    */
    unique(telephone, nickname)
    );
    
insert into tb_unique (idx, name, telephone, nickname)
    values(1, '아이린', '010-1111-1111', '레드벨벳');
insert into tb_unique (idx, name, telephone, nickname)
    values(2, '웬디', '010-2222-2222', '');
insert into tb_unique (idx, name, telephone, nickname)
    values(3, '슬기', '', '');
    
select * from tb_unique;
insert into tb_unique (idx, name, telephone, nickname)
    values(1, '예린', '010-3333-3333', ''); --1중복저장이안되서 에러;


insert into tb_unique values(4, '정우성', '010-4444-4444', '영화배우');
insert into tb_unique values(5, '이정재', '010-6666-5555', '영화배우');--입력
insert into tb_unique values(6, '황정민', '010-4444-4444', '영화배우');--오류

/*
 telephone과 nickname은 동일한 제약명으로 설정되었으므로 두 개의 컬럼이
 동시에 동일한 값을 가지는 경우가 아니라면 중복된 값이 허용된다.
 즉 4번과 5번은 서로 다른 데이터로 인식하므로 입력되고, 4번과 6번은 동일한 데이터로
 인식되어 에러가 발생한다.
*/
select * from user_cons_columns;


/*
Foreign key: 외래키, 참조키
    -외래키는 참조 무결성을 유지하기 위한 제약조건으로 
    만약 테이블 간의 외래키가 설정되어 있다면 자식테이블에 참조값이 존재할 경우
    부모테이블의 레코드는 삭제할 수 없다.
    
    형식1] 인라인 방식
        create table 테이블명(
        컬럼명 자료형 [constrsiraint 제약명]
            references 부모테이블명 (참조할 컬럼명)
            );
*/

create table tb_foreign1 (
    f_idx number(10) primary key,
    f_name varchar2(50),
    /*
        자식테이블인 tb_foreign1에서 부모테이블인 tb_primary1의 user_id컬럼을 
        참조하는 외래키를 생성한다.
    */
    f_id varchar2(30) constraint tb_foreign_fk1
        references tb_primary2(user_id)
        );


--부모테이블에는 1개의 레코드 삽입되어있음.
select * from tb_primary2;
--자식테이블에는 레코드가 없는 상태임.
select * from tb_foreign1;
--오류발생 부모테이블에는 gildong이라는 아이디가 없음.
insert into tb_foreign1 values(1, '홍길동', 'gildong');
-- 입력 성공, 부모테이블에 white라는 아이디가 있음.
insert into tb_foreign1 values(2, '하얀색', 'white');
/*
    자식테이블에서 참조하는 레코드가 있으므로, 부모테이블의 레코드를 삭제할 수 없다.
    이 경우 반드시 자식 테이블의 레코드를 먼저 삭제한 후 부모테이블의 레코드를
    삭제해야 한다.
*/

delete from tb_primary2 where user_id='white';
--자식 테이블의 레코드를 먼저 삭제한 후.....
delete from tb_foreign1 where f_id='white';
--부모 테이블의 레코드를 삭제하면 정상처리된다.
delete from tb_primary2 where user_id='white';

--모든 레코드가 삭제된 상태이다.
select * from tb_foreign1;
select * from tb_primary2;

/*
    2개의 테이블이 외래키(참조키)가 설정되어 있는 경우
    부모테이블의 참조할 레코드가 없으면 자식테이블에 insert할 수 없다.
    자식테이블의 부모를 참조하는 레코드가 남아있으면 부모테이블의 
    레코드를 delete할 수 없습니다.
*/

/*
형식2] 아웃라인방식
    create table 테이블명(
        컬럼명 자료형,
        [constraint 제약명] foreign key(컬럼명)
            references 부모테이블 (참조할 컬럼) 
            );
*/

create table tb_foreign2 (
    f_id number primary key,
    f_name varchar2(30),
    f_date date,
    foreign key(f_id) references tb_primary1(idx)
    );
 select * from user_cons_columns;
 /*
    데이터 사전에서 제약조건 확인 시의 플래그
   p:primary key 
   r:reference integrity 즉 foreign key를 뜻한다.
   c:check 혹은 not null
   u : unique
 
 */
 
 /*
 형식3] 테이블 생성 후 alter문으로 외래키 제약조건 추가
    alter table 테이블명 add[constraint 제약명]
        foreign key (컬럼명)
            references 부모테이블 (참조컬럼명)
 */

create table tb_foreign3 (
    idx number primary key,
    f_name varchar2(30),
    f_idx number(10)
    );
    
alter table tb_foreign3 add
    foreign key(f_idx) references tb_primary1(idx);
 select * from user_cons_columns;

/*
    하나의 부모테이블에 둘 이상의 자식테이블이 외래키를 설정 할 수 있다.
*/

/*
외래키 삭제 옵션
    [on delete cascade]
        : 부모 레코드 삭제 시 자식레코드까지 같이 삭제된다.
     형식] 
        컬럼명 자료형 references 부모테이블 (pk컬럼)
            on delete cascade;
    [on delete set null]
        : 부모레코드 삭제 시 자식레코드 값이 null로 변경된다.

*실무에서 스팸게시물을 남긴 회원과 그 게시글을 일괄적으로 삭제해야할 때
    사용할 수 있는 옵션이다. 단, 

*/

create table tb_primary4 (
    user_id varchar2(30) primary key,
    user_name varchar2(100)
    );
create table tb_foreign4 (
    f_idx number(10) primary key,
    f_name varchar2(30),
    user_id varchar2(30) constraint tb_foreign4_fk
        references tb_primary4 (user_id)
            on delete cascade
    );

insert into tb_primary4 values ( 'student' ,'훈련생1');
insert into tb_foreign4 values (1, '스팸1입니다.' ,'student');
insert into tb_foreign4 values (2, '스팸2입니다.' ,'student');
insert into tb_foreign4 values (3, '스팸3입니다.' ,'student');
insert into tb_foreign4 values (4, '스팸4입니다.' ,'student');
insert into tb_foreign4 values (5, '스팸5입니다.' ,'student');
insert into tb_foreign4 values (6, '스팸6입니다.' ,'student');
insert into tb_foreign4 values (7, '스팸7입니다.' ,'student');

insert into tb_foreign4 values (8, '난??누구??' ,'teacher');

select * from tb_primary4;
select * from tb_foreign4;

/*
부모테이블에서 레코드를 삭제할 경우 on delete cacade 옵션에 의해
 자식쪽까지 모든 레코드가 삭제됨.만약 해당 옵션을 주지 않은 상태로 
 외래키를 생성했다면, 레코드는 삭제되지 않고 오류가 발생하게된다.
*/
delete from tb_primary4 where user_id='student';

----------------------------------------------------------
create table tb_primary5 (
    user_id varchar2(30) primary key,
    user_name varchar2(100)
    );
create table tb_foreign5 (
    f_idx number(10) primary key,
    f_name varchar2(30),
    user_id varchar2(30) constraint tb_foreign5_fk
        references tb_primary5 (user_id)
            on delete set null
    );
    
insert into tb_primary5 values ( 'student' ,'훈련생1');
insert into tb_foreign5 values (1, '스팸1입니다.' ,'student');
insert into tb_foreign5 values (2, '스팸2입니다.' ,'student');
insert into tb_foreign5 values (3, '스팸3입니다.' ,'student');
insert into tb_foreign5 values (4, '스팸4입니다.' ,'student');
insert into tb_foreign5values (5, '스팸5입니다.' ,'student');
insert into tb_foreign5 values (6, '스팸6입니다.' ,'student');
insert into tb_foreign5 values (7, '스팸7입니다.' ,'student');

select * from tb_primary5;
select * from tb_foreign5;

/*
    on delete set null 옵션으로 자식테이블의 레코드는 삭제되지않고, 
    참조키 부분만 null값으로 변경된다.
    따라서 더이상 참조할 수 없는 레코드로 변경된다.
*/
delete from tb_primary5 where user_id='student';

--부모테이블의 레코드는 삭제된다.
select * from tb_primary5;
--자식테이블의 레코드는 남아있다. 단, 참조컬럼이 null로 변경된다.
select * from tb_foreign5;

/*
not null : null 값을 허용하지 않는 제약조건
    형식] 
    create table 테이블명(
        컬럼명 자료형 not null,
        컬럼명 자료형 null <- null을 허용한다는 의미로 작성했지만
                            이렇게 사용하지 않는다. null을 기술하지 않으면
                            자동으로 허용한다는 의미가 된다.
        );

*/

create table tb_not_null (
    m_idx number(10) primary key, --pk이므로 nn
    m_id varchar2(20) not null, --nn
    m_pw varchar2(30) null, --null 허용 (일반적으로 이렇게 사용안함)
    m_name varchar2(40) -- null 허용 (이와같이 사용)
    );

desc tb_not_null;
-- 10~30까지는 정상적으로 입력된다.
insert into tb_not_null values(10, 'hong1', '1111', '홍길동');
insert into tb_not_null values(20, 'hong2', '2222', '');
insert into tb_not_null values(30, 'hong1', '', '');
-- m_id는 no null으로 지정되었으므로 null값을 삽입할 수 없어 오류가 발생.
insert into tb_not_null values(40, '', '', ''); --에러 2번째는 not null이라서.
-- 입력성공 공백(space도 문자이므로 입력된다.
insert into tb_not_null values(50, ' ', '5555', '오길동');

insert into tb_not_null (m_id,m_pw,m_name)
    values('hong6','6666','육길동');


/*
default : insert 시 아무런 값도 입력하지 않았을 때 자동으로 삽입되는 
        데이터를 지정할 수 있다.
*/
create table tb_default(
    id varchar2(30) not null,
    pw varchar2(50) default 'gwer'
   );

insert into tb_default values('aaaa','1234'); --1234 입력됨.
insert into tb_default values('bbbb'); -- 컬럼자체가 없으므로 
insert into tb_default values('cccc',''); --null값 입력
insert into tb_default values('dddd',' '); 
insert into tb_default values('eeee', default);

select * from tb_default;

/*
cheak : domain(자료형) 무결성을 유지하기 위한 계약조건으로 해당 컬럼에 
        잘못된 데이터가 입력되지 않도록 유지하는 제약조건이다.
*/
--M,F만 입력을 허용하는 check 제약조건
create table to_check1 (
        gender char(1) not null
        constraint check_gander
            check (gender in ('M','F'))
        );
    
insert into to_check1 values ('M');
insert into to_check1 values ('F');
-- 체크 제약조건 위배로 오류발생
insert into to_check1 values ('T');
-- 입력된 데이터가 컬럼조건보다 크므로 오류발생
insert into to_check1 values ('여성');


create table tb_check2 (
        sale_count number not null
            check (sale_count<=10)
        );
        
insert into tb_check2 values (9);       
insert into tb_check2 values (10);
--제약조건 위배로 입력실패
insert into tb_check2 values (11);       
