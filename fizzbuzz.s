; ------------------------------------------------------------------------------
; The FizzBuzz programmer test written in x86-64 on Linux using NASM
;
; The problem is:
;
;   Write a program that prints the numbers from 1 to 100. But for
;   multiples of three print "Fizz" instead of the number and for the
;   multiples of five print "Buzz". For numbers which are multiples of
;   both three and five print "FizzBuzz"
;   See: https://en.wikipedia.org/wiki/Fizz_buzz
;
; Author: Paul Hornsey (paul@1partcarbon.co.uk)
; ------------------------------------------------------------------------------

; ------------------------------------------------------------------------------
section .data                                  ; Constants
; ------------------------------------------------------------------------------

fizz:               db        "Fizz"
buzz:               db        "Buzz"
cr:                 db        10

last_num:           equ       100              ; Numbers go from 1 to last_num

; ------------------------------------------------------------------------------
section .bss                                   ; variables
; ------------------------------------------------------------------------------

output_buffer:      resb   3                   ; Buffer for three ascii digits

; ------------------------------------------------------------------------------
section .text                                  ; program
; ------------------------------------------------------------------------------

        global _start

_start:
        xor        r8, r8                      ; R8 - Loop counter e.g. 1..100

main_loop:
        inc        r8

        xor        r9, r9
        mov        rdx, 0
        mov        rax, r8
        mov        rcx, 3
        div        rcx                         ; Result in rax, remainder rdx
        cmp        rdx, 0
        jnz        not_divisable_by_3
        or         r9, 1
not_divisable_by_3:
        mov        rdx, 0
        mov        rax, r8
        mov        rcx, 5
        div        rcx                         ; Result in rax, remainder rdx
        cmp        rdx, 0
        jnz        not_divisable_by_5
        or         r9, 2
not_divisable_by_5:

        ; At this point r9 - 1 = fizz, 2 = buzz, 3 = fizzbuzz, 0 = number
        cmp        r9, 0
        jnz        skip_digit_print
        mov        rax, r8
        call       print_byte_as_num
        jmp        continue
skip_digit_print:
        cmp        r9, 1
        jnz        skip_fizz_print
        call       print_fizz
        jmp        continue
skip_fizz_print:
        cmp        r9, 2
        jnz        skip_buzz_print
        call       print_buzz
        jmp        continue
skip_buzz_print:
        call       print_fizzbuzz
continue:
        cmp        r8, last_num
        je         exit_0                      ; Exit once 100 reached
        jmp        main_loop                   ; else keep looping

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_fizzbuzz:
        mov        rbx, 1                      ; rbx = 1 (fizz and buzz)
        jmp        do_fizz

print_fizz:
        xor        rbx, rbx                    ; rbx = 0 (only print fizz)

do_fizz:
        mov        rax, 1                      ; sys_write
        mov        rdi, 1                      ; stdout
        mov        rsi, fizz                   ; string
        mov        rdx, 4                      ; length
        syscall

        cmp        rbx, 1                      ; if rbx == 1 then continue
        jne        print_new_line              ; on to print_buzz else move
                                               ; past to print a new_line
print_buzz:
        ; print "Buzz"
        mov        rax, 1                      ; sys_write
        mov        rdi, 1                      ; stdout
        mov        rsi, buzz                   ; string
        mov        rdx, 4                      ; length
        syscall

print_new_line:
        ; print "\n"
        mov        rax, 1                      ; sys_write
        mov        rdi, 1                      ; stdout
        mov        rsi, cr                     ; string
        mov        rdx, 1                      ; length
        syscall

        ret

; ----------------------------------------------------------
; Print a positive integer in Ascii to stdout
; Input: eax = byte to print
;
; The code loops from units to hundreds.  Each time
; dividing by 10 and saving the remainder.  Once converted
; into Ascii by adding "0"(0x30), it is stored in a buffer
; which is then output using sys_write.
; ----------------------------------------------------------
print_byte_as_num:
        mov        r9, 2                       ; r9 indexes into output_buffer
                                               ; starts at the end for units
each_digit_loop:
        mov        rdx, 0
        mov        rcx, 10                     ; divide by 10
        div        rcx                         ; Result in rax, remainder rdx

        add        rdx, 0x30                   ; Convert int to char
        mov        [output_buffer+r9], dl      ; store in buffer left to right
        dec        r9                          ; offset back one

        cmp        rax, 0                      ; Was this the last digit?
        jnz        each_digit_loop             ; if not, loop again

        ; print the 3 digit buffer result
        mov        rax, 1                      ; sys_write
        mov        rdi, 1                      ; stdout
        mov        rsi, output_buffer          ; input ascii char
        mov        rdx, 3                      ; length
        syscall

        call       print_new_line

        ret

; ----------------------------------------------------------
; Exit program and pass 0 (success) back to calling OS.
; ----------------------------------------------------------
exit_0:
        mov        rax, 60                     ; sys_exit
        xor        rdi, rdi
        syscall

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -