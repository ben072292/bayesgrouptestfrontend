<%@page import="edu.cwru.poset.covid19web.*" %>
<%@page import="java.util.*" %>
<%@page import="java.util.Map.*" %>

<% 
session.invalidate();
out.println("<meta http-equiv='Refresh' content=3;url='index.jsp'>");
%>

<html>
<head><title>First JSP</title></head>

<body>
  <h3> Session is invalidated! Redirect to configuration page in 3 seconds... Or click <a href='index.jsp'>here</a> to manually redirect </h3>
</body>
</html>