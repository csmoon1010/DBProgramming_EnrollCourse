<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head><title>수강신청 사용자 정보 수정</title></head>
<body>
<%
request.setCharacterEncoding("utf-8");
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
String session_id = (String)session.getAttribute("user");
String userPassword = request.getParameter("userPassword");
String userAddress = request.getParameter("userAddress");
String mySQL = "update student set s_pwd = '" + userPassword + "', s_addr= '" + userAddress + "' where s_id = '" + session_id + "'";
//String mySQL = "update student set s_pwd = '" + userPassword + "' where s_id = '" + session_id + "'";
try{
	stmt.executeUpdate(mySQL);%>
	<script>alert('수정 완료');
	location.href = 'update.jsp';</script>
<%}catch(SQLException ex){
	String sMessage;
	if(ex.getErrorCode() == 20002)	sMessage = "암호는 4자리 이상이어야 합니다";
	else if(ex.getErrorCode() == 20003)	sMessage = "암호에 공란은 입력되지 않습니다.";
	else	sMessage = "잠시 후 다시 시도하십시오.";
	%><script>alert('<%=sMessage%>');
	location.href = 'update.jsp';</script>
<%}%>
</body>
</html>