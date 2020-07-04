<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<html><head><title>수강신청 삭제 </title></head>
<body>

<%
String s_id = (String)session.getAttribute("user");
String c_id = request.getParameter("c_id");
int c_id_no = Integer.parseInt(request.getParameter("c_id_no"));
%>
<%
Connection myConn = null; ResultSet result = null;
PreparedStatement pstmt = null;
String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
String user="db1713462"; String passwd="ss2";
String dbdriver = "oracle.jdbc.driver.OracleDriver";

try {
Class.forName(dbdriver);
myConn = DriverManager.getConnection (dburl, user, passwd);
} catch(SQLException ex) {
System.err.println("SQLException: " + ex.getMessage());
}
try {
String sql = "select c_id, c_id_no from enroll where c_id = ?";
pstmt = myConn.prepareStatement(sql);
pstmt.setString(1, c_id);
result = pstmt.executeQuery();

if(result.next()){
	String id = result.getString("c_id");
	String id_no = result.getString("c_id_no");
	
	if(c_id.equals(id)){
		sql = "delete from enroll where c_id = ?";
		pstmt = myConn.prepareStatement(sql);
		pstmt.setString(1, c_id);
		pstmt.executeUpdate();
		%>
		<script>
		alert("해당 과목 수강신청을 취소하였습니다.");
		location.href="delete.jsp";
		</script>

		<%
		
	}else{
		%>
		<script>
		alert("수강신청 취소 오류.");
		location.href="delete.jsp";
		</script>

		<%
	}
	}else{
		%>
		<script>
		alert("수강신청 취소 오류.");
		location.href="delete.jsp";
		</script>

		<%
	
	}


} catch(SQLException ex) {
System.err.println("SQLException: " + ex.getMessage());
}
finally {
if (result != null)
try { myConn.commit(); pstmt.close(); myConn.close(); }
catch(SQLException ex) { }
}
%>
</body></html>