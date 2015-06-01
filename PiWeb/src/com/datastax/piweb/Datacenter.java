package com.datastax.piweb;

public class Datacenter {
	private String name;
	private int load=1;
	
	public Datacenter(String name){
		this.setName(name);
	}
	
	public int incrementLoad(String name){
		if (name.equalsIgnoreCase(this.name)){
			this.load++;
			return 1;
		}
		return 0;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getLoad() {
		return load;
	}
	public void setLoad(int load) {
		this.load = load;
	}
}
