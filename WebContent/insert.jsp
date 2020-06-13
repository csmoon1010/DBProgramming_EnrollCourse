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
<% if (session_id == null) response.sendRedirect("login.jsp"); %>

<table width = "75%" align = "center" border>
<br>
<tr><th>과목번호</th><th>분반</th><th>과목명</th><th>학점</th><th>수강신청</th></tr>
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

mySQL = "select c_id, c_id_no, c_name, c_unit from course where c_id not in(select c_id from enroll where s_id = '" 
+ session_id + "')";
myResultSet = stmt.executeQuery(mySQL);

if(myResultSet != null){
	while(myResultSet.next()){
		String c_id = myResultSet.getString("c_id");
		int c_id_no = myResultSet.getInt("c_id_no");
		String c_name = myResultSet.getString("c_name");
		int c_unit = myResultSet.getInt("c_unit");%>
		<tr>
		<td align = "center"><%=c_id %></td><td align = "center"><%=c_id_no %></td>
		<td align = "center"><%=c_name %></td><td align = "center"><%=c_unit %></td>
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