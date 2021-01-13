<%@page import="edu.cwru.poset.covid19web.*" %>
<%@page import="java.util.*,java.io.*" %>
<%@page import="java.util.Map.*" %>

<% 
String filePath = "/opt/tomcat/latest/webapps/bayesgrouptest/temp/" + session.getId() + "/config.txt";
String data = "\n" + request.getParameter("new_node") + request.getParameter("response");
byte[] bytesArray = data.getBytes();
File source = new File(filePath);
File dest = new File(filePath+"txt");
InputStream is = null;
OutputStream os = null;
try {
    is = new FileInputStream(source);
    os = new FileOutputStream(dest);
    byte[] buffer = new byte[1024];
    int length;
    while ((length = is.read(buffer)) > 0) {
        os.write(buffer, 0, length);
    }
    os.write(bytesArray);
} finally {
    is.close();
    os.close();
}
boolean success = dest.renameTo(source);
out.println("<meta http-equiv='Refresh' content=3;url='poset.jsp'>");
%>

<html>
<head><title>Processing...</title></head>

<body>
  <h3> Processing new experiment... Please wait... </h3>
</body>
</html>