/***************************************************************
���ϸ� : Or08GroupBy.sql
�׷� �Լ� (Group by)
����: ��ü ���ڵ�(�ο�(��)(������))���� ������� ����� ���ϱ� ���� 
    �ϳ� �̻��� ���ڵ带 �׷����� ��� ���� �� ����� ��ȯ�ϴ� �Լ� Ȥ�� ������
***************************************************************/
--hr����

-- ������̺��� ������ ���� :  �� 107���� ����˴ϴ�.

select job_id from employees;

/*
distinct
    - ������ ���� �ִ� ��� �ߺ��� ���ڵ带 ������ �� �ϳ��� ���ڵ常 �����ش�.
    - �ϳ��� ������ ���ڵ��̹Ƿ� ������� ���� ����� �� �ִ�.
 */
 
select distinct job_id from employees;

/*
group by
    - ������ ���� �ִ� ���ڵ带 �ϳ��� �׷����� ��� �����´�.
    - �������°� �ϳ��� ���ڵ�����, �ټ��� ���ڵ尡 �ϳ��� �׷����� ������
    ����̹Ƿ� ������� ���� ����� �� �ִ�.
    - �ִ�, �ּ�, ���, �ջ� ���� ������ �����ϴ�.
*/
-- �� �������� �������� �� ������ ī��Ʈ�Ѵ�.
select job_id, count(*) from employees group by job_id; 

--������ ���� �ش� ������ ���� select �ؼ� ����Ǵ� ���� ������ ���غ���.
select first_name, job_id from employees where job_id='FI_ACCOUNT'; --5�� 
select first_name, job_id from employees where job_id='ST_CLERK'; -- 20��

/*
group ���� ���Ե� select ���� ����
    Select
        �÷�1, �÷�2, ...Ȥ�� ��ü(*)
    from 
        ���̺��
    where 
        ����1 and ����2 or ����3
    group by 
        ���ڵ� �׷�ȭ�� ���� �÷���
    having 
        �׷쿡���� ����
    order by
        ������ ���� �÷���� ���Ĺ��(asc Ȥ�� desc)
* ������ ���� ����
    from (���̺�) -> where(����) -> group by(�׷�ȭ) -> having(�׷�����)
    -> select(�÷�����).> order by(���Ĺ��)    
*/

/*
sum() : �հ踦 ���� �� ����ϴ� �Լ�
    - Number Ÿ���� �÷������� ����� �� �ִ�.
    - �ʵ���� �ʿ��� ���, as�� �̿��ؼ� ��Ī�� �ο��� �� �ִ�.
*/

--��ü ������ �޿��� �հ踦 ����Ͻÿ�.
--where ���� �����Ƿ� ��ü ������ ��������Ѵ�.
select 
    sum(salary) as "sumsalary1",
    to_char(sum(salary), '999,000') as "sumsalary2",
    ltrim(to_char(sum(salary), 'L999,000')) as "sumsalary3",
    ltrim(to_char(sum(salary), '$999,000')) as "sumsalary4"
    from employees;

--10�� �μ��� �ٹ��ϴ� ������� �޿��� �հ�� ������ ����Ͻÿ�.

select 
    sum(salary) as "�޿��հ�",
    to_char(sum(salary), '999,000') as "���ڸ� �ĸ�",
    ltrim(to_char(sum(salary), 'L999,000')) as "������������",
    ltrim(to_char(sum(salary), '$999,000')) as "��ȭ��ȣ����"
    from employees where department_id =10;
    
--sum()�� ���� �׷��Լ��� numberŸ���� �÷������� ����� �� �ִ�.
select sum(first_name) from employees; --�����߻� numberŸ���� �÷��� �ƴ϶�.!

/*
count() : �׷�ȭ�� ���ڵ��� ������ ī��Ʈ�� �� ����ϴ� �Լ�.
*/
select count(*) from employees;
select count(employee_id) from employees;

/*
    count() �Լ��� ����� ���� �� 2���� ��� ��� ���������� *�� ����� ����
    �����Ѵ�. �÷��� Ư�� Ȥ�� �����Ϳ� ���� ���ظ� ���� �����Ƿ�, ����ӵ���
    ������.
*/

