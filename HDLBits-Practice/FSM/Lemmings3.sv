module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging );

  parameter LEFT = 0,RIGHT = 1,FALL = 2,DIG = 3;

  reg [1:0] state,next_state;
  reg [1:0] pre_direction;

  always @(*)
  begin
    case(state)
      LEFT:
      begin
        if(ground)
        begin
          if(dig)
          begin
            next_state = DIG;
          end
          else
          begin
            if(bump_left)
              next_state = RIGHT;
            else
              next_state = LEFT;
          end
        end
        else
        begin
          next_state = FALL;
        end
      end
      RIGHT:
      begin
        if(ground)
        begin
          if(dig)
          begin
            next_state = DIG;
          end
          else
          begin
            if(bump_right)
              next_state = LEFT;
            else
              next_state = RIGHT;
          end
        end
        else
        begin
          next_state = FALL;
        end
      end
      FALL:
        next_state = (ground)? pre_direction : FALL;
      DIG:
        next_state = (ground)? DIG : FALL;
      default:
        next_state = LEFT;
    endcase
  end

  // mentain
  always @(posedge clk, posedge areset)
  begin
    if(areset)
      state <= LEFT;
    else
    begin
      state <= next_state;
      if(state == LEFT || state == RIGHT)
        pre_direction <= state;  // 記住最後的方向
    end
  end

  // mentain
  assign walk_left = (state == LEFT);
  assign walk_right = (state == RIGHT);
  assign aaah = (state == FALL);
  assign digging = (state == DIG);

endmodule
