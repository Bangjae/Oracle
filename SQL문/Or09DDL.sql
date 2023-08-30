/***************************************************
���ϸ� : Or09DDL.sql
DDL : Data Definition Language(������ ���Ǿ�)
���� : ���̺�, ��� ���� ��ü�� ���� �� �����ϴ� �������� ���Ѵ�.

****************************************************/
--system ����

/*
system�������� ������ �� �Ʒ� ����� �����Ѵ�.
���ο� ����� ������ ������ �� ���ӱ��Ѱ� ���̺� �������ѵ��� �ο��Ѵ�.
*/
-- oracle21c �̻���ʹ� �������� �� �ش����� �����ؾ��Ѵ�.
alter session set "_ORACLE_SCRIPT" = true;
-- study ������ �����ϰ�, �н����带 1234�� �ο��Ѵ�.
create user study identified by 1234;
-- ������ ������ ��� ������ �ο��Ѵ�.
grant connect, resource to study;

---------------------------------------------------------------------
--study ������ ������ �� �ǽ��� �����մϴ�.
select * from dual;

--�ش� ������ ������ ���̺��� ����� ������ �ý��� ���̺�
--�̿� ���� ���̺��� "�����ͻ���"�̶�� �Ѵ�.
select * from tab;

/*
    ���̺� �����ϱ�
        ����] create table ���̺��( 
                �÷���1 �ڷ���,
                �÷���2 �ڷ���,
                ... 
                primary kit(�÷���) ���� ���������߰�);
*/
create table tb_member(
    idx number(10), --10�ڸ��� ������ ǥ��
    userid varchar2(30), -- ���������� 30byte ���尡��
    passwd varchar2(50), 
    username varchar2(30),
    mileage number(7,2) -- �տ����ڴ� �ڸ���, ���ڸ����ڴ� �Ҽ��� ���°�ڸ�. 
   );                   -- �Ǽ�ǥ��, ��ü 7�ڸ�, �Ҽ����� 2�ڸ� ǥ��

--���� ������ ������ ������ ���̺� ����� Ȯ���մϴ�.
select * from tab;

-- ���̺��� ����(��Ű��) Ȯ��. �÷���, �ڷ��� ,ũ�� ���� Ȯ���Ѵ�.
desc tb_member;

/*
���� ������ ���̺� ���ο� �÷� �߰��ϱ�
    -> tb_member ���̺� email �÷��� �߰��Ͻÿ�.
  ����] alter table ���̺�� add �߰��� �÷� �ڷ���(ũ��) ��������;
*/
alter table tb_member add email varchar2(100);
desc tb_member;

/*
���� ������ ���̺��� �÷� �����ϱ� 
    -> tb_member ���̺��� email �÷��� ����� 200���� Ȯ���Ͻÿ�.
    ���� �̸��� ����Ǵ� username�÷��� 60���� Ȯ���Ͻÿ�.
 
  ����] alter table ���̺�� modify ������ �÷��� �ڷ���(ũ��);
*/
alter table tb_member modify email varchar2(200);
alter table tb_member modify username varchar2(60);
desc tb_member;

/*
���� ������ ���̺��� �÷��� �����ϱ�.
    -> tb_member ���̺��� mileage �÷��� �����Ͻÿ�.

 ����] alter talbe ���̺�� drop column ������ �÷���;
*/
alter table tb_member drop column mileage;
desc tb_member;

/*
����] ���̺� ���Ǽ��� �ۼ��� employees ���̺��� �ش� study ������ �״�� 
     �����Ͻÿ�. ��, ���������� ������� �ʽ��ϴ�.
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
���̺� �����ϱ�
        -> employees ���̺��� �� �̻� ������� �����Ƿ� �����Ͻÿ�.
    ����] drop table ������ ���̺��;
*/
select * from tab;
-- ���̺� ����
drop table employees;
-- ���� �� ���̺� ��Ͽ����� ������ �ʴ´�. �����뿡 �� ����.
select * from tab;
-- ��ü�� �������� �ʴ´ٴ� ������ �߻��Ѵ�.
desc employees;

/*
tb_member ���̺� ���ο� ���ڵ带 �����Ѵ�.(DML �κп��� �н��� ����)
������ ���̺� �����̽���� ������ ���� ������ �� ���� �����̴�.
*/

insert into tb_member values
    (1, 'hong', '1234', 'ȫ�浿', 'hong@naver.com');

/*
����Ŭ 11g������ ���ο� ������ ������ �� connect, resource�� (Roule)��
�ο��ϸ� ���̺� ���� �� ���Ա��� ������, �� ���� ���������� ���̺� �����̽� ����
������ �߻��Ѵ�. ���� �Ʒ��� ���� ���̺� �����̽��� ���� ���ѵ� �ο��ؾ��Ѵ�.
�ش� ����� system �������� ������ �� �����ؾ� �Ѵ�.
*/
------------system ����-----------------------

grant unlimited tablespace to study;

--�ٽ� study �������� ������ �� ���ڵ忡 �����Ѵ�.
insert into tb_member values
    (1, 'hong','1234','ȫ�浿','hong@naver.com');
insert into tb_member values
    (2, 'yu','9867','����','hong@hanmial.net');

--���Ե� ���ڵ带 Ȯ���Ѵ�.
select * from tb_member;

/*
    select������ ����� �� where���� ������ ��� ���ڵ带 ����϶�� ����̹Ƿ�
    �Ʒ������� ��� ���ڵ带 �����ͼ� ���纻 ���̺��� �����Ѵ�.
    ��, ���ڵ���� ����ȴ�.
*/

create table tb_member_copy
    as
    select * from tb_member;
desc tb_member_copy;
select * from tb_member_copy;

--���̺� �����ϱ�2: ���ڵ�� �����ϰ� ���̺� ������ ����
create table tb_member_empty
    as
    select * from tb_member where 1=0;
desc tb_member_empty;

/*
DDL�� : ���̺��� ���� �� �����ϴ� �������̴�.
(Data Definition Language) 
     ���̺� ����: create table ���̺��
     ���̺� ����
        �÷� �߰�: alter table ���̺�� add �÷���
        �÷� ����: alter table ���̺�� modify �÷���
        �÷� ����: alter table ���̺�� drop colummn �÷���
     ���̺� ����: drop table ���̺��
*/

---------------------------study����------------------------

/*







