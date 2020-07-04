create or replace procedure SelectTimeTable(
sStudentId in varchar2,
nYear in number,
nSemester in number)

is
cid course.c_id%type;
cname course.c_name%type;
cidno course.c_id_no%type;
cunit course.c_unit%type;

troom teach.t_room%type;
ttime teach.t_time%type;

nTotalUnit number := 0;

cursor cur(sStudentId varchar2, nYear number, nSemester number)
is
select e.c_id, c.c_name, e.c_id_no, c.c_unit, t.t_time, t.t_room
from enroll e, course c, teach t
where e.s_id = sStudentId and substr(e.e_sem, 1, 4) = nYear
and substr(e.e_sem, -1) = nSemester and
substr(t.t_sem, 1, 4) = nYear and substr(t.t_sem, -1) = nSemester and
e.c_id = c.c_id and e.c_id_no = c.c_id_no and
c.c_id = t.c_id and c.c_id_no = t.c_id_no;

begin
open cur(sStudentId, nYear, nSemester);
dbms_output.put_line(to_char(nYear) ||'년도 '||to_char(nSemester)||'학기의 '|| sStudentId||'님의 수강신청 시간표입니다.');
loop
fetch cur into cid, cname, cidno, cunit, ttime, troom ;
exit when cur%notfound;

dbms_output.put_line('교시:' || to_char(ttime) ||'   과목번호:'||cid|| '   과목명:'|| cname|| '   분반:'||to_char(cidno)|| '   학점:' ||to_char(cunit) ||'   강의실:'||troom);
nTotalUnit := nTotalUnit + cunit;
end loop;

dbms_output.put_line('총 '||to_char(cur%rowcount) || '과목과 총 '|| to_char(nTotalUnit) ||'학점을 신청하였습니다.');
close cur;
end;
/
