<%@ page contentType="text/html; charset=EUC-KR" %>
<!DOCTYPE html>
<html>
<head><link href="style.css" rel="stylesheet" type="text/css"> 
<meta charset="UTF-8"> <title>수강신청 시스템 로그인</title> </head>
<body>
<br><br>
<table  class="top2" width="70%" align="center" border>
<tr> <td><div align="center">아이디와 패스워드를 입력하세요 </div></td></table>
<table width="70%" align="center" border>
<form method="post" action="login_verify.jsp">
<tr>
<td><div>아이디</div></td>
<td><div>
<input type="text" name="userID">
</div></td>
</tr>
<tr>
<td><div>패스워드</div></td>
<td><div>
<input type="password" name="userPassword">
</div></td></tr>
<tr>
<td colspan=2><div align="center">
<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="로그인"> <INPUT
TYPE="RESET" VALUE="취소">
</div></td></tr>
</form>
</table>
</body>
</html>