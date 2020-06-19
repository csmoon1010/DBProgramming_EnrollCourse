<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<title>수강신청 사용자 정보 수정</title></head>
<body>
<%@ include file="top.jsp" %>
<center><div id = "updateMessage"></div></center>
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
<td><div align="center">전공</div></td>
<td><div align="center" name="userMajor"></div></td>
</tr>
<tr>
<td><div align="center">이메일</div></td>
<td><div align="center"><input type="text" name="userEmail" class="editable"></div></td>
</tr>
<tr>
<td><div align="center">주소</div></td>
<td><div align="center"><input type="text" name="userAddress" class="editable"></div></td>
</tr>
<tr>
<td><div align="center">거래은행명</div></td>
<td><div align="center"><input type="text" name="userBank" class="editable"></div></td>
</tr>
<tr>
<td><div align="center">계좌번호</div></td>
<td><div align="center"><input type="text" name="userAccount" class="editable"></div></td>
</tr>
<tr>
<td><div align="center">전화번호</div></td>
<td><div align="center"><input type="text" name="userPhone" class="editable"></div></td>
</tr>
<tr>
<td><div align="center">영토발 레벨</div></td>
<td><div align="center" name = "userElevel"></div></td>
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
	String mySQL = "select s_pwd, s_name, s_major, s_email, s_addr, s_bank, s_bank_acc, s_phone, s_Elevel from student where s_id="+session_id+"";
	ResultSet rs = stmt.executeQuery(mySQL);
	if(rs.next()){
		String pwd = rs.getString("s_pwd");
		String name = rs.getString("s_name");
		String major = rs.getString("s_major");
		String email = rs.getString("s_email");
		String addr = rs.getString("s_addr");
		String bank = rs.getString("s_bank");
		String account = rs.getString("s_bank_acc");
		String phone = rs.getString("s_phone");
		String Elevel = rs.getString("s_Elevel");%>
		<script>
		document.getElementsByName("userPassword")[0].value = '<%=pwd%>';
		document.getElementsByName("userEmail")[0].value = '<%=email%>';
		document.getElementsByName("userAddress")[0].value = '<%=addr%>';
		document.getElementsByName("userBank")[0].value = '<%=bank%>';
		document.getElementsByName("userAccount")[0].value = '<%=account%>';
		document.getElementsByName("userPhone")[0].value = '<%=phone%>';
		
		document.getElementsByName("userName")[0].innerHTML = "<%=name%>";
		document.getElementsByName("userMajor")[0].innerHTML = "<%=major%>";
		document.getElementsByName("userElevel")[0].innerHTML = "<%=Elevel%>";
		</script>
	<%}
	else{
	}
}%>
</table>
</body>
</html>