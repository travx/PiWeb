package com.datastax.piweb;

import java.util.ArrayList;
import java.util.List;


public class OrderMetrics {
	
	private int knownHosts = 1;
	private int connectedToHosts = 1;
	private int orders = 0;
	
	//Track Datacenter activity
	private List<Datacenter> datacenters = new ArrayList<Datacenter>();
	
	//Objects for tracking orders	
	private List<Orders> metrics = new ArrayList<Orders>();
	
	public OrderMetrics(){
		metrics.add(new Orders("Down"));
		metrics.add(new Orders("Up"));
	}
	
	public void incrementDatacenter(String name){
		int success=0;
		for (Datacenter dc : datacenters){
			success = success + dc.incrementLoad(name);
		}
		
		if (success==0){
			datacenters.add(new Datacenter(name));
		}
	}
	
	public List<Orders> getMetrics(){
		return metrics;
	}
	
	public int getHostsUp(){
		return (int) Math.floor(connectedToHosts/knownHosts);
	}

	public int getKnownHosts() {
		return knownHosts;
	}

	public void setKnownHosts(int knownHosts) {
		this.knownHosts = knownHosts;
	}

	public int getConnectedToHosts() {
		return connectedToHosts;
	}

	public void setConnectedToHosts(int connectedToHosts) {
		this.connectedToHosts = connectedToHosts;
	}

	public int getOrders() {
		return orders;
	}
	
	public List<Datacenter> getDatacenters() {
		return datacenters;
	}	

	public void setOrders(int orders) {
		this.orders = orders;
	}
}
