<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8">
<title>수강신청 사용자 정보 수정</title></head>
<body>
<%@ include file="top.jsp" %>
<table width="75%" align="center" border>
<form method="post" action="update_verify.jsp">
<tr>
<td><div align="center">아이디</div></td>
<td><div align="center" name = "userID"><%=session_id%></div></td>
</tr>
<tr>
<td><div align="center">패스워드</div></td>
<td><div align="center"><input type="text" name="userPassword" class="editable"></div></td>
</tr>
<tr>
<td><div align="center">이름</div></td>
<td><div align="center" name = "userName"></div></td>
</tr>
<tr>
<td><div align="center">학년</div></td>
<td><div align="center" name="userGrade"></div></td>
</tr>
<tr>
<td><div align="center">주소</div></td>
<td><div align="center"><input type="text" name="userAddress" class="editable"></div></td>
</tr>
<tr>
<td colspan=2><div align="center">
<input type="SUBMIT" name="Submit" value="수정">
</div></td>
</tr>
</form>
<style>
.editable{
	width:70%;
	text-align:center;
}
</style>
<% if(session_id == null) response.sendRedirect("login.jsp");
else{	
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
	String mySQL = "select s_pwd, s_name, s_grade, s_addr from student where s_id="+session_id+"";
	ResultSet rs = stmt.executeQuery(mySQL);
	if(rs.next()){
		String pwd = rs.getString("s_pwd");
		String name = rs.getString("s_name");
		String grade = rs.getString("s_grade");
		String addr = rs.getString("s_addr");%>
		<script>
		document.getElementsByName("userPassword")[0].value = '<%=pwd%>';
		document.getElementsByName("userAddress")[0].value = '<%=addr%>';
		document.getElementsByName("userName")[0].innerHTML = "<%=name%>";
		document.getElementsByName("userGrade")[0].innerHTML = "<%=grade%>";</script>
	<%}
	else{
	}
}%>
</table>
</body>
</html>