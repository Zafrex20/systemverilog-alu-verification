module test (
    vif_if vif
);
  // =================== DPI FUNCTIONS ==================== //
  //  import "DPI-C" function real ref_model(real initial_value);

  // ================== GLOBAL VARIABLES ================== //

  //  import config_pkg::*;

  // =================== MAIN SEQUENCE ==================== //

  initial begin
    // Initial values
    $display("Begin Of Simulation.");
    //   get_config_args();

    fork
      // Monitor
      monitor_output();
    join_none
    // Apply reset
    reset();


    fork
      // Stimulus
      send_data_port();
    join_any
    
    // Drain time
    #(20ns);
    $display("End Of Simulation at %0t.", $realtime);
    $finish;
  end


  // ======================= TASKS ======================== //

  task automatic reset();

    //for adder 
    vif.x_i     = 16'b0;
    vif.y_i     = 16'b0;

    vif.zx_i = 1'b0;
    vif.nx_i = 1'b0;
    vif.zy_i = 1'b0;
    vif.ny_i = 1'b0;
    vif.f_i  = 1'b0;
    vif.no_i = 1'b0;
    
    vif.rst_i   = 1'b1;
    repeat (5) @(vif.cb);
    vif.rst_i   = 1'b0;
  endtask : reset


  task automatic send_data_port();
    //Initial Values
    for (int i = 0; i < 5; i++) begin
      @(vif.cb);
      vif.cb.x_i <= $urandom_range(0, 15);
      vif.cb.y_i <= $urandom_range(0, 15);
      vif.cb.zx_i <= '0;
      vif.cb.nx_i <= '0;
      vif.cb.zy_i <= '0;
      vif.cb.ny_i <= '0;
      vif.cb.f_i  <= '1;
      vif.cb.no_i <= '0;
      //vif.cb.carry_i <= $urandom_range(0, 1);
    end
  endtask : send_data_port


  task automatic monitor_output();
    forever begin
      @(vif.cb);
      $display(
          "[INFO:Gate SUmador]: %8t:,Rst = %d, X = %d, Y = %d, OUT = %d",
          $realtime, vif.rst_i, vif.x_i, vif.y_i, vif.out_o);
    end
  endtask : monitor_output



endmodule : test
