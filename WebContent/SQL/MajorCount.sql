create or replace procedure MajorCount(
sStudentId in varchar2,
totalnum OUT number,
totalnum2 OUT number
)

IS

studentMajor VARCHAR2(30);

cursor major_list (cc_major course.c_major%type) is
select c.c_unit
from course c, history h
where c.c_major = cc_major and h.c_id = c.c_id and h.c_id_no = c.c_id_no
and h.s_id = sStudentId;

BEGIN
totalnum := 0;
totalnum2 := 0;

select s_major
into studentMajor
from student
where s_id = sStudentId;

for majorlist in major_list(studentMajor)
loop
totalnum := totalnum + majorlist.c_unit;
end loop;

for majorlist in major_list('±³¾ç')
loop
totalnum2 := totalnum2 + majorlist.c_unit;
end loop;

END;
/