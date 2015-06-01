<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Real-time Dashboard</title>

<script type="text/javascript" src="scripts/jchartfx/js/jchartfx.system.js"></script>
<script type="text/javascript" src="scripts/jchartfx/js/jchartfx.coreVector.js"></script>
<script type="text/javascript" src="scripts/jchartfx/js/jchartfx.animation.js"></script>
<script type="text/javascript" src="scripts/jchartfx/js/jchartfx.advanced.js"></script>
<script type="text/javascript" src="scripts/jchartfx/js/jchartfx.gauge.js"></script>
<script type="text/javascript" src="scripts/jchartfx/motifs/jchartfx.motif.topbar.js"></script>

<script src="scripts/jquery-latest.min.js"></script>  

<script type="text/javascript">

var chartDC, radialOrders
var borderUp, borderDown, borderAvailable;
var trendOrders, trendCustomers, trendProducts, trendRevenue, trendProfit;

function initialize() {
    chartDC = new cfx.Chart();
    radialOrders = new cfx.gauge.RadialGauge();
    borderUp = new cfx.gauge.Border();
    borderDown = new cfx.gauge.Border();  
    borderAvailable = new cfx.gauge.Border();  
    trendOrders = new cfx.gauge.Trend();
    trendCustomers = new cfx.gauge.Trend();
    trendProducts = new cfx.gauge.Trend();
    trendRevenue = new cfx.gauge.Trend();
    trendProfit = new cfx.gauge.Trend();

    chartDC.create('divChartDC');
    radialOrders.create('divRadialOrders');
    borderUp.create('divBorderUp');
    borderDown.create('divBorderDown');
    borderAvailable.create('divBorderAvailable');
    trendOrders.create('divTrendOrders');
    trendCustomers.create('divTrendCustomers');
    trendProducts.create('divTrendProducts');
    trendRevenue.create('divTrendRevenue');
    trendProfit.create('divTrendProfit');
    
    title = new cfx.gauge.Title();
    title.setText("Nodes Up");
    borderUp.getTitles().add(title);

    title = new cfx.gauge.Title();
    title.setText("Nodes Down");
    borderDown.getTitles().add(title); 
    
    title = new cfx.gauge.Title();
    title.setText("Availability");
    borderAvailable.getTitles().add(title);    
    
    chartDC.setGallery(cfx.Gallery.Pie);
    
    title = new cfx.TitleDockable();
    title.setText("Datacenter Activity");
    chartDC.getTitles().add(title);        
    
    var mainScale = radialOrders.getMainScale();
    mainScale.setMax(10);
    
    var sections = radialOrders.getMainScale().getSections();
    
    var section = new cfx.gauge.ScaleSection();
    section.setFrom(0);
    section.setTo(2);
    sections.add(section);    
    
    var section = new cfx.gauge.ScaleSection();
    section.setFrom(2);
    section.setTo(8);
    sections.add(section); 
    
    var section = new cfx.gauge.ScaleSection();
    section.setFrom(8);
    section.setTo(10);
    sections.add(section);    

    var title = new cfx.gauge.Title();
    //title.setText("Order Rate");
    title.setText("Available Beds");
    radialOrders.getTitles().clear();
    radialOrders.getTitles().add(title);   
    
    var title = new cfx.gauge.Title();
    //title.setText("Total Orders");
    title.setText("Total Procedures");
    trendOrders.getTitles().add(title);   
    
    var title = new cfx.gauge.Title();
    //title.setText("Total Customers");
    title.setText("Total Patients");
    trendCustomers.getTitles().add(title);       

    var title = new cfx.gauge.Title();
    //title.setText("Total Products");
    title.setText("Patient Metrics Collected");
    trendProducts.getTitles().add(title);  

    var title = new cfx.gauge.Title();
    //title.setText("Total Revenue");
    title.setText("Charges");
    trendRevenue.getTitles().add(title);
    
    var title = new cfx.gauge.Title();
    //title.setText("Total Profit");
    title.setText("Medicaid Billed");
    trendProfit.getTitles().add(title);      
}

