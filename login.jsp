<!DOCTYPE html>
<html>
	<head>
		<%@ page import = " java.util.*, java.sql.*, java.io.* " %>
		<title>Login</title>
	</head>
	<body>
		<%
			if ( request.getMethod().equals("POST") ){
				try{
					String username = request.getParameter("username");
					String password = request.getParameter("password");
					Properties properties = new Properties();
					properties.load(application.getResourceAsStream("app.config"));
					String DB_DATABASE = properties.getProperty("DB_DATABASE");
					String DB_USERNAME = properties.getProperty("DB_USERNAME");
					String DB_PASSWORD = properties.getProperty("DB_PASSWORD");
					String sql = String.format("SELECT PASSWORD('%s') AS hashword FROM dual", password);
					Connection conn = DriverManager.getConnection(DB_DATABASE, DB_USERNAME, DB_PASSWORD);
					Statement stmt = conn.createStatement();
					ResultSet rs = stmt.executeQuery(sql);
					if ( rs.next() ){
						sql = String.format("SELECT user FROM user WHERE user = '%s' AND password = '%s'", username, rs.getString("hashword"));
						rs = stmt.executeQuery(sql);
						if ( rs.next() ){
							session.setAttribute("username", rs.getString("user"));
							out.println(session.getAttribute("username"));
						}
					}
				}catch(Exception e){
					out.println(e.getMessage());
				}
			}else{
		%>
			<form action="login.jsp" method="post">
				<table>
					<tr><td>Username :</td><td><input type="text" name="username"/></td></tr>
					<tr><td>Password: </td><td><input type="password" name="password"/></td></tr>
					<tr><td colspan="2"><input type="submit" value="login"/></td></tr>
				</table>
			</form>
		<%
			}
		%>
	</body>
</html>
