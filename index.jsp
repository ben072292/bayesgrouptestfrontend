<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Bayesian Goup Testing Web Tool For Covid-19</title>
</head>
<body>
<h1>Bayesian Goup Testing Web Tool For Covid-19</h1>
<%

String tutorialPath = "doc/tutorial.txt";
String javadocPath = "doc/doc/index.html";
String configTemplatePath = "doc/config.txt";

%>

<h2> Your Session ID: <%= session.getId() %> </h2>
<h3> Useful Information:</h3>
<a href = "<%= tutorialPath %>">How to use this web tool</a>
<br>
<a href = "<%= javadocPath %>">View develop doc</a>
<br>
<a href = "<%= configTemplatePath %>" download>Download</a> a configuration file template
<h3> Select Configuration File To Upload: </h3><br />
<form action="action_file_upload.jsp" method="post"
                        enctype="multipart/form-data" onsubmit="return checkFileExist()">
<input type="file" name="config_file" id="config_file" size="50" />
<br />
<input type="submit" value="Upload Files"/>
</form>
</body>
</html>

<script>
	function checkFileExist(){
		if ($('#config_file').get(0).files.length === 0) {
    		alert("Please upload a configuration file");
    		return false;
		}
		return true;
	}
</script>

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