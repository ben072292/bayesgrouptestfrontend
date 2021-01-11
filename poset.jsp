<%@page import="edu.cwru.poset.covid19web.*, org.apache.spark.SparkConf, org.apache.spark.api.java.JavaSparkContext" %>
<%@page import="java.util.*" %>
<%@page import="java.util.Map.*" %>


<html>
<head><title>First JSP</title></head>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<body>
  <div id="title" style="width:100%;height:10%;text-align:center;border:1px solid black">
    <h1>Poset Model For Covid 19</h1>
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
    <button id="havling_algorithm"; onclick="halvingAlgorithm()"><h3>Perform Halving Algorithm</h3></button>
  </div>
</body>

<!-- Initialize Java POSET object -->
<%
    String filePath = "/opt/tomcat/latest/webapps/bayesgrouptest/temp/" + session.getId() + "/config.txt";
    ConfigurationParser cp = new ConfigurationParser(filePath);
    PosetModel.UPSETTHRESHOLD = 0.01;
    PosetModel p = new PosetModel(cp.getAtoms(), cp.getpi0());
    p.setDilutionMatrix(cp.getDilutionMatrix());
    HashMap<ArrayList<String>, ArrayList<ArrayList<String>>> tree = WebUtility.generateTreeStructure(p);
    double upSetProbabilityThreshold = 0.01;
    double branchProbabilityThreshold = 0.001;

    JavaSparkContext sc;
    // configure spark
    SparkConf sparkConf = new SparkConf().setAppName("Simulation").setMaster("local[4]")
        .set("spark.executor.memory", "2g");
    sc = new JavaSparkContext(sparkConf);

    SimulationSpark.regularHalvingAlgorithmSimulationSparkFast(sc, p, 4, upSetProbabilityThreshold,branchProbabilityThreshold);

    sc.close();
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
   HashMap<ArrayList<String>, Integer> color = WebUtility.sortByValue(p.getPosteriorProbabilityMap());
   double[] Y = new double[p.getAtoms().size()+1];
   for(ArrayList<String> arr : p.getE()){
    Y[arr.size()]-=0.5;
   }
   for(ArrayList<String> arr : p.getE()) { 
      String name = "";
      for(String s: arr){
        name += s + ",";
      }
%>
   var order = <%= color.get(arr) %>;
   g.nodes.push({
     id: '<%=arr.toString()%>',
     label: '<%=arr.toString()%>',
     x: <%=Y[arr.size()]%>,
     y: <%=p.getAtoms().size()+1 - arr.size()%>,
     size: 5,
     color: hslToHex(240 * (1-order/N), 100, 50),
     type: order === N ? 'image' : 'def',
     url : order === N ? urls[0] : null,
     probability: '<%=p.getPosteriorProbabilityMap().get(arr)%>',
     uplowsets: '<%=WebUtility.showUpSetOnWeb(p, arr)%>',
     name: '<%= name %>'
   });

<% Y[arr.size()]+=1; 
} %>

<% for(Entry<ArrayList<String>, ArrayList<ArrayList<String>>> t : tree.entrySet()) {
    for(ArrayList<String> arr : t.getValue()){ %>
      g.edges.push({
        id: '<%=t.getKey().toString() + arr.toString()%>',
        source: '<%=t.getKey().toString()%>',
        target: '<%=arr.toString()%>',
        "type": "arrow",
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
        s.bind('overNode clickNode doubleClickNode rightClickNode', function(e) {
          console.log(e.type, e.data.node.label, e.data.captor, e.data.node.color);
          
          var stat = "Node: " + e.data.node.label + "<br>" + e.data.node.probability + "<br>" + e.data.node.uplowsets;
          
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

function halvingAlgorithm(){
  <% p.halvingAlgorithm(); %>
  // Draw Graph
var i,
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
   color = PosetModel.sortByValue(p.getPosteriorProbabilityMap());
   Y = new double[p.getAtoms().size()+1];
   for(ArrayList<String> arr : p.getE()){
    Y[arr.size()]-=0.5;
   }
   for(ArrayList<String> arr : p.getE()) { 
      String name = "";
      for(String s: arr){
        name += s + ",";
      }
%>
   var order = <%= color.get(arr) %>;
   g.nodes.push({
     id: '<%=arr.toString()%>',
     label: '<%=arr.toString()%>',
     x: <%=Y[arr.size()]%>,
     y: <%=p.getAtoms().size()+1 - arr.size()%>,
     size: 5,
     color: hslToHex(240 * (1-order/N), 100, 50),
     type: order === N ? 'image' : 'def',
     url : order === N ? urls[0] : null,
     probability: '<%=p.getPosteriorProbabilityMap().get(arr)%>',
     uplowsets: '<%=p.showUpAndLowSetsOnWeb(arr)%>',
     name: '<%= name %>'
   });

<% Y[arr.size()]+=1; 
} %>

<% for(Entry<ArrayList<String>, ArrayList<ArrayList<String>>> t : tree.entrySet()) {
    for(ArrayList<String> arr : t.getValue()){ %>
      g.edges.push({
        id: '<%=t.getKey().toString() + arr.toString()%>',
        source: '<%=t.getKey().toString()%>',
        target: '<%=arr.toString()%>',
        "type": "arrow",
        size: 1,
        color: '#0000ff',
        hover_color: '#00ff00'
      });
<%  }
   } %>

clear_refresh_graph();
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
        s.bind('overNode clickNode doubleClickNode rightClickNode', function(e) {
          console.log(e.type, e.data.node.label, e.data.captor, e.data.node.color);
          
          var stat = "Node: " + e.data.node.label + "<br>" + e.data.node.probability + "<br>" + e.data.node.uplowsets;
          
          document.getElementById("node-info").innerHTML = stat;
        });
        
        $(document).ready(function() {
          document.getElementById("poset-summary").innerHTML = '<%= p.toStringWeb() %>';
        });
      });
    });
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