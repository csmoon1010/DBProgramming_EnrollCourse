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
dbms_output.put_line(to_char(nYear) ||'�⵵ '||to_char(nSemester)||'�б��� '|| sStudentId||'���� ������û �ð�ǥ�Դϴ�.');
loop
fetch cur into cid, cname, cidno, cunit, ttime, troom ;
exit when cur%notfound;

dbms_output.put_line('����:' || to_char(ttime) ||'   �����ȣ:'||cid|| '   �����:'|| cname|| '   �й�:'||to_char(cidno)|| '   ����:' ||to_char(cunit) ||'   ���ǽ�:'||troom);
nTotalUnit := nTotalUnit + cunit;
end loop;

dbms_output.put_line('�� '||to_char(cur%rowcount) || '����� �� '|| to_char(nTotalUnit) ||'������ ��û�Ͽ����ϴ�.');
close cur;
end;
/
