`include "../flip-flop-D/flip-flop-D.v"

module fsm_sensores(
    input wire clk,
    input wire reset,
    input wire a,        // sensor a
    input wire b,        // sensor b
    output reg auto_entra,
    output reg auto_sale,
    output reg persona
);

/*
Dos secuencias:
    Entrada: 000 → 001 → 010 → 011 → 000     (si pasa por A primero)
    Salida: 000 → 101 → 110 → 111 → 000      (si pasa por B primero)
*/
    wire E0, E1, E2;
    wire E0_sig, E1_sig, E2_sig;
    
    assign estado = {E0, E1, E2};

    assign E0 = (E0 & (a & ~E1 & E2) | ((E2 | b) & ~a & ~E0 & ~E1));
    assign E1 = a | b;
    assign E2 = a ^ b;

    always @(posedge clk) begin
        auto_entra = (~a & ~b & ~E0 & E1 & E2);
        auto_sale = (~a & ~b & E0 & E1 & E2);
        persona = (~a & ~b & ~E0 & ~E1 & E2) | (~a & ~b & E0 & ~E1 & E2); 
    end

    flip_flop_D ffE0(.clk(clk), .reset(reset), .D(E0_sig), .Q(E0));
    flip_flop_D ffE1(.clk(clk), .reset(reset), .D(E1_sig), .Q(E1));
    flip_flop_D ffE2(.clk(clk), .reset(reset), .D(E2_sig), .Q(E2));

endmodule