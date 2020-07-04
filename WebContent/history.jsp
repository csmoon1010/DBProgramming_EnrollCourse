<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"  %>
<html><head><link href="style.css" rel="stylesheet" type="text/css">
<title>개별수강 이력</title></head>
<body>
<%@ include file="top.jsp" %>
<%   if (session_id==null) response.sendRedirect("login.jsp");  %>
<br><br><br>
<table width="70%" align="center" border>
<br>
<tr><th>수업번호</th><th>과목명</th><th>학년도</th><th>학기</th>
      <th>학점</th></tr>
<%
   Connection myConn = null;      
   Statement stmt = null;   
   ResultSet myResultSet = null;
   String mySQL = "";
   int totalnum = 0; int totalnum2 = 0;
   
   String dbdriver = "oracle.jdbc.OracleDriver";
   String dburl="jdbc:oracle:thin:@localhost:1521:orcl";
   String user="db1713462";
   String passwd="ss2";

   try {
      Class.forName(dbdriver);
            myConn =  DriverManager.getConnection (dburl, user, passwd);
      stmt = myConn.createStatement();   
    } catch(SQLException ex) {
        System.err.println("SQLException: " + ex.getMessage());
    }
   
   mySQL = "select h.c_id, c.c_name, substr(h.h_sem, 1, 4) h_year, substr(h.h_sem, -1) h_term, h.h_score FROM history h, course c where h.c_id = c.c_id and h.c_id_no = c.c_id_no and s_id = '" + session_id + "'";
   
   myResultSet = stmt.executeQuery(mySQL); 

   if (myResultSet != null) {
      while (myResultSet.next()) {   
         String c_id = myResultSet.getString("c_id");   
         String c_name = myResultSet.getString("c_name");
         int h_year = myResultSet.getInt("h_year");
         int h_term = myResultSet.getInt("h_term");
         String h_score = myResultSet.getString("h_score");
         
    CallableStatement cstmt = myConn.prepareCall("{call MajorCount(?,?,?)}");
    cstmt.setString(1, session_id);
    cstmt.registerOutParameter(2, java.sql.Types.INTEGER);
    cstmt.registerOutParameter(3, java.sql.Types.INTEGER);
    try {
    	cstmt.execute();
        totalnum = cstmt.getInt(2);
        totalnum2 = cstmt.getInt(3);
        %>
        <%
    } catch(SQLException ex) {
        System.err.println("SQLException: " + ex.getMessage());
    }

   %>
   <tr>
     <td><%= c_id %></td>
     <td><%= c_name %></td>
     <td><%= h_year %></td>
     <td><%= h_term %></td>
     <td><%= h_score %></td>
     
   </tr>
   <%
         }
      }
      stmt.close();  myConn.close();
   %>
   </table>
   <br><br>
   <div id = "CountInfo" align="center" style="font-weight: bold;">총 전공 :  <%=totalnum%>학점   &nbsp;&nbsp;&nbsp;  총 교양  :  <%=totalnum2%>학점</div>
   </body></html>
