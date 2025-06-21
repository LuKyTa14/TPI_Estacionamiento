`default_nettype none
`timescale 1ns / 1ps
`define DUMPSTR(x) `"x.vcd`"

module contador_estacionamiento_tb;

    reg clk;
    reg reset;
    reg auto_entra;
    reg auto_sale;
    wire [2:0] count;
    wire lleno;
    wire vacio;

    contador_estacionamiento UUT (
        .clk(clk),
        .reset(reset),
        .auto_entra(auto_entra),
        .auto_sale(auto_sale),
        .count(count),
        .lleno(lleno),
        .vacio(vacio)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("contador-estacionamiento_tb.vcd");
        $dumpvars(0, contador_estacionamiento_tb);

        reset = 1; auto_entra = 0; auto_sale = 0;
        #10;
        reset = 0;

        // Autos entran
        repeat (8) begin
            auto_entra = 1; auto_sale = 0;
            #10;
        end

        // Intentar entrar cuando esta lleno
        auto_entra = 1; auto_sale = 0;
        #20;

        // Autos salen
        repeat (8) begin
            auto_entra = 0; auto_sale = 1;
            #10;
        end

        // Intentar salir cuando esta vacio
        auto_entra = 0; auto_sale = 1;
        #10;

        reset = 1; auto_sale = 0;
        #10;
        reset = 0;
        #10;
        

        $finish;
    end

endmodule