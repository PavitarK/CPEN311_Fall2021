`timescale 1 ps / 1 ps

module sound_out(clk, edgedetect, audio_data, reset, readdatavalid, sound, start, finish_sound, direction);
    input [31:0] audio_data; 
    input readdatavalid, reset, clk, edgedetect, start, direction; 
    output logic [7:0] sound; 
    output finish_sound; 

    parameter idle =     8'b1111_0000;
    parameter read =     8'b0001_0000;  
    parameter wait1 =    8'b0010_0000;
    parameter audio1 =   8'b0011_0000;
    parameter wait2 =    8'b0100_0000;
    parameter audio2 =   8'b0101_0000; 
    parameter finished_sound = 8'b0111_1000;

    logic [7:0] state = idle; 
    logic [31:0] buffer; 

    assign finish_sound = state[3];
    //assign sound = data1 ? audio_data[15:8] : audio_data[31:24]; 


    always_ff @ (posedge clk or posedge reset) begin 
        if(reset)
            state <= idle; 
        else begin 
            case(state)
                idle: 
                    if(start)
                        state <= read; 
                    else 
                        state<= idle; 
                read: 
                    if(readdatavalid)
                        state <= wait1; 
                    else 
                        state<= read; 
                wait1:
                    if(edgedetect)
                        state <= audio1; 
                    else 
                        state <= wait1;  
                audio1: state <= wait2;
                wait2: 
                    if(edgedetect)
                            state <= audio2; 
                    else 
                        state <= wait2;  
                audio2: state <= finished_sound;
                finished_sound: state <= idle;  
                default: state <= idle; 
              endcase 
            end
    end 


    always_ff @(posedge clk) begin 
        case(state)
            wait1: buffer <= audio_data[31:0];
            audio1: 
                if(direction) 
                    sound <= buffer[15:8];
                else 
                    sound <= buffer[31:24];
            audio2: if(direction) 
                        sound <= buffer[31:24];
                    else 
                        sound <= buffer[15:8];
            default: sound <= sound; 
        endcase
    end  
endmodule

module tb_sound_out();

    logic CLOCK_50,clk_22kHz, edgedetect, reset, readdatavalid, flash_mem_read, finish_read; 
    logic [31:0] audio_data; 
    logic [22:0] flash_mem_address;
    logic [7:0] sound; 
    logic finish_sound; 

    sound_out dut(.clk(CLOCK_50), .edgedetect(edgedetect), .audio_data(audio_data), .reset(reset), 
                    .readdatavalid(readdatavalid), .sound(sound), .start(finish_read), .finish_sound(finish_sound));

    fsm_flash_read fsm(.CLOCK_50(CLOCK_50), .reset(1'b0), .start(1'b1), .flash_mem_read(flash_mem_read), 
                        .flash_mem_address(flash_mem_address), .finish_read(finish_read), .sound_finish(finish_sound));

    clock_sync sync(.CLOCK_50(CLOCK_50), .async_clk(clk_22kHz), .edgedetect(edgedetect));


    initial begin
            reset = 0; 
            readdatavalid = 0; 
            CLOCK_50 = 0; 
            forever begin 
                #5;
                CLOCK_50 = !CLOCK_50; 
            end  
        end

     initial begin 
            clk_22kHz = 0; 
        forever begin 
            #10;
            clk_22kHz = !clk_22kHz;
        end 
    end 

    initial begin 
        audio_data = 32'd100100001001011010101010; 
        #50; 
        audio_data = 32'b101111111110101011010101; 
        readdatavalid = 1; 
        #50; 
        audio_data = 32'b1111111111111111100000000000; 
        #70; 
    end 

endmodule 