<%@page import="java.util.*,java.io.*" %>
<%@page import="java.nio.charset.StandardCharsets" %>
<%@ page import = "org.apache.commons.io.output.*" %>
<%
try {
  int BUFFER_LENGTH = 1024;

  File file = new File("/opt/homebrew/Cellar/tomcat/9.0.43/libexec/webapps/bayesgrouptest/temp/" + session.getId() + "/output.csv");
  InputStream input = new FileInputStream(file);

  response.setContentType("text/plain;charset=UTF-8");
  response.setHeader("Content-Disposition", "attachment;filename=" + "Simulation_Result_" + session.getId() + ".csv");
  
  PrintWriter output = response.getWriter();

  byte[] bytes = new byte[BUFFER_LENGTH];
  int read = 0;
  while(read != -1) {
    read = input.read(bytes, 0, BUFFER_LENGTH);
    if(read != -1) {
      String line = new String(bytes, StandardCharsets.UTF_8);
      output.println(line);
    }
  }
} catch (FileNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }

%>

