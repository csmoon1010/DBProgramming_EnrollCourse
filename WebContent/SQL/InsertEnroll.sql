CREATE OR REPLACE PROCEDURE InsertEnroll (
  sStudentId IN VARCHAR2, 
  sCourseId IN VARCHAR2, 
  nCourseIdNo IN NUMBER,
  result OUT VARCHAR2)
IS
  too_many_sumCourseUnit EXCEPTION;
  too_many_courses EXCEPTION;
  too_many_students EXCEPTION;
  duplicate_time EXCEPTION;
  cannot_enroll_again EXCEPTION;
  diff_elevel EXCEPTION;

  nYear NUMBER;
  nSemester NUMBER;
  nSumCourseUnit NUMBER;
  nCourseUnit course.c_unit%TYPE;
  nCnt NUMBER;
  nTeachMax teach.t_max%TYPE;
  hscore VARCHAR(20);
  eAgain NUMBER;
  again NUMBER;
  nagain number;
  CLev course.c_elevel%TYPE;
  SLev student.s_elevel%TYPE;


BEGIN
  result := '';

DBMS_OUTPUT.put_line('#');
DBMS_OUTPUT.put_line(sStudentId || '���� �����ȣ ' || sCourseId || ', �й� ' || TO_CHAR(nCourseIdNo) || '�� ���� ����� ��û�Ͽ����ϴ�.');

  /* �⵵, �б� �˾Ƴ��� */
  nYear := Date2EnrollYear(SYSDATE);
  nSemester := Date2EnrollSemester(SYSDATE);


  /* ���� ó�� 1 : �ִ����� �ʰ����� */
  SELECT SUM(c.c_unit) 
  INTO    nSumCourseUnit
  FROM   course c, enroll e
  WHERE  e.s_id = sStudentId and substr(e.e_sem, 1,4) = nYear and substr(e.e_sem, -1) = nSemester
    and  e.c_id = c.c_id and e.c_id_no = c.c_id_no;

  SELECT c_unit
  INTO    nCourseUnit
  FROM    course
  WHERE    c_id = sCourseId and c_id_no = nCourseIdNo;

  IF (nSumCourseUnit + nCourseUnit > 9)
  THEN  
     RAISE too_many_sumCourseUnit;
  END IF;


  /* ���� ó�� 2 : ������ ���� ��û ���� */
  SELECT COUNT(*)
  INTO    nCnt
  FROM   enroll
  WHERE  s_id = sStudentId and c_id = sCourseId;

  IF (nCnt > 0) 
  THEN
     RAISE too_many_courses;
  END IF;


  /* ���� ó�� 3 : ������û �ο� �ʰ� ���� */
  SELECT t_max
  INTO    nTeachMax
  FROM   teach
  WHERE  substr(t_sem, 1,4) = nYear and substr(t_sem, -1) = nSemester 
    and c_id = sCourseId and c_id_no= nCourseIdNo;

  SELECT COUNT(*)
  INTO   nCnt
  FROM   enroll
  WHERE  substr(e_sem, 1,4) = nYear and substr(e_sem, -1) = nSemester 
         and c_id = sCourseId and c_id_no = nCourseIdNo;

  IF (nCnt >= nTeachMax)
  THEN
     RAISE too_many_students;
  END IF;


  /* ���� ó�� 4 : ��û�� ����� �ð� �ߺ� ���� */
select count(*)
into nCnt
from
(
select t_time, t_date
from teach
where substr(t_sem, 1, 4) = nYear and substr(t_sem, -1) = nSemester and
c_id = sCourseId and c_id_no = nCourseIdNo
intersect
select t.t_time, t.t_date
from teach t, enroll e
where e.s_id = sStudentId and substr(e.e_sem, 1,4) = nYear and substr(e.e_sem, -1) = nSemester and 
substr(t.t_sem, 1, 4) = nYear and substr(t.t_sem, -1) = nSemester and
e.c_id = t.c_id and e.c_id_no = t.c_id_no
);

if(nCnt > 0)
then
raise duplicate_time;
end if;


/*����� ���θ� �������� if�� --- eAgain�� ����! */
select count(*)
into again
from history h, teach t
where h.s_id = sStudentId and h.c_id = sCourseId and substr(t.t_sem, 1, 4) = nYear and substr(t.t_sem, -1) = nSemester;

if(again>0)
then
eAgain := 1;
else
eAgain := 0;
end if;


/* ����ó�� 5: ����� �� �� ���� ���� ����ó��*/
select count(*)
into nagain
from history h
where h.s_id = sStudentId and h.c_id = sCourseId;

if(nagain >0)
then

select substr(h_score, 1, 1)
into hscore
from history h
where h.s_id = sStudentId and h.c_id = sCourseId;

if(hscore = 'A' or hscore = 'B')
then
raise cannot_enroll_again;
end if;

end if;

/* ����ó�� 6: ���� ������ �ٸ��� ��û�� �� ���� ����ó��*/
select c_ELevel
into CLev
from course
where c_id =  sCourseId and c_id_no = nCourseIdNo;

select s_Elevel
into SLev
from student
where s_id = sStudentId;

if(CLev <> SLev)
then
raise diff_elevel;
end if;

  /* ���� ��û ��� */
  INSERT INTO enroll(s_id, c_id, c_id_no, e_sem, e_again)
  VALUES (sStudentId, sCourseId, nCourseIdNo, concat(nYear,nSemester), eAgain);

  COMMIT;
  result := '������û ����� �Ϸ�Ǿ����ϴ�.';

EXCEPTION
  WHEN too_many_sumCourseUnit THEN
    result := '�ִ������� �ʰ��Ͽ����ϴ�';
  WHEN too_many_courses THEN
    result := '�̹� ��ϵ� ������ ��û�Ͽ����ϴ�';
  WHEN too_many_students THEN
    result := '������û �ο��� �ʰ��Ǿ� ����� �Ұ����մϴ�';
  WHEN duplicate_time THEN
    result := '�̹� ��ϵ� ���� �� �ߺ��Ǵ� �ð��� �����մϴ�';
  WHEN cannot_enroll_again THEN
    result := '������� �� �� ���� �����Դϴ�.';
  WHEN no_data_found THEN
    result := '�̹� �б� ������ �ƴմϴ�.';
  WHEN diff_elevel THEN
    result := '�ش� �йݿ� ���� �ʴ� �����Դϴ�.';
  WHEN OTHERS THEN
    ROLLBACK;
    result := SQLCODE;
END;
/