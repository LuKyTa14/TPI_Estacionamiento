`default_nettype none
`timescale 1ns / 1ps
`define DUMPSTR(x) `"x.vcd`"

module fsm_sensores_tb;

    reg clk, reset, a, b;
    wire auto_entra, auto_sale, persona;

    fsm_sensores uut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .auto_entra(auto_entra),
        .auto_sale(auto_sale),
        .persona(persona)
    );

    // Reloj: 10ns de período
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Tarea: auto entra correctamente (A1 → A2 → A3 → IDLE)
    task paso_auto_entrada;
    begin
        $display("Auto entra");
        a = 1; b = 0; #10;  // A1
        a = 1; b = 1; #10;  // A2
        a = 0; b = 1; #10;  // A3
        a = 0; b = 0; #10;  // IDLE (se detecta auto_entra)
    end
    endtask

    // Tarea: auto sale correctamente (B1 → B2 → B3 → IDLE)
    task paso_auto_salida;
    begin
        $display("Auto sale");
        a = 0; b = 1; #10;  // B1
        a = 1; b = 1; #10;  // B2
        a = 1; b = 0; #10;  // B3
        a = 0; b = 0; #10;  // IDLE (se detecta auto_sale)
    end
    endtask

    // Tarea: persona intenta entrar pero no completa el paso
    task persona_entrada;
    begin
        $display("Persona entra");
        a = 1; b = 0; #10;  // A1
        a = 1; b = 1; #10;  // A2
        a = 0; b = 0; #10;  // -> P (se detecta persona)
        a = 0; b = 0; #10;  // vuelve a IDLE
    end
    endtask

    // Tarea: persona intenta salir pero no completa el paso
    task persona_salida;
    begin
        $display("Persona sale");
        a = 0; b = 1; #10;  // B1
        a = 1; b = 1; #10;  // B2
        a = 0; b = 0; #10;  // -> P (se detecta persona)
        a = 0; b = 0; #10;  // vuelve a IDLE
    end
    endtask

    initial begin
        $dumpfile("fsm-sensores_tb.vcd");
        $dumpvars(0, fsm_sensores_tb);

        a = 0; b = 0; reset = 1; #10;
        reset = 0;

        // 1. Auto entra correctamente
        paso_auto_entrada();

        // 2. Persona intenta entrar (incompleta)
        persona_entrada();

        // 3. Auto sale correctamente
        paso_auto_salida();

        // 4. Persona intenta salir (incompleta)
        persona_salida();

        #20;
        $finish;
    end

endmodule
