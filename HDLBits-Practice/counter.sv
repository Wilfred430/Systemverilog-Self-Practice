// counter.sv
`timescale 1ns/1ps

module counter (
    input  logic       clk,
    input  logic       rst_n,  // Active low reset
    output logic [3:0] count
);

    // 這裡就是硬體行為：正緣觸發，非同步重置
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'd0;
        end else begin
            count <= count + 1'b1;
        end
    end

    // --- 波形錄製設定 (為了讓你看見結果) ---
    initial begin
        $dumpfile("counter.vcd"); // 產生的檔案名稱
        $dumpvars(0, counter);    // 記錄這個模組內的所有訊號
    end

endmodule