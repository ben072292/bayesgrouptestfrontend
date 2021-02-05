<%@page import="edu.cwru.poset.covid19web.*" %>
<%@page import="java.util.*, java.io.*" %>
<%@page import="java.util.Map.*" %>


<html>
<head><title>Lattice Model Illustration</title></head>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<body>
  <div id="title" style="width:100%;height:10%;text-align:center;border:1px solid black">
    <h1>Lattice Model For Covid 19</h1>
  </div>
  <div id="graph-container" style="float:left;width:80%;height:60%;border:1px solid black"></div>
  <div id="node-info-container" style="float:right;width:19.7%;height:60%;overflow-y:auto;border:1px solid black">
    <h3> Node Information </h3>
    <div id="node-info"></div>
  </div>

  <div id="poset-summary" style="float:left;width:80%;height:30%;overflow-y:auto;border:1px solid black"></div>
  <div id="link-panel" style="float:right;width:19.7%;height:30%;overflow-y:auto;border:1px solid black">
    <h3> Quick Tool: </h3>
    <a id="startover" href="startover.jsp"><h3>Load New Configuration</h3></a>
    <a id="reload" href="<%= request.getRequestURI() %>"><h3>Reset Graph</h3></a>
    <button id="add_experiment"; onclick="addExperiment()"><h3>Select New Experiment</h3></button>
    <button id="simulation"; onclick="simulation()"><h3>Start Group Testing Simulations</h3></button>
  </div>
</body>

<!-- Initialize Java POSET object -->
<%
    //String filePath = "/opt/tomcat/latest/webapps/bayesgrouptest/temp/" + session.getId() + "/config.txt";
    String filePath = "/opt/homebrew/Cellar/tomcat/9.0.43/libexec/webapps/bayesgrouptest/temp/" + session.getId() + "/config.txt";
    ConfigurationParser cp = new ConfigurationParser(filePath);
    ArrayList<ArrayList<String>> cpExperiments = cp.getExperiments();
    ArrayList<Integer> cpExperimentOutcomes = cp.getExperimentOutcomes();
    PosetModel p = new PosetModel(cp.getAtoms(), cp.getpi0());
    p.setDilutionMatrix(cp.getDilutionMatrix());
    for(int i = 0; i < cpExperiments.size(); i++){
      p.updatePosteriorProbability(cpExperiments.get(i), cpExperimentOutcomes.get(i));
    }
    HashMap<ArrayList<String>, ArrayList<ArrayList<String>>> tree = WebUtility.generateTreeStructure(p);
%>


