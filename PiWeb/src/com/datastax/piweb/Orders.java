package com.datastax.piweb;

public class Orders {
	private String status;
	private int total_orders = 0;
	private int total_customers = 0;
	private int total_products = 0;
	private double total_revenue = 0;
	private double total_profit = 0;
	
	public Orders(String status){
		this.setStatus(status);
	}
	
	public void updateMetrics(int orders, int customers, int products, double revenue, double profit){
		total_orders += orders;
		total_customers += customers;
		total_products += products;
		total_revenue += revenue;
		total_profit += profit;
	}
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public int getTotal_orders() {
		return total_orders;
	}
	public void setTotal_orders(int total_orders) {
		this.total_orders = total_orders;
	}
	public int getTotal_customers() {
		return total_customers;
	}
	public void setTotal_customers(int total_customers) {
		this.total_customers = total_customers;
	}
	public int getTotal_products() {
		return total_products;
	}
	public void setTotal_products(int total_products) {
		this.total_products = total_products;
	}
	public double getTotal_revenue() {
		return total_revenue;
	}
	public void setTotal_revenue(double total_revenue) {
		this.total_revenue = total_revenue;
	}
	public double getTotal_profit() {
		return total_profit;
	}
	public void setTotal_profit(double total_profit) {
		this.total_profit = total_profit;
	}

}
