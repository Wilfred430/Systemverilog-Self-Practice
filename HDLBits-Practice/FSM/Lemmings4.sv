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

  parameter LEFT = 0,RIGHT = 1,FALL = 2,DIG = 3,SPLATTER = 4;

  reg [2:0] state,next_state;
  reg [2:0] pre_direction;
  integer count;

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
        // Counting more than 20 cycles & hit the ground.
        next_state = (count >= 20 && ground)?SPLATTER:((ground)? pre_direction : FALL);
      DIG:
        next_state = (ground)? DIG : FALL;
      SPLATTER:
      begin
        next_state = SPLATTER;
      end
      default:
        next_state = LEFT;
    endcase
  end

  // mentain
  always @(posedge clk, posedge areset)
  begin
    if(areset)
    begin
      state <= LEFT;
      count <= 8'h00;
    end
    else
    begin
      state <= next_state;
      if(state == LEFT || state == RIGHT)
        pre_direction <= state;  // 記住最後的方向
      if(state == FALL)
        count <= count + 1;
      else
        count <= 8'h00;
    end
  end

  // mentain
  assign walk_left = (state == LEFT);
  assign walk_right = (state == RIGHT);
  assign aaah = (state == FALL);
  assign digging = (state == DIG);

endmodule