<!-- START SIGMA IMPORTS -->
<script src="sigmajs/src/sigma.core.js"></script>
<script src="sigmajs/src/conrad.js"></script>
<script src="sigmajs/src/utils/sigma.utils.js"></script>
<script src="sigmajs/src/utils/sigma.polyfills.js"></script>
<script src="sigmajs/src/sigma.settings.js"></script>
<script src="sigmajs/src/classes/sigma.classes.dispatcher.js"></script>
<script src="sigmajs/src/classes/sigma.classes.configurable.js"></script>
<script src="sigmajs/src/classes/sigma.classes.graph.js"></script>
<script src="sigmajs/src/classes/sigma.classes.camera.js"></script>
<script src="sigmajs/src/classes/sigma.classes.quad.js"></script>
<script src="sigmajs/src/classes/sigma.classes.edgequad.js"></script>
<script src="sigmajs/src/captors/sigma.captors.mouse.js"></script>
<script src="sigmajs/src/captors/sigma.captors.touch.js"></script>
<script src="sigmajs/src/renderers/sigma.renderers.canvas.js"></script>
<script src="sigmajs/src/renderers/sigma.renderers.webgl.js"></script>
<script src="sigmajs/src/renderers/sigma.renderers.svg.js"></script>
<script src="sigmajs/src/renderers/sigma.renderers.def.js"></script>
<script src="sigmajs/src/renderers/webgl/sigma.webgl.nodes.def.js"></script>
<script src="sigmajs/src/renderers/webgl/sigma.webgl.nodes.fast.js"></script>
<script src="sigmajs/src/renderers/webgl/sigma.webgl.edges.def.js"></script>
<script src="sigmajs/src/renderers/webgl/sigma.webgl.edges.fast.js"></script>
<script src="sigmajs/src/renderers/webgl/sigma.webgl.edges.arrow.js"></script>
<script src="sigmajs/src/renderers/canvas/sigma.canvas.labels.def.js"></script>
<script src="sigmajs/src/renderers/canvas/sigma.canvas.hovers.def.js"></script>
<script src="sigmajs/src/renderers/canvas/sigma.canvas.nodes.def.js"></script>
<script src="sigmajs/src/renderers/canvas/sigma.canvas.edges.def.js"></script>
<script src="sigmajs/src/renderers/canvas/sigma.canvas.edges.curve.js"></script>
<script src="sigmajs/src/renderers/canvas/sigma.canvas.edges.arrow.js"></script>
<script src="sigmajs/src/renderers/canvas/sigma.canvas.edges.curvedArrow.js"></script>
<script src="sigmajs/src/renderers/canvas/sigma.canvas.edgehovers.def.js"></script>
<script src="sigmajs/src/renderers/canvas/sigma.canvas.edgehovers.curve.js"></script>
<script src="sigmajs/src/renderers/canvas/sigma.canvas.edgehovers.arrow.js"></script>
<script src="sigmajs/src/renderers/canvas/sigma.canvas.edgehovers.curvedArrow.js"></script>
<script src="sigmajs/src/renderers/canvas/sigma.canvas.extremities.def.js"></script>
<script src="sigmajs/src/renderers/svg/sigma.svg.utils.js"></script>
<script src="sigmajs/src/renderers/svg/sigma.svg.nodes.def.js"></script>
<script src="sigmajs/src/renderers/svg/sigma.svg.edges.def.js"></script>
<script src="sigmajs/src/renderers/svg/sigma.svg.edges.curve.js"></script>
<script src="sigmajs/src/renderers/svg/sigma.svg.labels.def.js"></script>
<script src="sigmajs/src/renderers/svg/sigma.svg.hovers.def.js"></script>
<script src="sigmajs/src/middlewares/sigma.middlewares.rescale.js"></script>
<script src="sigmajs/src/middlewares/sigma.middlewares.copy.js"></script>
<script src="sigmajs/src/misc/sigma.misc.animation.js"></script>
<script src="sigmajs/src/misc/sigma.misc.bindEvents.js"></script>
<script src="sigmajs/src/misc/sigma.misc.bindDOMEvents.js"></script>
<script src="sigmajs/src/misc/sigma.misc.drawHovers.js"></script>
<script src="sigmajs/plugins/sigma.plugins.dragNodes/sigma.plugins.dragNodes.js"></script>


<script>
/* Codes to enable loading customized nodes */
sigma.utils.pkg('sigma.canvas.nodes');
sigma.canvas.nodes.image = (function() {
  var _cache = {},
      _loading = {},
      _callbacks = {};

  // Return the renderer itself:
  var renderer = function(node, context, settings) {
    var args = arguments,
        prefix = settings('prefix') || '',
        size = node[prefix + 'size'],
        color = node.color || settings('defaultNodeColor'),
        url = node.url;

    if (_cache[url]) {
      context.save();

      // Draw the clipping disc:
      context.beginPath();
      context.arc(
        node[prefix + 'x'],
        node[prefix + 'y'],
        node[prefix + 'size'],
        0,
        Math.PI * 2,
        true
      );
      context.closePath();
      context.clip();

      // Draw the image
      context.drawImage(
        _cache[url],
        node[prefix + 'x'] - size,
        node[prefix + 'y'] - size,
        2 * size,
        2 * size
      );

      // Quit the "clipping mode":
      context.restore();

      // Draw the border:
      context.beginPath();
      context.arc(
        node[prefix + 'x'],
        node[prefix + 'y'],
        node[prefix + 'size'],
        0,
        Math.PI * 2,
        true
      );
      context.lineWidth = size / 5;
      context.strokeStyle = node.color || settings('defaultNodeColor');
      context.stroke();
    } else {
      sigma.canvas.nodes.image.cache(url);
      sigma.canvas.nodes.def.apply(
        sigma.canvas.nodes,
        args
      );
    }
  };

  // Add a public method to cache images, to make it possible to
  // preload images before the initial rendering:
  renderer.cache = function(url, callback) {
    if (callback)
      _callbacks[url] = callback;

    if (_loading[url])
      return;

    var img = new Image();

    img.onload = function() {
      _loading[url] = false;
      _cache[url] = img;

      if (_callbacks[url]) {
        _callbacks[url].call(this, img);
        delete _callbacks[url];
      }
    };

    _loading[url] = true;
    img.src = url;
  };

  return renderer;
})();

// Draw Graph
var i,
    s,
    N = <%=p.getE().size()%>;
    g = {
      nodes: [],
      edges: []
    },
    urls = [
      'images/top.png'
    ],
    loaded = 0;
