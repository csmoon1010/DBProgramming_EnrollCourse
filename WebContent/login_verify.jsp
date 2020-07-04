<%@ page contentType="text/html; charset=EUC-KR" %>
<%@page import="java.sql.*"%>
<%
String userID=request.getParameter("userID");
String userPassword=request.getParameter("userPassword");

Connection myConn = null;
Statement stmt = null;
String mySQL = null;
ResultSet rs = null;

String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
String user = "db1713462"; String passwd = "ss2";
String dbdriver = "oracle.jdbc.driver.OracleDriver";

Class.forName(dbdriver);//jdbc 드라이버 로딩
myConn=DriverManager.getConnection(dburl, user, passwd);//jdbc드라이버를 이용한 데이터베이스 연결
stmt = myConn.createStatement();

mySQL="select s_id from student where s_id='" + userID + "'and s_pwd='" + userPassword + "'";

rs = stmt.executeQuery(mySQL);

if(rs.next()){
	session.setAttribute("user", userID);
	response.sendRedirect("main.jsp");
}
else{
	response.sendRedirect("login.jsp");
}

stmt.close();
myConn.close();
%>
