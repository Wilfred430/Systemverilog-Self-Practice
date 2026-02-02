module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
  );
  parameter S1 = 0, S2 = 1, S3 = 2, S4 = 3;
  reg [1:0] state, next_state;
  reg DDfr;

  // 狀態轉換：只允許逐級上升或下降
  always @(*)
  begin
    case (state)
      S1:
        next_state = s[1] ? S2 : S1;
      S2:
        next_state = s[1] ? (s[2] ? S3 : S2) : S1;
      S3:
        next_state = s[2] ? (s[3] ? S4 : S3) : S2;
      S4:
        next_state = s[3] ? S4 : S3;
      default:
        next_state = S1;
    endcase
  end

  always @(posedge clk)
  begin
    if (reset)
    begin
      state <= S1;
      DDfr <= 0;
    end
    else
    begin
      state <= next_state;
      if(state==next_state)
        DDfr<=DDfr;
      else if(state> next_state)
        DDfr<=0;
      else if(state<next_state)
        DDfr<=1;
    end
  end

  // 輸出：fr1/fr2/fr3 表示水位是否低於該感測器
  assign fr1 = (state < S4);  // S1,S2,S3 時為 1
  assign fr2 = (state < S3);  // S1,S2 時為 1
  assign fr3 = (state < S2);  // S1 時為 1
  assign dfr = (DDfr)?0:1;

endmodule
