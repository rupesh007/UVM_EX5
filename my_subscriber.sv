import uvm_pkg::*;
import alu_pkg::*;
`include "uvm_macros.svh"

class my_subscriber extends uvm_subscriber#( alu_transaction );
  `uvm_component_utils( my_subscriber )
  
  int unsigned covered; 
  int unsigned total;
  real pct;
  
  int opc, op1, op2, shift;
  
  
  covergroup int_coverage;
    coverpoint opc{
        bins op_code [16] = {};
        //bins zero = {0};
//        bins i1t5 = {[1:5]};
//        bins i6t10 = {[6:10]};
//        bins i10t15 = {[10:15]};
//        bins rest = default;
        
     }
    coverpoint op1{
          bins opr_1[256]={};
        //bins zero = {0};
//        bins i1t10 = {[1:10]};
//        bins i11t100 = {[11:100]};
//        bins i101t200 = {[101:200]};
//        bins rest = default;
       
      } 
    coverpoint op2{
      //bins opr_2[256]= {};
        bins zero = {0};
        bins i1t10 = {[1:10]};
        bins i11t50 = {[11:50]};
        bins i51t100 = {[51:100]};
        bins i101t150 = {[101:150]};
        bins i151t200 = {[151:200]};
        bins i201t255 = {[201:255]};
        //bins rest = default;
        
      } 
    coverpoint shift{
          //bins shi [8] = {};
        bins zero = {0};
        bins i1t5 = {[1:5]};
        bins i5t7 = {[5:7]};
        bins rest = default;
      } 
  endgroup: int_coverage
 
  
  function new( string name , uvm_component parent);
    super.new( name , parent );
      int_coverage = new();
  endfunction
  
  function void write(alu_transaction t);
    
    opc = t.op_code;
    op1 = t.operand_1;
    op2 = t.operand_2;
    shift = t.shift_rotate; 
    
//coverage collection procedurally, this method can be alternatively used as sensitive to event
    int_coverage.sample();
    //$display("Coverage:",int_coverage.get_coverage());
  endfunction

  function void report_phase( uvm_phase phase );
    pct = int_coverage.get_coverage(covered, total); 
    $display("REQ Coverage: covered = %0d, total = %0d (%5.2f%%)", covered, total , pct);
  endfunction
  
endclass: my_subscriber
 
