module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah );

  parameter LEFT = 0,RIGHT = 1,FALL = 2;

  reg [1:0] state,next_state;
  wire [1:0] pre_direction;

  always @(*)
  begin
    case(state)
      LEFT:
      begin
        pre_direction = LEFT;
        next_state = (ground)?(bump_left?RIGHT:LEFT):FALL;
      end
      RIGHT:
      begin
        pre_direction = RIGHT;
        next_state = (ground)?(bump_right?LEFT:RIGHT):FALL;
      end
      FALL:
        next_state = (ground)? pre_direction : FALL;
      default:
        next_state = LEFT;
    endcase
  end

  always @(posedge clk, posedge areset)
  begin
    if(areset)
      state <= LEFT;
    else
      state <= next_state;
  end

  assign walk_left = (state == LEFT);
  assign walk_right = (state == RIGHT);
  assign aaah = (state == FALL);

endmodule
