<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>수강신청 입력</title>
</head>
<body>
<%@ include file = "top.jsp"%>
<br>
<% if (session_id == null) response.sendRedirect("login.jsp"); %>
<center><div id = "semesterInfo"></div></center>
<table width = "70%" align = "center" border>
<tr><th>과목번호</th><th>분반</th><th>과목명</th><th>학점</th><th>주관학과</th><th>레벨</th>
<th>요일</th><th>시간</th><th>교수</th><th>강의실</th><th>수강신청</th></tr>
<%
String driver = "oracle.jdbc.driver.OracleDriver";
String url = "jdbc:oracle:thin:@localhost:1521:orcl";
String user = "db1713462";
String password = "ss2";
Connection myConn = null;
Statement stmt = null;
String mySQL = "";
ResultSet myResultSet = null;

try{
	Class.forName(driver);
	myConn = DriverManager.getConnection(url, user, password);
	stmt = myConn.createStatement();
}catch(ClassNotFoundException e){
	System.out.println("jdbc driver 로딩 실패");
}catch(SQLException e){
	System.out.println("오라클 연결 실패");
}

//현 학기에 해당하는 과목만 보여주기
CallableStatement cstmt = myConn.prepareCall("{? = call Date2EnrollSem(SYSDATE)}");
cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
cstmt.execute();
int sem = cstmt.getInt(1);
int year = sem/10; int semester = sem%10;
%>
<script>document.getElementById('semesterInfo').innerHTML = "<%=year%>년  <%=semester%>학기";</script>
<%
mySQL = "select c.c_id, c.c_id_no, c_name, c_unit, c_major, NVL(c_Elevel, ' '), t_date, t_time, t_prof, t_room" 
+" from course c, teach t where c.c_id = t.c_id and c.c_id_no = t.c_id_no and t_sem = " 
+ sem + " and c.c_id not in(select c_id from enroll where s_id = '" 
+ session_id + "')";
myResultSet = stmt.executeQuery(mySQL);

if(myResultSet != null){
	while(myResultSet.next()){
		String c_id = myResultSet.getString(1);
		int c_id_no = myResultSet.getInt(2);
		String c_name = myResultSet.getString(3);
		int c_unit = myResultSet.getInt(4);
		String c_major = myResultSet.getString(5);
		String c_Elevel = myResultSet.getString(6);
		String t_date = myResultSet.getString(7);
		int t_time = myResultSet.getInt(8);
		String t_prof = myResultSet.getString(9);
		String t_room = myResultSet.getString(10);
		%>
		<tr>
		<td align = "center"><%=c_id %></td><td align = "center"><%=c_id_no %></td>
		<td align = "center"><%=c_name %></td><td align = "center"><%=c_unit %></td>
		<td align = "center"><%=c_major %></td><td align = "center"><%=c_Elevel %></td>
		<td align = "center"><%=t_date %></td><td align = "center"><%=t_time %></td>
		<td align = "center"><%=t_prof %></td><td align = "center"><%=t_room %></td>
		<td align = "center"><a href="insert_verify.jsp?c_id=<%=c_id%>&c_id_no=<%=c_id_no%>">신청</a></td>
		</tr>
	<%}
}
stmt.close();
myConn.close();
%>
</table>
</body>
</html>