`timescale 1ns / 1ps
`default_nettype none
`define DUMPSTR(x) `"x.vcd`"

module top_estacionamiento_tb;

    reg clk, reset;
    reg btnA, btnB;
    wire [3:0] leds;

    top_estacionamiento dut (
        .clk(clk),
        .reset(reset),
        .btnA(btnA),
        .btnB(btnB),
        .leds(leds)
    );

    // Clock de 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Simulación de entrada de auto (btnA → ambos → btnB → sueltan)
    task auto_entrando;
    begin
        btnA = 0; btnB = 1; #10;
        btnA = 0; btnB = 0; #10;
        btnA = 1; btnB = 0; #10;
        btnA = 1; btnB = 1; #10;
    end
    endtask

    // Simulación de salida de auto (btnB → ambos → btnA → sueltan)
    task auto_saliendo;
    begin
        btnA = 1; btnB = 0; #10;
        btnA = 0; btnB = 0; #10;
        btnA = 0; btnB = 1; #10;
        btnA = 1; btnB = 1; #10;
    end
    endtask

    // Simulación de persona (pisa A o B, no pisa ambos, suelta)
    task persona_pasando_E;
    begin
        btnA = 0; btnB = 1; #10;
        btnA = 1; btnB = 1; #10;
        #10;
    end
    endtask

    task persona_pasando_S;
    begin
        btnA = 1; btnB = 0; #10;
        btnA = 1; btnB = 1; #10;
        #10;
    end
    endtask

    initial begin
        $dumpfile("top-module_tb.vcd");
        $dumpvars(0, top_estacionamiento_tb);

        // Inicialización   |   La logica de los botones es al revez
        btnA = 1; btnB = 1; reset = 0; #10;
        reset = 1;

        // Auto entra (contador = 1)
        auto_entrando();

        // Persona pasa primero por sensor A
        persona_pasando_E();

        // (contador = 2)
        auto_entrando();

        // Autos sale (contador = 0)
        repeat (2) auto_saliendo(); 

        // 7 autos entran (para ver LED "lleno")
        repeat (7) auto_entrando();

        // Auto más entra (no debería contar más)
        auto_entrando();

        // Auto sale (contador = 6)
        auto_saliendo();

        // Persona pasa primero por sensor B
        persona_pasando_S();

        // (contador = 3)
        repeat (3) auto_saliendo();

        // Finalizacion
        #30; 
        btnA = 1; btnB = 1; reset = 0;

        #30;
        $finish;
    end

endmodule
