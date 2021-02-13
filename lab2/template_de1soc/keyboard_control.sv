module keyboard_control(kbd_received_ascii_code, stop, start, forward, backward);

    input [7:0] kbd_received_ascii_code; 
    output stop, start, forward, backward; 

    parameter character_lowercase_b= 8'h62;
    parameter character_lowercase_d= 8'h64;
    parameter character_lowercase_e= 8'h65;
    parameter character_lowercase_f= 8'h66;
    parameter character_lowercase_r= 8'h72; //optional

    assign stop = (kbd_received_ascii_code == character_lowercase_d);
    assign start = (kbd_received_ascii_code == character_lowercase_e);
    assign forward = (kbd_received_ascii_code == character_lowercase_b);
    assign backward = (kbd_received_ascii_code == character_lowercase_f);
    //assign reverse idgaf RESTART
    
    //TODO Instantiate in ipod solution then send signals to fsm flash read and behave accordingly. 
endmodule 