/*
count() �Լ��� ����
    ���� 1: count(all �÷���)
        => ����Ʈ �������� �÷� ��ü�� ���ڵ带 �������� ī��Ʈ�Ѵ�.
    ���� 2: count(distinct �÷���)
        => �ߺ��� ������ ���¿��� ī��Ʈ�Ѵ�.
*/

select
    count(job_id) "������ ��ü����1",
    count(all job_id) "������ ��ü����2",
    count(distinct job_id) "������� ��������"
 from employees;
 
 /*
 avg() : ��հ��� ���� �� ����ϴ� �Լ�
 */
 
-- ��ü ����� ��� �޿��� ������ ����ϴ� �������� �ۼ��Ͻÿ�,
select 
    count(*) "��ü�����",
    sum(salary) "����޿��� ��",
    sum(salary) / count(*) "��ձ޿� (�������)",
    avg(salary) "��ձ޿�(avg()�Լ�)",
    trim(to_char(avg(salary), '$999,000')) "���� �� ��������"
 from employees;
 
 --������(salse)�� ��ձ޿��� ���ΰ���?
 -- 1. �μ����̺��� �������� �μ���ȣ�� �������� Ȯ���Ѵ�.
 /*
   �����˻� �� ��ҹ��� Ȥ�� ������ ���Ե� ��� ��� ���ڵ忡 ���� 
   ���ڿ��� Ȯ���ϴ� ���� �Ұ����ϹǷ� �ϰ����� ��Ģ�� ������ ���� 
   upper()�� ���� ��ȯ�Լ��� ����Ͽ� �˻��ϴ� ���� ����.
 */ 
 select * from departments where department_name=initcap('sales');
 select * from departments where lower(department_name)='sales';
 select * from departments where upper(department_name)=upper('sales');
 
--�μ���ȣ�� 80�� ���� Ȯ���� �� ���� �������� �ۼ��Ѵ�.
select ltrim(to_char(avg(salary), '$999,000.00'))
 from employees where department_id=80;
 
 /*
 min(), max() �Լ� : �ִ밪, �ּҰ��� ã�� �� ����ϴ� �Լ�
 */
 
 --��ü ��� �� ���� ���� �޿��� ���ΰ���?
 select min(salary) from employees;
 
 -- ��ü ��� �� �޿��� ���� ���� ������ �����ΰ���?
 -- �Ʒ� �������� �����߻� ��. �׷��Լ��� �Ϲ��÷��� ����� �� �����ϴ�.
select first_name, salary from employees where salary=min(salary); --����


--������̺��� ���� ���� �޿��� 2100�� �޴� ����� �����Ѵ�.
 select first_name, salary from employees where salary= 2100;

 /*
    ��� �� ���� ���� �޿��� min()���� ���� �� ������ ���� ���� �޿��� �޴� 
    ����� �Ʒ��� ���� ���������� ���� ���� �� �ִ�.
    ����, ������ ���� ���������� ����� �� ���θ� �����ؾ��Ѵ�.
*/
select first_name, salary from employees where salary=
        (select min(salary) from employees);
    
/*
group by�� : �������� ���ڵ带 �ϳ��� �׷����� �׷�ȭ�ƿ� ������ ����� 
    ��ȯ�ϴ� ������
    *distinct�� �ܼ��� �ߺ����� ������.
*/
-- ������̺��� �� �μ��� �޿��� �հ�� ���ΰ���?
-- IT �μ��� �޿� �հ�
select sum(salary) from employees where department_id=60;

--Finance�μ��� �޿� �հ�
select sum(salary) from employees where department_id=100;

/*
step1 : �μ��� ���� ��� ������ �μ����� Ȯ���� �� �����Ƿ� �μ��� �׷�ȭ�Ѵ�.
        �ߺ��� ���ŵ� ����� �������� ������ ���ڵ尡 �ϳ��� �׷����� ������ �����
        ����ȴ�.
*/
select department_id from employees group by department_id;

/*
step2 : �� �μ����� �޿��� �հ踦 ���� �� �ִ�. 4�ڸ��� �Ѿ�� ��� ��������
    �������Ƿ� ������ �̿��ؼ� ���ڸ����� �޸��� ǥ���Ѵ�.
*/
select department_id, sum(salary), trim(to_char(sum(salary), '999,000'))
    from employees group by department_id order by sum(salary) desc;
    
