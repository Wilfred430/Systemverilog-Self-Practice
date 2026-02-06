module top_module(
    input  clk,
    input  load,
    input  [255:0] data,
    output reg [255:0] q
  );

  integer i;
  reg [255:0] next_q;

  // 計算某個 cell 的鄰居數
  function integer count_neighbors;
    input [255:0] grid;
    input integer row;
    input integer col;
    integer r, c;
    integer rr, cc;
    integer sum;
    begin
      sum = 0;
      for (r=-1; r<=1; r=r+1)
        for (c=-1; c<=1; c=c+1)
        begin
          if (!(r==0 && c==0))
          begin
            rr = (row + r + 16) % 16;
            cc = (col + c + 16) % 16;
            sum = sum + grid[rr*16 + cc];
          end
        end
      count_neighbors = sum;
    end
  endfunction

  // 根據規則決定下一狀態
  function next_state;
    input cur_state;       // 原本 cell 狀態
    input integer neighbors; // 鄰居數
    begin
      case(neighbors)
        2:
          next_state = cur_state; // 保持原狀
        3:
          next_state = 1'b1;      // 變成活
        default:
          next_state = 1'b0; // 其他情況死亡
      endcase
    end
  endfunction

  // 主 always block
  always @(posedge clk)
  begin
    if (load)
      q <= data;   // 載入初始狀態
    else
    begin
      for (i=0; i<256; i=i+1)
      begin
        integer row, col, neighbors;
        row = i / 16;
        col = i % 16;
        neighbors = count_neighbors(q, row, col);
        next_q[i] = next_state(q[i], neighbors);
      end
      q <= next_q;
    end
  end

endmodule
