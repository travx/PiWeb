package com.datastax.piweb;


import java.util.Random;

import com.datastax.driver.core.Cluster;
import com.datastax.driver.core.PreparedStatement;
import com.datastax.driver.core.ResultSet;
import com.datastax.driver.core.Session;
import com.datastax.driver.core.Cluster.Builder;
import com.datastax.driver.core.policies.RoundRobinPolicy;
import com.google.gson.Gson;


public class DataStaxCluster {
	private String node;
	private String keyspace;
	private Cluster cluster;
	private Session session;
	
	//Order Metrics
	private OrderMetrics om;
	
	//prepared statements and queries
	private PreparedStatement psOrders;
	
	public DataStaxCluster(String node, String keyspace){
		setNode(node);
		setKeyspace(keyspace);
				
		connect();
		prepare();
		
		om = new OrderMetrics();
	}
	
	public void connect() {
		Builder builder = Cluster.builder().withLoadBalancingPolicy(new RoundRobinPolicy());
		builder.addContactPoints(node);
		cluster = builder.build();
		session = cluster.connect(keyspace);
	}
	
	public void prepare(){
		psOrders = session.prepare("insert into orders(status, total_orders, total_customers, total_products, total_revenue, total_profit) values(?, ?, ?, ?, ?, ?);");
	}	
	
	public String UpdateMetrics(){
		Random r = new Random();
		
		int orders = r.nextInt(10) + 1;
		int customers = r.nextInt(orders) + 1;
		int products = r.nextInt(orders) + orders;
		
		double revenue = (r.nextDouble() + .1) * 100 * products;
		double profit = .3 * (r.nextDouble()+.01) * revenue;
		
		om.setKnownHosts(session.getCluster().getMetrics().getKnownHosts().getValue());
		om.setConnectedToHosts(session.getCluster().getMetrics().getConnectedToHosts().getValue());
		om.setOrders(orders);
				
		Orders o = om.getMetrics().get(om.getHostsUp());
		o.updateMetrics(orders, customers, products, revenue, profit);
		
		om.incrementDatacenter(writeOrders(o));
		
		return new Gson().toJson(om);
	}
	
	private String writeOrders(Orders o){
		ResultSet rs = session.execute(psOrders.bind(o.getStatus(), o.getTotal_orders(), o.getTotal_customers(), o.getTotal_products(), o.getTotal_revenue(), o.getTotal_profit()));
		return rs.getExecutionInfo().getQueriedHost().getDatacenter();
	}
	
	public String getNode() {
		return node;
	}
	public void setNode(String node) {
		this.node = node;
	}
	public String getKeyspace() {
		return keyspace;
	}
	public void setKeyspace(String keyspace) {
		this.keyspace = keyspace;
	}
	public Cluster getCluster() {
		return cluster;
	}
	public void setCluster(Cluster cluster) {
		this.cluster = cluster;
	}
	public Session getSession() {
		return session;
	}
	public void setSession(Session session) {
		this.session = session;
	}
	
}
