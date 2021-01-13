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
String outputPath = "temp/" + session.getId() + "/output.txt";
try {
  outStream = new PrintStream(new FileOutputStream("/opt/tomcat/latest/webapps/bayesgrouptest/temp/" + session.getId() + "/output.txt"));
  System.setOut(outStream);
} catch (FileNotFoundException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
String filePath = "/opt/tomcat/latest/webapps/bayesgrouptest/temp/" + session.getId() + "/config.txt";
String s[] = request.getParameterValues("simulation_type");
List<String> list = Arrays.asList(s);    
int regularStage = Integer.parseInt(request.getParameter("regular_stage"));
int kNumber = Integer.parseInt(request.getParameter("k_number")); 
int kStage = Integer.parseInt(request.getParameter("k_stage"));
int individualStage = Integer.parseInt(request.getParameter("individual_stage"));
double upSetProbabilityThreshold = Double.parseDouble(request.getParameter("error_threshold"));
PosetModel.UPSETTHRESHOLD = upSetProbabilityThreshold;
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
ArrayList<Double> atomsUpsetProbabilities = new ArrayList<>();
for(String atom : p.getAtoms()){
  atomsUpsetProbabilities.add(p.getUpSetProbabilityMass(atom));
}
if(p.allAtomsMeetThreshold(atomsUpsetProbabilities, upSetProbabilityThreshold)){
  System.out.println("There is no need to perform simulation, as all subjects can be confidently classified based on their current up-set probability masses.");
}
else{
  // configure spark
  SparkConf sparkConf = new SparkConf().setAppName(session.getId()).setMaster("local[4]")
          .set("spark.executor.memory", "2g").set("spark.driver.allowMultipleContexts", "true");;
  JavaSparkContext sc = JavaSparkContext.fromSparkContext(SparkContext.getOrCreate(sparkConf));
  
  if(list.contains("regular")){
      SimulationSpark.regularHalvingAlgorithmSimulationSparkFast(sc, new PosetModel(p, PosetModel.COMPLETE_COPY_WITHOUT_REDUCING), regularStage, upSetProbabilityThreshold,branchProbabilityThreshold);
  }
  if(list.contains("k-lookahead")){
      SimulationSpark.kLookaheadHalvingAlgorithmSimulationSparkFast(sc, new PosetModel(p, PosetModel.COMPLETE_COPY_WITHOUT_REDUCING), kNumber, kStage, upSetProbabilityThreshold,branchProbabilityThreshold);
  }
  if(list.contains("individual")){
      if(p.isHeterogeneous()){
          SimulationSpark.individualTestingSimulationSpark(sc, new PosetModel(p, PosetModel.COMPLETE_COPY_WITHOUT_REDUCING), individualStage, upSetProbabilityThreshold, branchProbabilityThreshold);
      }
      else{
          SimulationSpark.individualTestingSimulationSparkSymmetric(sc, new PosetModel(p, PosetModel.COMPLETE_COPY_WITHOUT_REDUCING), individualStage, upSetProbabilityThreshold,branchProbabilityThreshold);
      }
  }
  
  sc.close();
}
%>

<form method="get" action="<%= outputPath %>">
   <button type="submit">Show Simulation Result</button>
</form>

</body>
</html>