;-----------------------------------------------------------------
;Patch for Grand Prix Unlimited
;See the Crack.nfo file for information pertaining to this program
;-----------------------------------------------------------------

;-----------------------------------------------------------------
;Define equates used in the program
;-----------------------------------------------------------------
cr            EQU            0Dh                 ;carriage return
lf            EQU            0Ah                 ;line feed

code          SEGMENT
              ASSUME         CS:code,DS:code
              ORG            100h

strt:
              MOV            DX,OFFSET welcome
              MOV            AH,09h
              INT            21h

;-----------------------------------------------------------------
;Now, we will open the file to be written to.
;-----------------------------------------------------------------
              MOV            AL,1                ;Write only operation
              MOV            DX,OFFSET fname     ;move fname to DX
              MOV            AH,3Dh              ;open file
              INT            21h
              JNC            open_ok             ;jump if no errors
              PUSH           AX                  ;push error code onto stack
              JMP            error               ;jump to error routine

open_ok:
;-----------------------------------------------------------------
;Now we have to move the file pointer to the proper location in
;The program.
;-----------------------------------------------------------------
              MOV            BX,AX               ;move file handle to bx
              MOV            AL,00               ;move pointer from beginning
              MOV            CX,0000h            ;m.s. offset in hex
              MOV            DX,9A3Dh            ;l.s. offset in hex
              MOV            AH,42h              ;move file pointer
              INT            21h
              JNC            move_ok             ;jump if no errors
              PUSH           AX                  ;push error code onto stack
              JMP            error               ;jump to error routine

move_ok:
;-----------------------------------------------------------------
;Now we will write the new bytes to the program
;BX holds file handle
;-----------------------------------------------------------------
              MOV            CX,1                ;number of bytes to write
              MOV            DX,OFFSET databuff  ;move data to DX
              MOV            AH,40h              ;write to file
              INT            21h
              JNC            write_ok            ;jump if no errors
              PUSH           AX                  ;push error onto stack
              JMP            error               ;jump to error routine

write_ok:
;-----------------------------------------------------------------
;Now we have to close the file before we leave
;BX holds file handle
;-----------------------------------------------------------------
              MOV            AH,3Eh              ;close file
              INT            21h
              JNC            exit                ;jump if no errors & exit
              PUSH           AX                  ;push error onto stack
              JMP            error               ;jump to error routine

error:
;-----------------------------------------------------------------
;Parse the error code returned from the system and display
;The appropriate error message
;-----------------------------------------------------------------
              POP            AX                  ;return error code

              CMP            AX,1
              JE             code1
              CMP            AX,2
              JE             code2
              CMP            AX,3
              JE             code3
              CMP            AX,4
              JE             code4
              CMP            AX,5
              JE             code5
              CMP            AX,6
              JE             code6


              MOV            DX,OFFSET nocode    ;no matching error code
              JMP            print_error
code1:        MOV            DX,OFFSET error1    ;invalid function
              JMP            print_error
code2:        MOV            DX,OFFSET error2    ;file not found
              JMP            print_error
code3:        MOV            DX,OFFSET error3    ;path not found
              JMP            print_error
code4:        MOV            DX,OFFSET error4    ;no handle available
              JMP            print_error
code5:        MOV            DX,OFFSET error5    ;access denied
              JMP            print_error
code6:        MOV            DX,OFFSET error6    ;handle invalid
              JMP            print_error

;-----------------------------------------------------------------
;Display error code to user
;-----------------------------------------------------------------
print_error:
              MOV            AH,09h              ;display stirng
              INT            21h

;-----------------------------------------------------------------
;Now we are done so let's close up shop
;-----------------------------------------------------------------
exit:
              MOV            DX,OFFSET goodbye
              MOV            AH,09h
              INT            21h

              MOV            AX,04C00h           ;terminate program
              INT            21h

;-----------------------------------------------------------------
;Data area
;-----------------------------------------------------------------
fname         DB             'GPU.EXE',0     ;define file name
welcome       DB             'Generic Patch Maker v1.0',cr,lf
              DB             'Designed by Jake Pickett',cr,lf,lf
              DB             'Please wait while Grand Prix Unlimited is '
              DB             'being patched.',cr,lf,'$'
goodbye       DB             'Thank you for choosing INC!',cr,lf,'$'
nocode        DB             '<<Unkown Error Code>>',cr,lf,'$'
error1        DB             '<<Invalid Function>>',cr,lf,'$'
error2        DB             '<<File Not Found>>',cr,lf,'$'
error3        DB             '<<Path Not Found>>',cr,lf,'$'
error4        DB             '<<No Handle Available>>',cr,lf,'$'
error5        DB             '<<Access Denied>>',cr,lf,'$'
error6        DB             '<<Handle Invalid Or Not Open>>',cr,lf,'$'
databuff      DW             0EBh               ;bytes to write out

code          ENDS
              END            strt