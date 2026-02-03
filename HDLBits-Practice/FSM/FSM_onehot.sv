module top_module(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2);

  //   always @(*)
  //   begin
  //     if(state[0])
  //     begin
  //       if(in)
  //         next_state[1] = 1;
  //       else
  //         next_state[0] = 1;
  //     end
  //     if(state[1])
  //     begin
  //       if(in)
  //         next_state[2] = 1;
  //       else
  //         next_state[0] = 1;
  //     end
  //     if(state[2])
  //     begin
  //       if(in)
  //         next_state[3] = 1;
  //       else
  //         next_state[0] = 1;
  //     end
  //     if(state[3])
  //     begin
  //       if(in)
  //         next_state[4] = 1;
  //       else
  //         next_state[0] = 1;
  //     end
  //     if(state[4])
  //     begin
  //       if(in)
  //         next_state[5] = 1;
  //       else
  //         next_state[0] = 1;
  //     end
  //     if(state[5])
  //     begin
  //       if(in)
  //         next_state[6] = 1;
  //       else
  //         next_state[8] = 1;
  //     end
  //     if(state[6])
  //     begin
  //       if(in)
  //         next_state[7] = 1;
  //       else
  //         next_state[9] = 1;
  //     end
  //     if(state[7])
  //     begin
  //       if(in)
  //         next_state[7] = 1;
  //       else
  //         next_state[0] = 1;
  //     end
  //     if(state[8])
  //     begin
  //       if(in)
  //         next_state[1] = 1;
  //       else
  //         next_state[0] = 1;
  //     end
  //     if(state[9])
  //     begin
  //       if(in)
  //         next_state[1] = 1;
  //       else
  //         next_state[0] = 1;
  //     end
  //   end
  assign next_state = {state[6]&(!in),
                       state[5]&(!in),
                       (state[7]&in)|(state[6]&in),
                       state[5]&in,
                       state[4]&in,
                       state[3]&in,
                       state[2]&in,
                       state[1]&in,
                       (state[0]&in)|((state[8]|state[9])&in),
                       state[0]&(~in)|((state[1]|state[2]|state[3]|state[4]|state[7]|state[8]|state[9])&(~in))
                      };


  assign out1 = (state[8] || state[9]);
  assign out2 = (state[9] || state[7]);

endmodule
