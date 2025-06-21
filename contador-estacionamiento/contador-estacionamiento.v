module contador_estacionamiento(
    input wire clk,
    input wire reset,
    input wire auto_entra,
    input wire auto_sale,
    output reg [2:0] count,     // 3 bits 
    output lleno,
    output vacio
);

assign lleno = (count == 3'b111);
assign vacio = (count == 3'b000);

always @(posedge clk or posedge reset) 
begin
    if (reset)
        count <= 0;
    else begin
        if (auto_entra && !lleno)
            count <= count + 1;
        else if (auto_sale && !vacio)
            count <= count - 1;
    end
end

endmodule
