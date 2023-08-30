/********************************
���ϸ� : Or12Constraint.sql

��������

���� : ���̺� ���� �� �ʿ��� �������� �������ǿ� ���� �н��Ѵ�.
***************************************/

--study �������� �����մϴ�.

/*
primary key : �⺻Ű
    -���� ���Ἲ�� �����ϱ� ���� ��������
    -�ϳ��� ���̺� �ϳ��� �⺻Ű�� ������ �� �ִ�.
    -�⺻Ű�� ������ �÷��� �ߺ��� ���̳�, Null���� �Է��� �� ����.
*/

/*
����1] �ζ��� ��� :�÷� ���� �� ������ ���������� ����Ѵ�.
    create table ���̺��(
        �÷��� �ڷ���(ũ��) [constraint �����] primary key
        );
*/

create table tb_primary1 (
    idx number(10) primary key,
    user_id varchar2(30),
    user_name varchar2(50));

/*
���� ���� �� ���̺� ��� Ȯ���ϱ� 
    tap : ���� ������ ������ ���̺��� ����� Ȯ���� �� �ִ�.
    user_cons_columns : ���̺� ������ �������ǰ� �÷����� ������ ������ ����
    user_constaints : ���̺� ������ ���������� ���� ���� ������ ����
    *�̿Ͱ��� ���������̳� ��, ���ν������� ������ �����ϰ� �ִ� �ý������̺���
    "������ ����"�̶���Ѵ�.
*/
select * from tab; 
select * from user_cons_columns;
select * from user_constraints;

--���ڵ� �Է�
insert into tb_primary1 (idx, user_id, user_name)
    values(1, 'hapjung1', '����');
insert into tb_primary1 (idx, user_id, user_name)
    values(2, 'seoulit1', '�п�');

insert into tb_primary1 (idx, user_id, user_name)
    values(2, 'seoulit2', '�����߻�');
/*
    ���Ἲ �������� ����� ������ �߻��Ѵ�. PK�� ������ �÷� idx����
    �ߺ��� ���� �Է��� �� ����.
*/
insert into tb_primary1 values(3, 'white', 'ȭ��Ʈ');
insert into tb_primary1 values('', 'black', '��'); --����
--pk�� ������ �÷����� null���� �Է��� �� ����. 
select * from tb_primary1;

update tb_primary1 set idx=2 where user_name='���꽽';
/*
    update���� ���������� idx���� �̹� �����ϴ� 2�� ���������Ƿ� 
    ���� ���� ����� ������ �߻��Ѵ�. 
*/

/*
����2] �ƿ����� ��� 
    create table ���̺��(
        �÷��� �ڷ���(ũ��)
        [constraint �����] primary key(�÷���));
*/

create table tb_primary2 (
    idx number(10),
    user_id varchar2(30),
    user_name varchar2(50),
    constraint my_pk1 primary key(user_id));
    
desc tb_primary2;
select * from user_cons_columns;
select * from user_constraints;

insert into tb_primary2 values(1, 'white', 'ȭ��Ʈ1');
insert into tb_primary2 values(2, 'white', 'ȭ��Ʈ2');

select * from tb_primary2;

/*
����3] ���̺��� ������ �� alter������ �������� �߰� 
    alter table ���̺�� add


*/
create table tb_primary3 (
    idx number(10),
    user_id varchar2(30),
    user_name varchar2(50)
    );
    
desc tb_primary3;
/*
    ���̺��� ������ �� alter ����� ���� ���������� �ο��� �� �ִ�.
    ������� ��� ������ �����ϴ�.
*/
alter table tb_primary3 add constraint tb_primary3_pk
    primary key(user_name);
--������ �������� �������� Ȯ���ϱ�.
select * from user_constraints;
--���������� ���̺��� ������� �ϹǷ�, ���̺��� �����Ǹ� ���� �����ȴ�.
drop table tb_primary3;
--Ȯ�� �� �����뿡 ���� ���� Ȯ���� �� �ִ�.
select * from user_cons_columns;
purge recyclebin;