function get_data(){
    $.getJSON('OrderServlet', function(data) {
    	//chart_test.setDataSource(data.metrics);
    	$('#divTextUp').text(data.connectedToHosts);
    	$('#divTextDown').text(data.knownHosts-data.connectedToHosts);
    	
    	if (data.connectedToHosts>0){
    		$('#divTextAvailable').text("100%");
    	}
    	
    	else {
    		$('#divTextAvailable').text("---%");
    	}
    	
    	chartDC.setDataSource(data.datacenters);
    	radialOrders.setMainValue(data.orders);
    	
        trendOrders.getCurrent().setValue(data.metrics[0].total_orders + data.metrics[1].total_orders);
        trendOrders.getReference().setValue(data.metrics[1].total_orders);
        
        trendCustomers.getCurrent().setValue(data.metrics[0].total_customers + data.metrics[1].total_customers);
        trendCustomers.getReference().setValue(data.metrics[1].total_customers);       
        
        trendProducts.getCurrent().setValue(data.metrics[0].total_products + data.metrics[1].total_products);
        trendProducts.getReference().setValue(data.metrics[1].total_products);  
        
        trendRevenue.getCurrent().setValue(data.metrics[0].total_revenue + data.metrics[1].total_revenue);
        trendRevenue.getReference().setValue(data.metrics[1].total_revenue);  
        
        trendProfit.getCurrent().setValue(data.metrics[0].total_profit + data.metrics[1].total_profit);
        trendProfit.getReference().setValue(data.metrics[1].total_profit);          
    }); 	
}

setInterval(function(){get_data();}, 2000);

// class="jchartfx_body"

</script>

<link rel="stylesheet" type="text/css" href="scripts/jchartfx/styles/Attributes/jchartfx.attributes.topbar.css" />
<link rel="stylesheet" type="text/css" href="scripts/jchartfx/styles/Palettes/jchartfx.palette.aurora.css" />

  
</head>
<body onload="initialize()">
<table width="800"><tr>
<td><img src="images/logo.png"></td>
<td align="right" valign="middle"><h2>Hospital Management Dashboard &nbsp;<img src="images/doctor.png"></h2></td>
</tr></table>

<hr>

<div class="jchartfx_container">

	<div id="myDash" style="width:800px;height:450px;display:inline-block;position:relative">
            <div id="divBorderUp" style="width:240px;height:100px;display:inline-block;position:absolute;left:0px;top:0px"></div>
            <div id="divTextUp" class="labelIndicator" style="width:240px;height:100px;display:inline-block;position:absolute;left:0px;top:0px">0</div>
            <div id="divBorderDown" style="width:240px;height:100px;display:inline-block;position:absolute;left:250px;top:0px"></div>
            <div id="divTextDown" class="labelIndicator" style="width:240px;height:100px;display:inline-block;position:absolute;left:250px;top:0px">0</div>
            <div id="divBorderAvailable" style="width:240px;height:100px;display:inline-block;position:absolute;left:500px;top:0px"></div>
            <div id="divTextAvailable" class="labelIndicator" style="width:240px;height:100px;display:inline-block;position:absolute;left:500px;top:0px">---%</div>
            
            <div id="divTrendOrders" style="width:240px;height:160px;display:inline-block;position:absolute;left:0px;top:110px"></div>
            <div id="divTrendCustomers" style="width:240px;height:160px;display:inline-block;position:absolute;left:250px;top:110px"></div>
            <div id="divTrendProducts" style="width:240px;height:160px;display:inline-block;position:absolute;left:500px;top:110px"></div>

            <div id="divTrendRevenue" style="width:365px;height:160px;display:inline-block;position:absolute;left:0px;top:280px"></div>
            <div id="divTrendProfit" style="width:365px;height:160px;display:inline-block;position:absolute;left:375px;top:280px"></div>
                        
            <div id="divRadialOrders" style="width:240px;height:215px;display:inline-block;position:absolute;left:750px;top:0px"></div>
            <div id="divChartDC" style="width:240px;height:215px;display:inline-block;position:absolute;left:750px;top:225px"></div>
            
    </div>

</div>	

</body>
</html>