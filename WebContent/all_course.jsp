<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>전체과목 조회</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
</head>
<body>
<%@ include file = "top.jsp"%>
<br>
<div id = "semesterInfo"></div>
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
	}%>

<div class = "combos">
	<div>
		<select id = "majorCombos">
			<option value="liberal">교양</option>
			<option value="computer">컴퓨터과학전공</option>
			<option value="management">경영학과</option>
		</select>
		<button id = "selectMajor">선택</button>
	</div>
	<br>
	<% String majors[] = new String[]{"liberal", "computer", "management"}; 
	for(int i = 0; i < majors.length; i++){%>
	<div class = "tables" id=<%=majors[i] %>>
		<%
		mySQL = "select DISTINCT c_id, c_name, c_unit, c_major, c_elevel from " + majors[i];
		myResultSet = stmt.executeQuery(mySQL);
		%>
		<table width = "70%" align = "center" border>
		<tr><th>과목번호</th><th>과목명</th><th>학점</th><th>주관학과</th><th>레벨</th></tr>
		<%
		if(myResultSet!=null){
			while(myResultSet.next()){
				String c_id = myResultSet.getString(1);
				String c_name = myResultSet.getString(2);
				int c_unit = myResultSet.getInt(3);
				String c_major = myResultSet.getString(4);
				String c_Elevel = myResultSet.getString(5);
				if(c_Elevel == null)	c_Elevel = " ";
			%>
			<tr>
				<td align = "center"><%=myResultSet.getString(1) %></td>
				<td align = "center"><%=c_name %></td><td align = "center"><%=c_unit %></td>
				<td align = "center"><%=c_major %></td><td align = "center"><%=c_Elevel %></td>
			</tr>
		<%}
		}%>
		</table>
	</div>
	<%} %>
</div>
	
<script>
	$('.tables').hide();
	$('#liberal').show();
	$('#selectMajor').on('click', function(){
		var major = $("#majorCombos option:selected").val();
		$('.tables').hide();
		$('#' + major).show();
	});
</script>

<style>
.combos{
	text-align:center;
}
#semesterInfo{
	text-align:center;
}
</style>
</body>
</html>