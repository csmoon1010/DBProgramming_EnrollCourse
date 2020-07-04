<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <html><head><link href="style.css" rel="stylesheet" type="text/css"></head></html>
<% String session_id = (String) session.getAttribute("user");
String log;
if (session_id == null)
log = "<a href=login.jsp>로그인</a>";
else log = "<a href=logout.jsp>로그아웃</a>"; %>
<br><br>
<table class="top" width="75%" align="center">
<tr>
<td><%=log%></td>
<td><a href="update.jsp">사용자 정보 수정</a></td>
<td><a href="all_course.jsp">전체과목 조회</a></td>
<td><a href="insert.jsp">수강신청 입력</a></td>
<td><a href="delete.jsp">수강신청 삭제</a></td>
<td><a href="select.jsp">수강신청 조회</a></td>
<td><a href="history.jsp">개별수강 이력</a></td>
</tr>
</table>


