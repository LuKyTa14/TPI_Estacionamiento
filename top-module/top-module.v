`include "../fsm-sensores/fsm-sensores.v"
`include "../contador-estacionamiento/contador-estacionamiento.v"

module top_estacionamiento(
    input wire clk,
    input wire reset,
    input wire btnA,        // Sensor A (botón físico)
    input wire btnB,        // Sensor B (botón físico)
    output wire [3:0] leds  // leds[3]=lleno, leds[2:0]=contador
);
    // vi algo de los botones logica de antirebote
    wire rts, A, B;
    assign rst = ~reset;
    assign A = ~btnA;
    assign B = ~btnB;
    
    wire auto_entra, auto_sale;
    wire [2:0] count;
    wire lleno, vacio;
    wire persona;           // usado internamente, pero no conectado a salida

    // FSM de sensores
    fsm_sensores fsm (
        .clk(clk),
        .reset(rst),
        .a(A),
        .b(B),
        .auto_entra(auto_entra),
        .auto_sale(auto_sale),
        .persona(persona)
    );

    // Contador de autos
    contador_estacionamiento contador (
        .clk(clk),
        .reset(rst),
        .auto_entra(auto_entra),
        .auto_sale(auto_sale),
        .count(count),
        .lleno(lleno),
        .vacio(vacio)
    );

    // Asignación de LEDs
    assign leds[2:0] = count;  // 3 bits del contador
    assign leds[3]   = lleno;  // LED extra para "lleno"

endmodule
