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
DBMS_OUTPUT.put_line(sStudentId || '님이 과목번호 ' || sCourseId || ', 분반 ' || TO_CHAR(nCourseIdNo) || '의 수강 등록을 요청하였습니다.');

  /* 년도, 학기 알아내기 */
  nYear := Date2EnrollYear(SYSDATE);
  nSemester := Date2EnrollSemester(SYSDATE);


  /* 에러 처리 1 : 최대학점 초과여부 */
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


  /* 에러 처리 2 : 동일한 과목 신청 여부 */
  SELECT COUNT(*)
  INTO    nCnt
  FROM   enroll
  WHERE  s_id = sStudentId and c_id = sCourseId;

  IF (nCnt > 0) 
  THEN
     RAISE too_many_courses;
  END IF;


  /* 에러 처리 3 : 수강신청 인원 초과 여부 */
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


  /* 에러 처리 4 : 신청한 과목들 시간 중복 여부 */
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


/*재수강 여부를 결정짓는 if문 --- eAgain과 관련! */
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


/* 에러처리 5: 재수강 할 수 없는 학점 예외처리*/
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

/* 에러처리 6: 영어 레벨이 다르면 신청할 수 없는 예외처리*/
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

  /* 수강 신청 등록 */
  INSERT INTO enroll(s_id, c_id, c_id_no, e_sem, e_again)
  VALUES (sStudentId, sCourseId, nCourseIdNo, concat(nYear,nSemester), eAgain);

  COMMIT;
  result := '수강신청 등록이 완료되었습니다.';

EXCEPTION
  WHEN too_many_sumCourseUnit THEN
    result := '최대학점을 초과하였습니다';
  WHEN too_many_courses THEN
    result := '이미 등록된 과목을 신청하였습니다';
  WHEN too_many_students THEN
    result := '수강신청 인원이 초과되어 등록이 불가능합니다';
  WHEN duplicate_time THEN
    result := '이미 등록된 과목 중 중복되는 시간이 존재합니다';
  WHEN cannot_enroll_again THEN
    result := '재수강을 할 수 없는 학점입니다.';
  WHEN no_data_found THEN
    result := '이번 학기 과목이 아닙니다.';
  WHEN diff_elevel THEN
    result := '해당 분반에 맞지 않는 레벨입니다.';
  WHEN OTHERS THEN
    ROLLBACK;
    result := SQLCODE;
END;
/