--pk�� ���̺�� �ϳ��� ������ �� �ִ�. ���� �ش� ������ ������ �߻��Ѵ�.

create table tb_primary4 (
    idx number(10) primary key,
    user_id varchar2(30) pirmary key,
    user_name varchar2(50)
    );
    
/*
unique : ����ũ
    -���� �ߺ��� ������� �ʴ� ������������ ����,���ڴ� �ߺ��� ������� �ʴ´�
    ������ null���� ���ؼ��� �ߺ��� ����Ѵ�. unique�� �� ���̺� 2�� �̻�
    ������ �� �ִ�.
*/

create table tb_unique (
    -- idx�÷��� �ܵ����� unique�� �����ȴ�.
    idx number unique not null,
    name varchar2(30),
    telephone varchar2(20),
    nickname varchar2(30),
    /*
        2���� �÷��� ���ļ� �����Ѵ�. �� ��� ������ ������������ 
        unique�� �����ȴ�.
    */
    unique(telephone, nickname)
    );
    
insert into tb_unique (idx, name, telephone, nickname)
    values(1, '���̸�', '010-1111-1111', '���座��');
insert into tb_unique (idx, name, telephone, nickname)
    values(2, '����', '010-2222-2222', '');
insert into tb_unique (idx, name, telephone, nickname)
    values(3, '����', '', '');
    
select * from tb_unique;
insert into tb_unique (idx, name, telephone, nickname)
    values(1, '����', '010-3333-3333', ''); --1�ߺ������̾ȵǼ� ����;


insert into tb_unique values(4, '���켺', '010-4444-4444', '��ȭ���');
insert into tb_unique values(5, '������', '010-6666-5555', '��ȭ���');--�Է�
insert into tb_unique values(6, 'Ȳ����', '010-4444-4444', '��ȭ���');--����

/*
 telephone�� nickname�� ������ ��������� �����Ǿ����Ƿ� �� ���� �÷���
 ���ÿ� ������ ���� ������ ��찡 �ƴ϶�� �ߺ��� ���� ���ȴ�.
 �� 4���� 5���� ���� �ٸ� �����ͷ� �ν��ϹǷ� �Էµǰ�, 4���� 6���� ������ �����ͷ�
 �νĵǾ� ������ �߻��Ѵ�.
*/
select * from user_cons_columns;


/*
Foreign key: �ܷ�Ű, ����Ű
    -�ܷ�Ű�� ���� ���Ἲ�� �����ϱ� ���� ������������ 
    ���� ���̺� ���� �ܷ�Ű�� �����Ǿ� �ִٸ� �ڽ����̺� �������� ������ ���
    �θ����̺��� ���ڵ�� ������ �� ����.
    
    ����1] �ζ��� ���
        create table ���̺��(
        �÷��� �ڷ��� [constrsiraint �����]
            references �θ����̺�� (������ �÷���)
            );
*/

create table tb_foreign1 (
    f_idx number(10) primary key,
    f_name varchar2(50),
    /*
        �ڽ����̺��� tb_foreign1���� �θ����̺��� tb_primary1�� user_id�÷��� 
        �����ϴ� �ܷ�Ű�� �����Ѵ�.
    */
    f_id varchar2(30) constraint tb_foreign_fk1
        references tb_primary2(user_id)
        );


--�θ����̺��� 1���� ���ڵ� ���ԵǾ�����.
select * from tb_primary2;
--�ڽ����̺��� ���ڵ尡 ���� ������.
select * from tb_foreign1;
--�����߻� �θ����̺��� gildong�̶�� ���̵� ����.
insert into tb_foreign1 values(1, 'ȫ�浿', 'gildong');
-- �Է� ����, �θ����̺� white��� ���̵� ����.
insert into tb_foreign1 values(2, '�Ͼ��', 'white');
/*
    �ڽ����̺��� �����ϴ� ���ڵ尡 �����Ƿ�, �θ����̺��� ���ڵ带 ������ �� ����.
    �� ��� �ݵ�� �ڽ� ���̺��� ���ڵ带 ���� ������ �� �θ����̺��� ���ڵ带
    �����ؾ� �Ѵ�.
*/

