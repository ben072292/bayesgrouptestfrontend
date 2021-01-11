<%@page import="edu.cwru.poset.covid19web.*" %>
<%@page import="java.util.*" %>
<%@page import="java.util.Map.*" %>

<%
String myText = request.getParameter("sampleSize");
ArrayList<String> arr = new ArrayList<>();
out.println(arr.size());
Pair<String, String> p = new Pair<>("caobi", "niubi");
out.println(p.getFirst());
out.println(p.getSecond());
out.println(Utility.generateDilutionMatrix(5, 0.99, 0.005));
%>
