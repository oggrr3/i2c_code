class generator;
    rand    packet              pkt                     ;   //  Declaring packet class
            mailbox             gen2driv                ;   //  Declaring mailbox
            event               ended                   ;   //  Event, to indicate the end of transaction genration           

    function new(mailbox    gen2driv,   event   ended)                   ;   //  Constructor

        this.gen2driv   =   gen2driv                    ;   //  Getting the mailbox handle from environment
        this.ended      =   ended                       ;

    endfunction 

    
    task main(int repeat_count = 1)                     ;   //  Main task, generates(create and randomizes) the packets and puts into mailbox

        repeat(repeat_count)    begin

            pkt   =   new()                             ;

            if( !pkt.randomize() )
                $fatal("Gen:: trans randomization failed")  ;

            gen2driv.put(trans)                         ;

        end
        
        -> ended                                        ;   //  Triggering indicates the end of generation

    endtask

endclass 