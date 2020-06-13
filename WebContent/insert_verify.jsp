<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수강신청 입력</title>
</head>
<body>

<%
String s_id = (String)session.getAttribute("user");
String c_id = request.getParameter("c_id");
int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
%>
<%
String driver = "oracle.jdbc.driver.OracleDriver";
String url = "jdbc:oracle:thin:@localhost:1521:orcl";
String user = "db1713462";
String password = "ss2";
Connection myConn = null;
String result = null;

try{
	Class.forName(driver);
	myConn = DriverManager.getConnection(url, user, password);
}catch(ClassNotFoundException e){
	System.out.println("jdbc driver 로딩 실패");
}catch(SQLException e){
	System.out.println("오라클 연결 실패");
}

CallableStatement cstmt = myConn.prepareCall("{call InsertEnroll(?,?,?,?)}");
cstmt.setString(1, s_id);
cstmt.setString(2, c_id);
cstmt.setInt(3, c_id_no);
cstmt.registerOutParameter(4, java.sql.Types.VARCHAR);
try{
	cstmt.execute();
	result = cstmt.getString(4); %>
	<script>
	alert("<%=result %>");
	location.href = "insert.jsp";
	</script>
<%}catch(SQLException ex){
	System.err.println("SQLException: " + ex.getMessage());
}finally{
	if(cstmt != null)
		try{myConn.commit(); cstmt.close(); myConn.close();
		}catch(SQLException ex){}
}
%>
</body>
</html>