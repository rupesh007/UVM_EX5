import uvm_pkg::*;
import alu_pkg::*;
import agent_pkg::*;

`include "uvm_macros.svh"
class alu_agent extends uvm_agent;
	//UVM Factory Registration Macro
	`uvm_component_utils (alu_agent)
	
	uvm_analysis_port # (alu_transaction) ag_port; 
	
	
	// Data members
	
	agent_config a_config;
	alu_config b_config;
	virtual alu_if agent_if;
	
	// component members
	
	alu_sequencer a_sequencer;
	alu_driver    a_driver;
	agent_monitor   a_monitor;
	
	//constructor
	function new (string name, uvm_component parent);
		super.new(name,parent);
  endfunction
	
	//uvm build_phase
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		ag_port=new("ag_port",this); //no overriding for the port
	//	a_config = alu_config::type_id::create("alu_config",this);
		if (! uvm_config_db # (agent_config)::get(this,"","env_agent_config",a_config))
		 `uvm_fatal("alu_agent error", "can't locate agent_config");
 	    //a_monitor = alu_monitor::type_id::create("a_monitor",this);
 	    
		if (a_config.active==UVM_ACTIVE) begin
		  a_sequencer = alu_sequencer::type_id::create("a_sequencer",this);
		  a_driver = alu_driver::type_id::create("a_driver",this);
		  a_monitor = agent_monitor::type_id::create("a_monitor",this);
    end
	endfunction
	
	//uvm connect_phase
	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		//ag_port.connect(a_monitor.am_port);
		ag_port=a_monitor.am_port;
		//ag_port.connect(a_driver.dport);
	  //a_driver.d_port.connect(ag_port);
		agent_if = a_config.a_interface;
		  if(a_config.active==UVM_ACTIVE) begin // connects driver and sequencer in active agent
			    a_driver.seq_item_port.connect(a_sequencer.seq_item_export);
			   // ag_port.connect(a_driver.dport);
			end
	endfunction
	
	
	endclass
	
	
	
	