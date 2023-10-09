/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */

.global dividend,divisor,quotient,mod,we_have_a_problem
.type dividend,%gnu_unique_object
.type divisor,%gnu_unique_object
.type quotient,%gnu_unique_object
.type mod,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
dividend:          .word     0  
divisor:           .word     0  
quotient:          .word     0  
mod:               .word     0 
we_have_a_problem: .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmFunc.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 5 Division
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    
    /* REGISTER TRACKER FOR PROGRAMMER
     * UNSPECIFIED REGISTERS ARE SCRATCH PAD OR UNUSED
     * R0 - recive dividend, output addres of quotient if error
     * R1 - recive divisor
     * R2 - dividend
     * R3 - divisor
     * R4 - quotient
     * R5 - mod
     * R6 - store number we divide by subtracting turned mod
     * R7 
     * R8 - store value of divisor
     * R9 - store our loop counter turned quotient
     * R10 - stores 0
     * R11 - stores 1
     * R12 - we_have_a_problem
     */
    
    /* set each output variable to a register */
    LDR R2,=dividend
    LDR R3,=divisor
    LDR R4,=quotient
    LDR R5,=mod
    LDR R12,=we_have_a_problem
    
    /* store our input values in our storage locations */
    // R0 is the input dividend so we store it there 
    STR R0,[R2]
    // R1 is the input divisor so we store it there 
    STR R1,[R3]
    
    /* store 0 in R10 and 1 in R11 just for ease */
    LDR R10,=0
    LDR R11,=1
    
    // set quotient to 0 
    STR R10,[R4]
    // set mod to 0 
    STR R10,[R5]
    // set we_have_a_problem to 0 cause we have to at some point
    STR R10,[R12]
    
    /* check if either input value is 0
     * and if so it's an ERROR
     */
    // load R6 w/ the value of dividend 
    LDR R6,[R2]
    // comepare dividend to 0 
    CMP R10,R6
    // if it's equal to 0, branch to error 
    BEQ error
 
    // load R8 w/ the vlaue of divisor 
    LDR R8,[R3]
    // compare the divisor to 0 
    CMP R10,R8
    // if it's equal to 0, branch to error 
    BEQ error

    // R6 is already storeing our value of dividend
    // R8 is already storeing our value of the divisor
    // set R9, which is our counter, to 0
    LDR R9,=0

/* our loop for dividing by subtracting 
 * "working number" is how I refer to our number we are dividing by subtracting
 * it is in R6
 */ 
div_by_sub_loop:
    // compare our working number to our divisor
    CMP R6,R8
    // if our working number is smaller than our divisor, exit the loop
    BLO exit_loop
    // else...
    
    // subtract our divisor from our working number and update it
    SUB R6,R6,R8
    // increment our counter
    ADD R9,R9,R11
    // go back to the top of the loop
    B div_by_sub_loop 
    
    
/* for when we exit our loop */
exit_loop:
    // store our counter in our quotient
    STR R9,[R4]
    // store our remainder in our mod
    STR R6,[R5]
    // branch to always so we skip over error
    B always
   
/* error branch for errors */
error:
    // set we_have_a_problem to 1
    STR R11,[R12]
    
/* we always do this at the end before done which comes after */
always:
    // load R0 with the address of quotient
    LDR R0,=quotient
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 /* this is a do-nothing line to deal with IDE mem display bug */

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




