<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
String userID = request.getParameter("userID");
String userPassword = request.getParameter("userPassword");
String driver = "oracle.jdbc.driver.OracleDriver";
String url = "jdbc:oracle:thin:@localhost:1521:orcl";
String user = "db1713462";
String password = "ss2";
Connection myConn = null;
Statement stmt = null;
try{
	Class.forName(driver);
	myConn = DriverManager.getConnection(url, user, password);
	stmt = myConn.createStatement();
}catch(ClassNotFoundException e){
	System.out.println("jdbc driver 로딩 실패");
}catch(SQLException e){
	System.out.println("오라클 연결 실패");
}
String mySQL = "select s_id from student where s_id='" + userID + "' and s_pwd='" + userPassword +"'";
ResultSet rs = stmt.executeQuery(mySQL);
if(rs.next()){
	session.setAttribute("user", rs.getString(1));%>
	<script>
	alert("로그인성공");
	location.href="main.jsp";</script>
<%}
else{%>
	<script>
	alert("로그인실패");
	location.href="login.jsp";</script>
<%}
stmt.close();
myConn.close();
%>