<% 
   /* Sort by probability mass */
   //HashMap<ArrayList<String>, Double> ProbabilityMass = p.calculatePosteriorMass();
   //HashMap<ArrayList<String>, Integer> color = WebUtility.sortByValue(ProbabilityMass);
   HashMap<ArrayList<String>, Integer> color = WebUtility.sortByValue(p.getPosteriorProbabilityMap());
   double[] Y = new double[p.getAtoms().size()+1];
   for(ArrayList<String> arr : p.getE()){
    Y[arr.size()]-=0.5;
   }
   for(ArrayList<String> arr : p.getE()) { 
      String name = "";
      String label = "";
      for(String s: arr){
        name += s + ",";
        label += s;
      }
      if(label.length() == 0){
        label = "0";
      }
%>
      var order = <%= color.get(arr) %>;
      g.nodes.push({
        id: '<%=arr.toString()%>',
        label: '<%=label%>',
        x: <%=Y[arr.size()]%>,
        y: <%=p.getAtoms().size()+1 - arr.size()%>,
        size: 5,
        color: hslToHex(240 * (1-order/N), 100, 50),
        type: '<%=arr.toString()%>' === '<%=p.findMinToPointFive().toString()%>' ? 'image' : 'def',
        url : '<%=arr.toString()%>' === '<%=p.findMinToPointFive().toString()%>' ? urls[0] : null,
        probability: '<%=p.getPosteriorProbabilityMap().get(arr)%>',
        uplowsets: '<%=WebUtility.showUpSetOnWeb(p, arr)%>',
        name: '<%= name %>'
      });

<%    Y[arr.size()]+=1; 
   } %>

<% for(Entry<ArrayList<String>, ArrayList<ArrayList<String>>> t : tree.entrySet()) {
    for(ArrayList<String> arr : t.getValue()){ %>
      g.edges.push({
        id: '<%=t.getKey().toString() + arr.toString()%>',
        source: '<%=t.getKey().toString()%>',
        target: '<%=arr.toString()%>',
        // "type": "arrow",
        size: 1,
        color: '#0000ff',
        hover_color: '#00ff00'
      });
<%  }
   } %>

// Instantiate sigma:
urls.forEach(function(url) {
  sigma.canvas.nodes.image.cache(
    url,
    function() {
      if (++loaded === urls.length)
        // Instantiate sigma:
        s = new sigma({
          graph: g,
          renderer: {
          container: 'graph-container',
          type: 'canvas'
         },
         settings: {
          minNodeSize: 8,
          maxNodeSize: 16,
          minArrowSize: 10,
          doubleClickEnabled: false,
          minEdgeSize: 0.5,
          maxEdgeSize: 2,
          enableEdgeHovering: true,
          edgeHoverColor: 'edge',
          edgeHoverSizeRatio: 2,
          edgeHoverExtremities: true
         }
        });

        // Initialize the dragNodes plugin:
        var dragListener = sigma.plugins.dragNodes(s, s.renderers[0]);
        dragListener.bind('startdrag', function(event) {
          console.log(event);
        });
        dragListener.bind('drag', function(event) {
          console.log(event);
        });
        dragListener.bind('drop', function(event) {
          console.log(event);
        });
        dragListener.bind('dragend', function(event) {
          console.log(event);
        });
        
        // Ajax calls to dynamically display node information
        s.bind('overNode clickNode rightClickNode', function(e) {
          console.log(e.type, e.data.node.label, e.data.captor, e.data.node.color);
          
          var stat = "Node: " + e.data.node.label + "<br>Probability: " + e.data.node.probability + "<br>" + e.data.node.uplowsets;
          
          document.getElementById("node-info").innerHTML = stat;
        });
        
        $(document).ready(function() {
          document.getElementById("poset-summary").innerHTML = '<%= p.toStringWeb() %>';
        });
      });
    });

// Helper functions
function componentToHex(c) {
  var hex = c.toString(16);
  return hex.length == 1 ? "0" + hex : hex;
}

function rgbToHex(r, g, b) {
  return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}

function hslToHex(h, s, l) {
  h /= 360;
  s /= 100;
  l /= 100;
  let r, g, b;
  if (s === 0) {
    r = g = b = l; // achromatic
  } else {
    const hue2rgb = (p, q, t) => {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1 / 6) return p + (q - p) * 6 * t;
      if (t < 1 / 2) return q;
      if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    };
    const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    const p = 2 * l - q;
    r = hue2rgb(p, q, h + 1 / 3);
    g = hue2rgb(p, q, h);
    b = hue2rgb(p, q, h - 1 / 3);
  }
  const toHex = x => {
    const hex = Math.round(x * 255).toString(16);
    return hex.length === 1 ? '0' + hex : hex;
  };
  return "#" + toHex(r) + toHex(g) + toHex(b);
}