delete from tb_primary2 where user_id='white';
--�ڽ� ���̺��� ���ڵ带 ���� ������ ��.....
delete from tb_foreign1 where f_id='white';
--�θ� ���̺��� ���ڵ带 �����ϸ� ����ó���ȴ�.
delete from tb_primary2 where user_id='white';

--��� ���ڵ尡 ������ �����̴�.
select * from tb_foreign1;
select * from tb_primary2;

/*
    2���� ���̺��� �ܷ�Ű(����Ű)�� �����Ǿ� �ִ� ���
    �θ����̺��� ������ ���ڵ尡 ������ �ڽ����̺� insert�� �� ����.
    �ڽ����̺��� �θ� �����ϴ� ���ڵ尡 ���������� �θ����̺��� 
    ���ڵ带 delete�� �� �����ϴ�.
*/

/*
����2] �ƿ����ι��
    create table ���̺��(
        �÷��� �ڷ���,
        [constraint �����] foreign key(�÷���)
            references �θ����̺� (������ �÷�) 
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
    ������ �������� �������� Ȯ�� ���� �÷���
   p:primary key 
   r:reference integrity �� foreign key�� ���Ѵ�.
   c:check Ȥ�� not null
   u : unique
 
 */
 
 /*
 ����3] ���̺� ���� �� alter������ �ܷ�Ű �������� �߰�
    alter table ���̺�� add[constraint �����]
        foreign key (�÷���)
            references �θ����̺� (�����÷���)
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
    �ϳ��� �θ����̺� �� �̻��� �ڽ����̺��� �ܷ�Ű�� ���� �� �� �ִ�.
*/

/*
�ܷ�Ű ���� �ɼ�
    [on delete cascade]
        : �θ� ���ڵ� ���� �� �ڽķ��ڵ���� ���� �����ȴ�.
     ����] 
        �÷��� �ڷ��� references �θ����̺� (pk�÷�)
            on delete cascade;
    [on delete set null]
        : �θ��ڵ� ���� �� �ڽķ��ڵ� ���� null�� ����ȴ�.

*�ǹ����� ���԰Խù��� ���� ȸ���� �� �Խñ��� �ϰ������� �����ؾ��� ��
    ����� �� �ִ� �ɼ��̴�. ��, 

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

insert into tb_primary4 values ( 'student' ,'�Ʒû�1');
insert into tb_foreign4 values (1, '����1�Դϴ�.' ,'student');
insert into tb_foreign4 values (2, '����2�Դϴ�.' ,'student');
insert into tb_foreign4 values (3, '����3�Դϴ�.' ,'student');
insert into tb_foreign4 values (4, '����4�Դϴ�.' ,'student');
insert into tb_foreign4 values (5, '����5�Դϴ�.' ,'student');
insert into tb_foreign4 values (6, '����6�Դϴ�.' ,'student');
insert into tb_foreign4 values (7, '����7�Դϴ�.' ,'student');

insert into tb_foreign4 values (8, '��??����??' ,'teacher');

select * from tb_primary4;
select * from tb_foreign4;

/*
�θ����̺��� ���ڵ带 ������ ��� on delete cacade �ɼǿ� ����
 �ڽ��ʱ��� ��� ���ڵ尡 ������.���� �ش� �ɼ��� ���� ���� ���·� 
 �ܷ�Ű�� �����ߴٸ�, ���ڵ�� �������� �ʰ� ������ �߻��ϰԵȴ�.
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
    
insert into tb_primary5 values ( 'student' ,'�Ʒû�1');
insert into tb_foreign5 values (1, '����1�Դϴ�.' ,'student');
insert into tb_foreign5 values (2, '����2�Դϴ�.' ,'student');
insert into tb_foreign5 values (3, '����3�Դϴ�.' ,'student');
insert into tb_foreign5 values (4, '����4�Դϴ�.' ,'student');
insert into tb_foreign5values (5, '����5�Դϴ�.' ,'student');
insert into tb_foreign5 values (6, '����6�Դϴ�.' ,'student');
insert into tb_foreign5 values (7, '����7�Դϴ�.' ,'student');

select * from tb_primary5;
select * from tb_foreign5;

/*
    on delete set null �ɼ����� �ڽ����̺��� ���ڵ�� ���������ʰ�, 
    ����Ű �κи� null������ ����ȴ�.
    ���� ���̻� ������ �� ���� ���ڵ�� ����ȴ�.
*/
delete from tb_primary5 where user_id='student';

