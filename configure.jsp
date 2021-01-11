<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Configuration File Upload</title>
</head>
<body>
<h1> Welcome To Covid-19 Poset Model Web Interface </h1>
<h3> Your Session ID: <%= session.getId() %> </h3>
<h3> Select Configuration File To Upload: </h3><br />
<form action="action_file_upload.jsp" method="post"
                        enctype="multipart/form-data">
<input type="file" name="config_file" size="50" />
<br />
<input type="submit" value="Upload Files" />
</form>
</body>
</html>

<%@ page import = "java.io.*,java.util.*, javax.servlet.*" %>
<%
String path = "/opt/tomcat/latest/webapps/bayesgrouptest/temp/" + session.getId() + "/";
File file = new File(path);
//Creating the directory
boolean bool = file.mkdir();
if(bool){
   System.out.println("Directory created successfully");
}else{
   System.out.println("Sorry couldn’t create specified directory");
}
%>