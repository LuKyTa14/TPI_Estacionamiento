module fsm_sensores(
    input wire clk,
    input wire reset,
    input wire a,        // sensor a
    input wire b,        // sensor b
    output reg auto_entra,
    output reg auto_sale,
    output reg persona
);

    reg [2:0] estado, next_estado;

    //           Estados                  Logica estados
    localparam EST_INICIAL = 3'b000,
                                       // -ENTRADA-
               E1 = 3'b001,            // piso sensor (a)
               E2 = 3'b010,            // piso ambos sensores a la vez
               E3 = 3'b011,            // piso sensor (b)

                                       // -SALIDA-        
               S1 = 3'b101,            // piso sensor (b)
               S2 = 3'b110,            // piso ambos sensores a la vez
               S3 = 3'b111,            // piso sensor (a)

                                       // -NO ES AUTO-
               P  = 3'b100;            // piso sensor (a) o (b) y despues no piso (ab) juntos

    // Transición de estado (excel)
    always @(*) begin
        next_estado = estado;
        case (estado)
            EST_INICIAL: begin
                if (a & ~b) next_estado = E1;
                else if (~a & b) next_estado = S1;
            end

            E1: begin
                if (a & b) next_estado = E2;
                else if (~a & ~b) next_estado = P;
            end

            E2: begin
                if (~a & b) next_estado = E3;
                else if (~a & ~b) next_estado = P;
            end

            E3: begin
                if (~a & ~b) next_estado = EST_INICIAL;
            end

            S1: begin
                if (a & b) next_estado = S2;
                else if (~a & ~b) next_estado = P;
            end

            S2: begin
                if (a & ~b) next_estado = S3;
                else if (~a & ~b) next_estado = P;
            end

            S3: begin
                if (~a & ~b) next_estado = EST_INICIAL;
            end

            P: begin
                // Desde P siempre volver a estado inicial
                next_estado = EST_INICIAL;
            end
        endcase
    end

    // Registro de estado actual | Logica de salidas
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estado <= EST_INICIAL;
            auto_entra <= 0;
            auto_sale  <= 0;
            persona    <= 0;
        end
        else begin
            estado <= next_estado;
            auto_entra <= (estado == E3 && next_estado == EST_INICIAL);
            auto_sale  <= (estado == S3 && next_estado == EST_INICIAL);
            // persona    <= ((estado == E1 || estado == E2) && next_estado == P) || ((estado == S1 || estado == S2) && next_estado == P);
            persona <= ((estado == E1 || estado == E2 || estado == S1 || estado == S2) && next_estado == P);
        end
    end

endmodule
