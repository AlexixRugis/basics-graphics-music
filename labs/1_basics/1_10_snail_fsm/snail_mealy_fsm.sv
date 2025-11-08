// Asynchronous reset here is needed for some FPGA boards we use

`include "config.svh"

module snail_mealy_fsm
(
    input  clk,
    input  rst,
    input  en,
    input  a,
    output y
);

    typedef enum logic [2:0]
    {
        S_N = 3'd0,
        S_1 = 3'd1,
        S_10 = 3'd2,
        S_101 = 3'd3,
        S_1011 = 3'd4
    }
    state_e;

    state_e state, next_state;

    // State register

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            state <= S_N;
        else if (en)
            state <= next_state;

    // Next state logic

    always_comb
    begin
        next_state = state;

        case (state)
        S_N: if (a) next_state = S_1;
        S_1: if (~a) next_state = S_10;
        S_10: if (a) next_state = S_101;
              else next_state = S_N;
        S_101: if (a) next_state = S_1011;
               else next_state = S_10;
        S_1011: if (~a) next_state = S_10;
                else next_state = S_1;
        endcase
    end

    // Output logic based on current state and inputs

    assign y = (~a & state == S_1011);

endmodule