--�θ����̺��� ���ڵ�� �����ȴ�.
select * from tb_primary5;
--�ڽ����̺��� ���ڵ�� �����ִ�. ��, �����÷��� null�� ����ȴ�.
select * from tb_foreign5;

/*
not null : null ���� ������� �ʴ� ��������
    ����] 
    create table ���̺��(
        �÷��� �ڷ��� not null,
        �÷��� �ڷ��� null <- null�� ����Ѵٴ� �ǹ̷� �ۼ�������
                            �̷��� ������� �ʴ´�. null�� ������� ������
                            �ڵ����� ����Ѵٴ� �ǹ̰� �ȴ�.
        );

*/

create table tb_not_null (
    m_idx number(10) primary key, --pk�̹Ƿ� nn
    m_id varchar2(20) not null, --nn
    m_pw varchar2(30) null, --null ��� (�Ϲ������� �̷��� ������)
    m_name varchar2(40) -- null ��� (�̿Ͱ��� ���)
    );

desc tb_not_null;
-- 10~30������ ���������� �Էµȴ�.
insert into tb_not_null values(10, 'hong1', '1111', 'ȫ�浿');
insert into tb_not_null values(20, 'hong2', '2222', '');
insert into tb_not_null values(30, 'hong1', '', '');
-- m_id�� no null���� �����Ǿ����Ƿ� null���� ������ �� ���� ������ �߻�.
insert into tb_not_null values(40, '', '', ''); --���� 2��°�� not null�̶�.
-- �Է¼��� ����(space�� �����̹Ƿ� �Էµȴ�.
insert into tb_not_null values(50, ' ', '5555', '���浿');

insert into tb_not_null (m_id,m_pw,m_name)
    values('hong6','6666','���浿');


/*
default : insert �� �ƹ��� ���� �Է����� �ʾ��� �� �ڵ����� ���ԵǴ� 
        �����͸� ������ �� �ִ�.
*/
create table tb_default(
    id varchar2(30) not null,
    pw varchar2(50) default 'gwer'
   );

insert into tb_default values('aaaa','1234'); --1234 �Էµ�.
insert into tb_default values('bbbb'); -- �÷���ü�� �����Ƿ� 
insert into tb_default values('cccc',''); --null�� �Է�
insert into tb_default values('dddd',' '); 
insert into tb_default values('eeee', default);

select * from tb_default;

/*
cheak : domain(�ڷ���) ���Ἲ�� �����ϱ� ���� ����������� �ش� �÷��� 
        �߸��� �����Ͱ� �Էµ��� �ʵ��� �����ϴ� ���������̴�.
*/
--M,F�� �Է��� ����ϴ� check ��������
create table to_check1 (
        gender char(1) not null
        constraint check_gander
            check (gender in ('M','F'))
        );
    
insert into to_check1 values ('M');
insert into to_check1 values ('F');
-- üũ �������� ����� �����߻�
insert into to_check1 values ('T');
-- �Էµ� �����Ͱ� �÷����Ǻ��� ũ�Ƿ� �����߻�
insert into to_check1 values ('����');


create table tb_check2 (
        sale_count number not null
            check (sale_count<=10)
        );
        
insert into tb_check2 values (9);       
insert into tb_check2 values (10);
--�������� ����� �Է½���
insert into tb_check2 values (11);       