/*
����] ������̺��� �� �μ��� ������� ��ձ޿��� ������ ����ϴ� �������� 
    �ۼ��Ͻÿ�. 
    ��°�� : �μ���ȣ, �޿�����, �������, ��ձ޿�
    ��� �� �μ���ȣ�� �������� ���������� �����Ͻÿ�.
*/
--ȥ�� Ǯ���� �� ���.
select * from employees;
select department_id "�μ���ȣ", sum(salary) "�޿�����", count(*) "�������",
    trim(to_char(avg(salary),'999,000')) "��ձ޿�" 
    from employees group by department_id order by department_id asc;

 -- �ٰ��� ���� �� ���.
 select department_id "�μ���ȣ", rtrim(to_char(sum(salary),'999,000')) "�޿�����",
 count(*) "�����", rtrim(to_char(avg(salary),'999,000')) "��ձ޿�" 
    from employees group by department_id order by department_id asc;
    
/*
�տ��� ����ߴ� �������� �Ʒ��� ���� �����ϸ� ������ �߻��Ѵ�.
group by������ ����� �÷��� select ������ ����� �� ������, �� ���� ���� �÷���
selcet ������ ����� �� ����.
�׷�ȭ�� ���¿��� Ư�����ڵ� �ϳ��� �����ϴ� ���� �ָ��ϱ� �����̴�.
*/
select department_id, sum(salary), count(*), avg(salary), first_name
    from employees group by department_id; 
--���� ���� �׷�ȭ �������� first_name�� ���ԵǾ��ֱ� ������ ����, 

/*
�ó�����] �μ����̵� 50�� ������� ��������, ��� �޿�, �޿������� ������
    ����ϴ� �������� �ۼ��Ͻÿ�.
*/
select 
    '50���μ�', count(*), round(avg(salary)), sum(salary)
    from employees where department_id=50
    group by department_id;
    
/*
having �� : ���������� �����ϴ� �÷��� �ƴ� �׷��Լ��� ���� ��������
    ������ �÷��� ������ �߰��� �� ����Ѵ�.
    �ش� ������ where���� �߰��ϸ� ������ �߻��Ѵ�
*/

/*
�ó�����] ������̺��� �� �μ����� �ٹ��ϰ� �ִ� ������ �������� �������
    ��ձ޿��� ������ ����ϴ� �������� �ۼ��Ͻÿ�.
*/
/*
 ���� �μ��� �ٹ��ϴ��� �������� �ٸ� �� �����Ƿ� �� ���������� 
 group by���� 2���� �÷��� ����ؾ��Ѵ�. �� �μ��� �׷�ȭ �� ��, 
 �ٽ� ���������� �׷�ȭ�Ѵ�.
*/
select department_id, job_id, count(*), avg(salary)
 from employees
 where count(*)>10 --���⼭ �����߻�
 group by department_id, job_id;
 
 /*
    ������ �� ������� ���������� �����ϴ� �÷��� �ƴϹǷ�(�Լ��� ����ѰŶ� 
    ���̺� ���� �ش� �����Ͱ� ����) where���� ���� ������ �߻��Ѵ�.
    �̷� ��쿡�� having���� ������ �߰��ؾ��Ѵ�.
    ex) �޿��� 3000�� ��� => ���������� �����ϹǷ� where�� ���
       ��ձ޿��� 3000�� ���=> �������� �����ϹǷ� having�� ���
                                ��, �׷��Լ��� ���� ���� �� �ִ� ��������.
 */
 
 select department_id, job_id, count(*), avg(salary)
 from employees group by department_id, job_id
 having count(*)>10;
 
 /*
  ����] �������� ����� �����޿��� ����Ͻÿ�.
  ��, (������(manager)�� ���� ����� �����޿��� 3000�̸��� �׷�)�� ���ܽ�Ű��,
  ����� �޿��� ������������ �����Ͽ� ����Ͻÿ�.
 */
 select job_id, min(salary) from employees
 where manager_id is not null
 group by job_id
 having not min(salary)<3000 order by min(salary) desc;
 
 /*
    ���������� �޿��� ������������ �����϶�� ���û����� ������,
    ���� select�Ǵ� �׸��� �޿��� �ּҰ��̹Ƿ� order by������ min(salary)�� 
    ����ؾ��Ѵ�.
 */
 
 
--3������

select * from employees;
select job_id, count(*) from employees
    group by job_id order by count (*);
    

 
 
 
 
 