var temp = document.getElementById("link-panel").innerHTML;
function addExperiment() {
  var instruction = '<button id="add_experiment_back"; onclick="addExperimentBack()"><h3>Back</h3></button><br><br>Double click to select the node on the graph:<br><br>'
  document.getElementById("link-panel").innerHTML = instruction;
    s.bind('doubleClickNode', function(e) {
      document.getElementById("link-panel").innerHTML = instruction + 'Node selected:' + e.data.node.label + "<form action='addExperiment.jsp'><input type='hidden' id='new_node' name='new_node' value=" + e.data.node.name + "><label for='response'>Choose response:</label><select name='response' id='response'><option value='1'>All negative</option><option value='0'>Has positive</option></select><br><br><input type='submit' value='Submit'></form>";
    });
}

function simulation(){
  var instruction = '<button id="add_experiment_back"; onclick="addExperimentBack()"><h3>Back</h3></button><br><br>Please select simulation type:<br><form id="simulation_form" action="PerformSimulationServlet" onsubmit="return checkCheckboxSelected()"><input type="checkbox" id="regular" name="simulation_type" value="regular" onchange="regularCheckbox(this)"><label for="regular">Bayesian Havling</label><div id="regular_configure" style="display: none;"><br>Stage Number: <input type="text" id="regular_stage" name = "regular_stage" value="5"><br>Time Limit (s): <input type="text" id="regular_time" name = "regular_time" value="10"><br></div><br><input type="checkbox" id="k-lookahead" name="simulation_type" value="k-lookahead" onchange="kCheckbox(this)"><label for="k-lookahead">K-step lookahead</label><div id="k_configure" style="display: none;"><br>K: <input type="text" id="k_number" name = "k_number" value="2"><br>Stage Number: <input type="text" id="k_stage" name = "k_stage" value="5"><br>Time Limit (s): <input type="text" id="k_time" name = "k_time" value="10"><br></div><br><input type="checkbox" id="individual" name="simulation_type" value="individual" onchange="individualCheckbox(this)"><label for="individual">Individual Testing</label><div id="individual_configure" style="display: none;"><br>Stage Number: <input type="text" id="individual_stage" name = "individual_stage" value="5"><br></div><br><br>Negative Error Threshold: <input type="text" id="negative_error_threshold" name = "negative_error_threshold" value="0.005"><br><br>Positive Error Threshold: <input type="text" id="positive_error_threshold" name = "positive_error_threshold" value="0.01"><br><input name="submit" type="submit" value="Submit"></form>';
  document.getElementById("link-panel").innerHTML = instruction;

  $(document).ready(function() {
        $('#simulation_form').submit(function(event) {
                event.preventDefault();
                var $form = $(this);
                $.ajax({
                    url : 'PerformSimulationServlet',
                    data : $form.serialize(),
                    beforeSend: function(responseText){
                      $('#link-panel').html('<img src="images/loading.gif" style="width: 100%; height: 100%; object-fit: contain">');
                      window.onbeforeunload = function() {
                        return true;
                      }
                    },
                    success : function(responseText) {
                        $('#link-panel').html('<button id="add_experiment_back"; onclick="addExperimentBack()"><h3>Back</h3></button><br>' + responseText);
                        window.onbeforeunload = null;

                    }
                });
        });
});
}
   

function checkCheckboxSelected(){
  if(document.getElementById("regular").checked == false && document.getElementById("k-lookahead").checked == false && document.getElementById("individual").checked == false){
    alert("Please Select At Least One Simulation.");
    return false;
  }
  return true;
}

function regularCheckbox(element){
  if(element.checked == true){
    document.getElementById("regular_configure").style.display = "block";
  }
  else{
    document.getElementById("regular_configure").style.display = "none";
  }
}

function kCheckbox(element){
  if(element.checked == true){
    document.getElementById("k_configure").style.display = "block";
  }
  else{
    document.getElementById("k_configure").style.display = "none";
  }
}

function individualCheckbox(element){
  if(element.checked == true){
    document.getElementById("individual_configure").style.display = "block";
  }
  else{
    document.getElementById("individual_configure").style.display = "none";
  }
}

function clear_refresh_graph() {
    //this gets rid of all the ndoes and edges
    s.graph.clear();
    //this gets rid of any methods you've attached to s.
    s.refresh();
};

function addExperimentBack(){
  document.getElementById("link-panel").innerHTML = temp;
}


</script>
</html>