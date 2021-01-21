<%@page import="edu.cwru.poset.covid19web.*, org.apache.spark.SparkConf, org.apache.spark.api.java.JavaSparkContext, org.apache.spark.SparkContext" %>
<%@page import="java.util.*,java.io.*" %>
<%@page import="java.util.Map.*" %>

<html>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<head><title>Simulation Summary</title></head>
<body>
  <h3> Session <%=session.getId()%><br><br>Simulation is finished!</h3>
<% 
PrintStream outStream;
String outputPath = "temp/" + session.getId() + "/output.csv";
try {
  outStream = new PrintStream(new FileOutputStream("/opt/tomcat/latest/webapps/bayesgrouptest/temp/" + session.getId() + "/output.csv"));
  System.setOut(outStream);
} catch (FileNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
String filePath = "/opt/tomcat/latest/webapps/bayesgrouptest/temp/" + session.getId() + "/config.txt";
String s[] = request.getParameterValues("simulation_type");
List<String> list = Arrays.asList(s);    
int regularStage = Integer.parseInt(request.getParameter("regular_stage"));
double regularTime = Double.parseDouble(request.getParameter("regular_time"));
int kNumber = Integer.parseInt(request.getParameter("k_number")); 
int kStage = Integer.parseInt(request.getParameter("k_stage"));
double kTime = Double.parseDouble(request.getParameter("k_time"));
int individualStage = Integer.parseInt(request.getParameter("individual_stage"));
double upsetThresholdUp = Double.parseDouble(request.getParameter("negative_error_threshold"));
double upsetThresholdLo = Double.parseDouble(request.getParameter("positive_error_threshold"));
double branchProbabilityThreshold = 0.001;
/*
for(int i = 0; i < s.length; i++){
    out.println(s[i]);
}
out.println(regularStage);
out.println(kNumber);
out.println(kStage);
out.println(individualStage);
out.println("<meta http-equiv='Refresh' content=10;url='poset.jsp'>");
*/
ConfigurationParser cp = new ConfigurationParser(filePath);
ArrayList<ArrayList<String>> cpExperiments = cp.getExperiments();
ArrayList<Integer> cpExperimentOutcomes = cp.getExperimentOutcomes();
PosetModel p = new PosetModel(cp.getAtoms(), cp.getpi0());
p.setDilutionMatrix(cp.getDilutionMatrix());
for(int i = 0; i < cpExperiments.size(); i++){
  p.updatePosteriorProbability(cpExperiments.get(i), cpExperimentOutcomes.get(i));
}

// Before simulation, check whether it's needed to perform simulation.
if(p.allAtomsMeetThreshold(upsetThresholdUp, upsetThresholdLo)){
  System.out.println("There is no need to perform simulation, as all subjects can be confidently classified based on their current up-set probability masses.");
}
else{
  // configure spark
  SparkConf sparkConf = new SparkConf().setAppName(session.getId()).setMaster("local[4]")
          .set("spark.executor.memory", "2g").set("spark.driver.allowMultipleContexts", "true");;
  JavaSparkContext sc = JavaSparkContext.fromSparkContext(SparkContext.getOrCreate(sparkConf));
  
  if(list.contains("regular")){
      SimulationSpark.regularHalvingAlgorithmSimulationSparkWithTimer(sc, new PosetModel(p, PosetModel.COMPLETE_COPY_WITHOUT_REDUCING), regularStage, upsetThresholdUp, upsetThresholdLo, branchProbabilityThreshold, regularTime);
  }
  if(list.contains("k-lookahead")){
      SimulationSpark.kLookaheadHalvingAlgorithmSimulationSparkWithTimer(sc, new PosetModel(p, PosetModel.COMPLETE_COPY_WITHOUT_REDUCING), kNumber, kStage, upsetThresholdUp, upsetThresholdLo, branchProbabilityThreshold, kTime);
  }
  if(list.contains("individual")){
      if(p.isHeterogeneous()){
          SimulationSpark.individualTestingSimulationSpark(sc, new PosetModel(p, PosetModel.COMPLETE_COPY_WITHOUT_REDUCING), individualStage, upsetThresholdUp, upsetThresholdLo, branchProbabilityThreshold);
      }
      else{
          SimulationSpark.individualTestingSimulationSparkSymmetric(sc, new PosetModel(p, PosetModel.COMPLETE_COPY_WITHOUT_REDUCING), individualStage, upsetThresholdUp, upsetThresholdLo, branchProbabilityThreshold);
      }
  }
  
  sc.close();
}
String filename = "Simulation_Result_" + session.getId();
%>

<a href="<%= outputPath %>" download="<%= filename %>">
    <button type="button">Download Simulation Result</button> 
</a> 

</body>
</html>