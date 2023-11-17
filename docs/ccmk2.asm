        .org $F000
;
; Novag Chess Champion MK II ROM, identical to
; Commodore Chessmate ROM
;
; Based upon Microchess 1.5 by Peter Jennings
;           
; 8B00 RRIOT I/O
;
; Source looks like a mix of KIM-1 ROM and Microchess
;
; Hans Otten, 2022
; last update 28 march 2022
; 
; RRIOT
;
SAD    = $8B00  ;  6530 A DATA
PADD   = $8B01  ;  6530 A DATA DIRECTION
SBD    = $8B02  ;  6530 B DATA
PBDD   = $8B03  ;  6530 B DATA DIRECTION
CLK1T  = $8B04  ;  DIV BY 1 TIME Read timer disable interrupt 
CLK8T  = $8B05  ;  DIV BY 8 TIME Read interrupt flag bit 7 timer, bit 6 PA7 edge 
CLK64T = $8B06  ;  DIV BY 64 TIME 
CLKKT  = $8B07  ;  DIV BY 1024 TIME
CLKRDI = $8B07  ;  READ TIME OUT BIT
CLKRDT = $8B06  ;  READ TIMER
CKINT  = $8B0E  ;  Read timer interrupt
CLKTI  = $8B0F  ;  DIV by 1024 with  interrupt clock  
;
RSRAM  = $8B80  ; RAM in RRIOT
;
COLDSTART               ; Reset starts here       
          CLD
          CLI
          LDX #$FE      
          TXS
;
; Init SADD 
;
          LDA #$3F
          STA PBDD
;
; Check and RAM, hang if error
;          
          LDA #$FF
          LDX #$00
LF00E     STA $00,X
          CMP $00,X
          BEQ LF019
LF014     LDA $00,X
          JMP LF014     ; hang
LF019     DEX
          BNE LF00E
          EOR #$FF
          BEQ LF00E
;
          LDA #$05
          STA $53
;
; swetup baord
;
          LDX #$21      ; pieces
WHSET     LDA SETW,X    ; load table
          STA $00,X
          DEX
          BPL WHSET
          
          STX $59
          JSR LF2F0
          LDA #$70
          STA $56
          LDA #$20
LF039     JSR LFF9C
          SEC
          SBC #$04
          BNE LF039
          LDX #$04
          JMP LF260
LF046     LDA #$EE
          STA $83
          STA $84
;          
LF04C     CLD
          LDX #$FE
          TXS
          LDX #$B8
          STX $61
          LDA $78
          AND #$88
          BIT $56
          BVS LF05E
          ORA #$10
LF05E     STA $78
          LDX #$00
LF062     SEC
          JSR LFF04     
          CMP #$0A      ; key?
          BNE LF06D
          JMP LF0B9
LF06D     CMP #$09      ; key?
          BEQ LF046
          CPX #$04
          BMI LF077
          LDX #$00
LF077     CPX #$00
          BNE LF07F
          STX $83
          STX $84
LF07F     JSR LF085
          JMP LF062
;          
LF085     CPX #$03
          BEQ LF09F
          CPX #$02
          BEQ LF09B
          CPX #$01
          BEQ LF095
          ASL A
          ASL A
          ASL A
          ASL A
LF095     ORA $83
          STA $83
          INX
          RTS
;
;
;          
LF09B     ASL A
          ASL A
          ASL A
          ASL A
LF09F     ORA $84
          STA $84
          INX
          RTS
;
; start timer at 0
;          
LF0A5     LDA #$00
          STA $7C       ; zero display
          STA $7D
          STA $7E
          LDA #$F5
          STA CLKTI     ; start RRIOT timer with interrupt
          LDA #$F1      
          STA $7A
          STA $7B
          RTS
;
;
;          
LF0B9     CPX #$04
          BEQ LF0C7
          CPX #$00
          BNE LF0C4
          JMP LF046
LF0C4     JMP LF1C4
LF0C7     LDA $60
          BNE LF0CF
          BIT $56
          BVC LF113
LF0CF     LDA $83
          JSR LF2D1
          STA $83
          LDA $84
          JSR LF2D1
          STA $84
          LDA #$00
          STA $57
          LDA $86
          PHA
          LDA #$04
          STA $86
          LDX #$03
          STX $24
          JSR LF2F0
          JSR LF67B
          JSR LF2F0
          PLA
          STA $86
          LDA $84
          EOR #$77
          STA $84
          STA $23
          STA $72
          LDA $83
          EOR #$77
          STA $83
          STA $71
          LDX #$11
LF10C     CMP $11,X
          BEQ LF116
          DEX
          BPL LF10C
LF113     JMP LF2D9
LF116     TXA
          CLC
          ADC #$11
          STA $22
          DEC $57
          BNE LF149
          JSR LF7CE
          LDX $22
          CPX #$1A
          BMI LF140
          LDA $23
          AND #$F0
          BNE LF140
          LDA #$CC
          STA $00,X
          LDX #$12
LF135     LDA $00,X
          BMI LF13C
          INX
          BNE LF135
LF13C     LDA $23
          STA $00,X
LF140     LDA $78
          AND #$10
          STA $78
LF146     JMP LF381
LF149     LDX $22
          CPX #$11
          BNE LF19D
          LDX $5A
          BNE LF1C1
          BIT $56
          BVC LF179
          LDA $83
          CMP #$74
          BNE LF1C1
          LDA $84
          CMP #$76
          BNE LF16C
          JSR LF7CE
          LDA #$75
          STA $14
          BNE LF199
LF16C     CMP #$72
          BNE LF1C1
          JSR LF7CE
          LDA #$73
          STA $15
          BNE LF199
LF179     LDA $83
          CMP #$73
          BNE LF1C1
          LDA $84
          CMP #$71
          BNE LF18E
          JSR LF7CE
          LDA #$72
          STA $14
          BNE LF199
LF18E     CMP #$75
          BNE LF1C1
          JSR LF7CE
          LDA #$74
          STA $15
LF199     STA $5A
          BNE LF146
LF19D     CPX #$1A
          BMI LF1C1
          LDA $5F
          CMP $84
          BNE LF1C1
          CLC
          ADC #$10
          STA $23
          LDA $00,X
          AND #$F0
          CMP #$30
          BNE LF1C1
          JSR LF7CE
          LDA $84
          STA $23
          JSR LF7CE
          JMP LF381
LF1C1     JMP LF2D9
LF1C4     LDA $83
          AND #$F0
          CMP #$10
          BNE LF1DE
          BIT $56
          BVS LF1DB
          JSR LF2F0
          LDA #$70
          LDX #$00
LF1D7     STA $56
          STX $7E
LF1DB     JMP LF046
LF1DE     CMP #$80
          BNE LF1EF
          BIT $56
          BVC LF1DB
          JSR LF2F0
          LDA #$07
          LDX #$01
          BNE LF1D7
LF1EF     CMP #$70
          BNE LF1F6
          JMP LF381
LF1F6     CMP #$20
          BNE LF24B
          LDX #$02
          LDY #$21
LF1FE     LDA $FE94,Y
          STA $83
          LDA $0000,Y
          BMI LF22E
          JSR LF5D9
LF20B     STA $84
LF20D     JSR LFF04
          CMP #$0A
          BNE LF236
          LDX #$F0
          STX $74
          LDX #$02
          STX $59
          LDA $84
          BEQ LF232
          JSR LF2D1
          EOR #$77
LF225     STA $0000,Y
          DEY
          BPL LF1FE
          JMP LF046
LF22E     LDA #$00
          BEQ LF20B
LF232     LDA #$CC
          BNE LF225
LF236     CPX #$02
          BNE LF240
          PHA
          LDA #$00
          STA $84
          PLA
LF240     JSR LF085
          CPX #$04
          BMI LF20D
          LDX #$02
          BNE LF20D
LF24B     CMP #$60
          BNE LF27F
          CPX #$02
          BEQ LF25B
          LDX $89
          INX
          STX $84
          JMP LF04C
LF25B     LDA $83
          AND #$0F
          TAX
LF260     DEX
          BPL LF266
          JMP LF2D9
LF266     LDA $FE74,X
          STX $89
          STA $85
          LDA $FE7C,X
          STA $86
          LDA $FE84,X
          STA $87
          LDA $FE8C,X
          STA $88
LF27C     JMP LF046
LF27F     CMP #$50
          BNE LF289
          JSR LF2C4
LF286     JMP LF046
LF289     CMP #$40
          BNE LF292
          JSR LFF02
          BNE LF286
LF292     CMP #$30
          BNE LF2CE
          JSR LF0A5
          BNE LF2BE
LF29B     JSR LFF02
LF29E     CMP #$08
          BNE LF2AC
          LDA #$10
          STA $78
          LDA #$00
          STA $7E
          BEQ LF29B
LF2AC     CMP #$01
          BNE LF2BA
          LDA #$01
          STA $7E
          LDA #$00
          STA $78
          BEQ LF29B
LF2BA     CMP #$05
          BNE LF27C
LF2BE     JSR LF2C4
          JMP LF29E
LF2C4     LDX CLKRDT
          JSR LFF02
          STX CLKTI
          RTS
;          
LF2CE     JMP LF2D9
;
LF2D1     SEC
          SBC #$11
          EOR $56
          JMP LF5DE
LF2D9     LDA #$0A
          STA $83
          STA $84
          DEC $8B
LF2E1     JSR LFF9A
          JSR LFF34
          LSR $8B
          BNE LF2E1
          LDX #$00
          JMP LF062
LF2F0     LDX #$10
LF2F2     LDY $11,X
          LDA $00,X
          EOR #$77
          STA $11,X
          TYA
          EOR #$77
          STA $00,X
          DEX
          BPL LF2F2
          RTS
;
;
;          
LF303     LDA ($76),Y
          PHA
          INY
          LDA ($76),Y
          STA $2A
          PLA
          LDX #$11
LF30E     CMP $00,X
          BEQ LF318
          DEX
          BPL LF30E
          JMP LF42B
LF318     STX $29
          CPX #$00
          BNE LF349
          LDA $2A
          LDX #$03
          CMP #$06
          BNE LF32C
          LDA #$05
          STA $00,X
          BNE LF349
LF32C     CMP #$01
          BNE LF336
          LDA #$02
          STA $00,X
          BNE LF349
LF336     INX
          CMP #$02
          BNE LF341
          LDA #$03
          STA $00,X
          BNE LF349
LF341     CMP #$05
          BNE LF349
          LDA #$04
          STA $00,X
LF349     JMP LF514
;
;
; BRK/ IRQ handler 
; adjust time HHMM,  uses RRIOT timer  for interrupt every minute 
;
IRQVECTOR PHA
          TXA
          PHA
          TYA
          PHA
          LDA #$5D
          STA CLK1T    ; 
LF356     BIT CLKKT     ; timer ?
          BPL LF356
          LDX $7E
          DEC $7A,X
          BNE LF373
          LDA #$F0
          STA $7A,X
          SED           ; adjust time
          CLC
          LDA $7C,X
          ADC #$01      ; next minute
          CMP #$60      ; hour?
          BNE LF371
          LDA #$00
LF371     STA $7C,X
LF373     LDA #$F4
          STA CLKTI     ; reset timer
          PLA
          TAY
          PLA
          TAX
          PLA
          RTI
;
;          
LF37E     JMP LF2D9
;
LF381     LDA $00
          BMI LF37E
          LDA $11
          BMI LF37E
          LDA #$00
          STA $5F
          LDA CKINT
          STA $38
          LDA #$00
          BIT $56
          BVC LF39A
          LDA #$01
LF39A     STA $7E
          LDA $22
          CMP #$1A
          BMI LF3B2
          LDA $71
          SEC
          SBC $72
          CMP #$20
          BNE LF3B2
          LDA $72
          CLC
          ADC #$10
          STA $5F
LF3B2     LDY $75
          BNE LF3C7
          LDA $74
          BMI LF3BD
          JSR LF0A5
LF3BD     BIT $56
          BVC LF3D5
          LDA $71
          ORA $72
          BEQ LF37E
LF3C7     LDA $71
          EOR #$77
          JSR LF5ED
          LDA $72
          EOR #$77
          JSR LF5ED
LF3D5     LDA $74
          BMI LF42F
          LDA #$00
          STA $74
          LDA $38
          AND #$03
          ORA #$8C
          STA $77
          LDA $38
          AND #$1C
          ASL A
          ASL A
          ASL A
          STA $76
LF3EE     LDY #$00
          CPY $75
          BEQ LF400
LF3F4     LDA RSRAM,Y           ; RRIOT RAM
          CMP ($76),Y
          BNE LF403
          INY
          CPY $75
          BNE LF3F4
LF400     JMP LF303
LF403     LDA $76
          CLC
          ADC #$20
          STA $76
          LDA $77
          ADC #$00
          STA $77
          LDA $76
          CMP #$E1
          LDA $77
          SBC #$8F
          BCC LF3EE
          LDA $74
          BNE LF42B
          INC $74
          LDA #$8C
          STA $77
          LDA #$00
          STA $76
          JMP LF3EE
LF42B     LDA #$F0
          STA $74
LF42F     LDX #$0C
          STX $24
          STX $28
          STX $27
          LDX #$14
          JSR LF674
          LDX #$04
          STX $24
          LDA #$FF
          LDX #$05
LF444     STA $6A,X
          DEX
          BPL LF444
          STA $81
          JSR LF672
LF44E     LDA $78
          AND #$F7
          LDX $79
          CPX $FE30
          BEQ LF45B
          BNE LF45D
LF45B     ORA #$08
LF45D     STA $78
          LDX $27
          CPX #$0F
          BCS LF488
          LDA #$00
          JSR LF600
          LDA $47
          BMI LF47D
          LDA $78
          ORA #$80
          STA $78
LF474     LDA $8B
          JSR LFF9F
          DEC $8B
          BNE LF474
LF47D     LDA #$00
          STA $29
          LDA $00
          STA $2A
          JMP LF514
LF488     LDA $78
          AND #$7F
          STA $78
          LDA $27
          CMP #$82
          BPL LF49A
          CMP #$80
          BMI LF514
          LDA $59
LF49A     BPL LF514
          LDA $6F
          BMI LF4D6
          LDA $6E
          BMI LF4D6
          LDA $00
          CMP #$03
          BEQ LF4C1
          LDA $6A
          BMI LF4D6
          STA $23
          LDA #$04
          STA $22
          JSR LF7CE
          LDA #$00
          STA $29
          LDA #$02
          STA $2A
          BNE LF50E
LF4C1     LDA #$03
          STA $22
          LDA #$02
          STA $23
          JSR LF7CE
          LDA #$00
          STA $29
          LDA #$01
          STA $2A
          BNE LF50E
LF4D6     LDA $6D
          BMI LF514
          LDA $6C
          BMI LF514
          LDA $00
          CMP #$04
          BEQ LF4FB
          LDA $6B
          BMI LF514
          STA $23
          LDA #$04
          STA $22
          JSR LF7CE
          LDA #$00
          STA $29
          LDA #$05
          STA $2A
          BNE LF50E
LF4FB     LDA #$05
          STA $23
          LDA #$03
          STA $22
          JSR LF7CE
          LDA #$00
          STA $29
          LDA #$06
          STA $2A
LF50E     LDA $78
          AND #$F7
          STA $78
LF514     LDX $29
          BNE LF51A
          STX $59
LF51A     LDA $00,X
          STA $28
          STX $22
          LDA $2A
          STA $23
          CPX #$09
          BMI LF54C
          CMP $5F
          BNE LF538
          PHA
          SEC
          SBC #$10
          STA $23
          JSR LF7CE
          PLA
          STA $23
LF538     LDA #$AC
          STA $5F
          LDA $23
          SEC
          SBC $00,X
          CMP #$20
          BNE LF54C
          LDA $23
          SEC
          SBC #$10
          STA $5F
LF54C     JSR LF7CE
          LDA $5D
          STA $5E
          LDA $29
          STA $5D
          LDA $5B
          STA $5C
          LDA $2A
          STA $5B
          INC $60
          LDX $29
          CPX #$09
          BMI LF580
          LDA $2A
          AND #$70
          CMP #$70
          BNE LF580
          LDA #$CC
          STA $00,X
          LDX #$00
LF575     LDA $00,X
          BMI LF57C
          INX
          BNE LF575
LF57C     LDA $2A
          STA $00,X
LF580     LDA #$00
          STA $84
          LDA $28
          JSR LF5ED
          JSR LF5D9
          STA $83
          JSR LFF26
          LDA $2A
          JSR LF5ED
          JSR LF5D9
          STA $84
          JSR LFF26
          LDA #$00
          BIT $56
          BVS LF5A6
          LDA #$01
LF5A6     STA $7E
          LDA $78
          AND #$08
          BEQ LF5D6
          DEC $8B
LF5B0     JSR LFF95
          LSR $8B
          BNE LF5B0
          LDA $86
          PHA
          STA $3C
          LDX #$0C
          STX $24
          INX
          STX $86
          JSR LF7A8
          PLA
          STA $86
          CMP $3C
          BNE LF5D6
          LDX #$20
LF5CF     TXA
          JSR LFF17
          DEX
          BNE LF5CF
LF5D6     JMP LF04C
LF5D9     EOR $56
          CLC
          ADC #$11
LF5DE     PHA
          LSR A
          LSR A
          LSR A
          LSR A
          STA $69
          PLA
          ASL A
          ASL A
          ASL A
          ASL A
          ORA $69
          RTS
;
; Init RRIOT RAM
;          
          
LF5ED     LDY $75       
          STA RSRAM,Y
          INY
          CPY #$20
          BMI LF5FD
          LDY #$F0
          STY $74
          LDY #$00
LF5FD     STY $75
          RTS
;
;
;          
LF600     STA $22
          JSR LF7A1
          LDA #$F8
          STA $24
          STA $47
          LDX #$10
          STX $48
LF60F     JSR LF71A
          BNE LF60F
          LDA $47
          BPL LF625
          LDA #$F9
          STA $24
          LDA #$08
          STA $48
LF620     JSR LF72A
          BNE LF620
LF625     RTS
;
;
;
LF626     CPX #$F9
          BEQ LF650
          LDX $70
          LDA $48
          CMP #$09
          BPL LF643
          CPX #$11
          BEQ LF64B
          CPX #$1A
          BMI LF642
          CMP #$06
          BEQ LF64B
          CMP #$05
          BEQ LF64B
LF642     RTS
;
;
;
LF643     CPX #$18
          BEQ LF64B
          CPX #$19
          BNE LF668
LF64B     LDA #$00
          STA $47
          RTS
;
;
;
LF650     LDA $48
          LDX $70
          CPX #$12
          BEQ LF64B
          CPX #$13
          BEQ LF64B
          CMP #$05
          BPL LF669
          CPX #$14
          BEQ LF64B
          CPX #$15
          BEQ LF64B
LF668     RTS
;
;
;
LF669     CPX #$16
          BEQ LF64B
          CPX #$17
          BEQ LF64B
          RTS
;
;
;
LF672     LDX #$10
LF674     LDA #$00
LF676     STA $2B,X
          DEX
          BPL LF676
LF67B     LDA #$11
          STA $22
LF67F     DEC $22
          BPL LF684
          RTS
LF684     JSR LF7A1
          LDY $22
          LDX #$08
          STX $48
          CPY #$09
          BPL LF6D6
          CPY #$07
          BPL LF6C7
          CPY #$05
          BPL LF6BC
          CPY #$02
          BEQ LF6AA
          BPL LF6B1
          CPY #$01
          BEQ LF6AA
LF6A3     JSR LF71A
          BNE LF6A3
          BEQ LF67F
LF6AA     JSR LF72A
          BNE LF6AA
          BEQ LF67F
LF6B1     LDX #$04
          STX $48
LF6B5     JSR LF72A
          BNE LF6B5
          BEQ LF67F
LF6BC     JSR LF72A
          LDA $48
          CMP #$04
          BNE LF6BC
          BEQ LF67F
LF6C7     LDX #$10
          STX $48
LF6CB     JSR LF71A
          LDA $48
          CMP #$08
          BNE LF6CB
          BEQ LF67F
LF6D6     JSR LF6DC
          JMP LF67F
LF6DC     LDX #$06
          STX $48
LF6E0     JSR LF740
          BMI LF6F8
          BVS LF6F3
          LDX $24
          CPX #$04
          BNE LF6F8
          LDA $23
          CMP $5F
          BNE LF6F8
LF6F3     PHP
          JSR LF7FA
          PLP
LF6F8     JSR LF7A1
          DEC $48
          LDA $48
          CMP #$05
          BEQ LF6E0
LF703     JSR LF740
          BVS LF719
          BCS LF711
          BMI LF719
          PHP
          JSR LF7FA
          PLP
LF711     LDA $23
          AND #$F0
          CMP #$20
          BEQ LF703
LF719     RTS
LF71A     JSR LF740
          BMI LF724
          PHP
          JSR LF7FA
          PLP
LF724     JSR LF7A1
          DEC $48
          RTS
LF72A     JSR LF740
          BCC LF731
          BVC LF72A
LF731     BMI LF73A
          PHP
          JSR LF7FA
          PLP
          BVC LF72A
LF73A     JSR LF7A1
          DEC $48
          RTS
LF740     LDA $23
          LDX $48
          CLC
          ADC $FE41,X
          STA $23
          AND #$88
          BNE LF79C
          LDA $23
          LDX #$22
LF752     DEX
          BMI LF765
          CMP $00,X
          BNE LF752
          CPX #$11
          BMI LF793
          STX $70
          LDA #$7F
          ADC #$01
          BVS LF766
LF765     CLV
LF766     LDA $24
          CMP $85
          BMI LF78F
          CMP $86
          BPL LF78F
          PHA
          PHP
          LDA $70
          PHA
          JSR LF7CE
          LDA #$00
          JSR LF600
          JSR LF7B4
          PLA
          STA $70
          PLP
          PLA
          STA $24
          LDA $47
          BMI LF78F
          SEC
          LDA #$FF
          RTS
LF78F     CLC
          LDA #$00
          RTS
LF793     TXA
          LDX $24
          CPX #$04
          BMI LF79C
          INC $33,X
LF79C     LDA #$FF
          CLC
          CLV
          RTS
LF7A1     LDX $22
          LDA $00,X
          STA $23
          RTS
LF7A8     JSR LF7CE
          JSR LF2F0
          JSR LF67B
          JSR LF2F0
LF7B4     TSX
          STX $49
          LDX $61
          TXS
          PLA
          STA $48
          PLA
          STA $22
          TAX
          PLA
          STA $00,X
          PLA
          TAX
          PLA
          STA $23
          STA $00,X
          JMP LF7F3
LF7CE     TSX
          STX $49
          LDX $61
          TXS
          LDA $23
          PHA
          TAY
          LDX #$21
LF7DA     CMP $00,X
          BEQ LF7E1
          DEX
          BPL LF7DA
LF7E1     LDA #$CC
          STA $00,X
          TXA
          PHA
          LDX $22
          LDA $00,X
          STY $00,X
          PHA
          TXA
          PHA
          LDA $48
          PHA
LF7F3     TSX
          STX $61
          LDX $49
          TXS
          RTS
LF7FA     LDX $24
          CPX #$03
          BNE LF811
          LDA $23
          CMP $84
          BNE LF810
          LDX $22
          LDA $00,X
          CMP $83
          BNE LF810
          INC $57
LF810     RTS
LF811     CPX #$05
          BNE LF827
          STX $4A
          INC $24
          JSR LF7A8
          DEC $24
          LDA $4A
          CMP $4C
          BMI LF858
          STA $4C
          RTS
LF827     CPX #$06
          BNE LF859
          LDA #$FF
          STA $4B
          INC $24
          JSR LF7A8
          DEC $24
          LDA $4B
          BPL LF858
          JSR LF7CE
          LDA #$08
          STA $24
          STA $39
          JSR LF67B
          JSR LF7B4
          LDA #$06
          STA $24
          LDA $39
          CMP $FE30
          BNE LF858
          LDA #$FF
          STA $4A
LF858     RTS
LF859     CPX #$07
          BNE LF865
          INC $4B
          PLA
          PLA
          PLA
          PLA
          PLA
          RTS
LF865     CPX #$FF
          BEQ LF8D0
          BPL LF86E
          JMP LF8F6
LF86E     INC $30,X
          LDA $22
          CMP #$02
          BEQ LF87A
          CMP #$01
          BNE LF87C
LF87A     INC $30,X
LF87C     BVC LF890
          LDY $70
          LDA $FE1F,Y
          CMP $31,X
          BCC LF889
          STA $31,X
LF889     CLC
          PHP
          ADC $32,X
          STA $32,X
          PLP
LF890     CPX #$04
          BEQ LF8AF
          BMI LF897
          RTS
LF897     LDA $22
          CMP #$09
          BMI LF8AD
          LDA $23
          AND #$70
          CMP #$70
          BNE LF8AD
          LDA $22
          STA $81
          LDA $23
          STA $82
LF8AD     BNE LF903
LF8AF     LDA $35
          STA $40
          LDA #$00
          STA $24
          JSR LF7CE
          JSR LF2F0
          JSR LF672
          JSR LF2F0
          LDA #$08
          STA $24
          JSR LF67B
          JSR LF7B4
          JMP LF99C
LF8D0     LDA #$00
          STA $4F
          INC $54
          BNE LF8E8
          LDA $22
          CMP #$03
          BMI LF8EB
          LDY $52
          BNE LF8E8
          PLA
          PLA
          PLA
          PLA
          PLA
          RTS
LF8E8     BVS LF903
LF8EA     RTS
LF8EB     LDA #$80
          BVS LF903
          STA $51
          LDA #$00
          INY
          BVC LF92B
LF8F6     CPX #$F9
          BEQ LF8FE
          CPX #$F8
          BNE LF903
LF8FE     BVC LF8EA
          JMP LF626
LF903     LDY $70
          CPX $88
          BNE LF90D
          BVC LF915
          BVS LF928
LF90D     BVC LF8EA
          CPY #$1A
          BPL LF8EA
          BMI LF928
LF915     LDA $89
          CMP #$07
          BNE LF8EA
          LDA $11
          SEC
          SBC #$10
          AND #$70
          CMP $23
          BCS LF8EA
          LDY #$10
LF928     LDA $FE1F,Y
LF92B     STA $2F,X
          STA $52
          CPX #$FE
          BNE LF938
          CLC
          ADC $4F
          STA $4F
LF938     DEC $24
          CPY #$11
          BEQ LF975
          LDX $87
          CPX $24
          BEQ LF975
          LDX $24
          CPX #$FF
          BNE LF94F
          STX $54
          INX
          STX $51
LF94F     JSR LF7A8
          LDX $24
          CPX #$FE
          BNE LF964
          LDA $51
          BPL LF975
          LDA $4F
          CMP $50
          BCC LF964
          STA $50
LF964     CPX #$FF
          BNE LF975
          LDA $51
          BPL LF96E
          STA $8A
LF96E     LDX $54
          BPL LF975
          INX
          STX $53
LF975     INC $24
          LDA $24
          TAX
          LSR A
          BCC LF98C
          CLC
          LDA $2F,X
          ADC $45,X
          CMP $46,X
          BMI LF988
          STA $46,X
LF988     LDA #$00
          BEQ LF999
LF98C     SEC
          LDA $45,X
          SBC $2F,X
          CMP $46,X
          BPL LF997
          STA $46,X
LF997     LDA #$00
LF999     STA $45,X
          RTS
LF99C     LDX $31
          CPX $FE30
          BNE LF9AA
          LDA #$00
          STA $25
          JMP LFD8B
LF9AA     LDX $30
          BNE LF9BC
          LDX $39
          CPX $FE30
          BNE LF9BC
          LDA #$FF
          STA $25
          JMP LFD8B
LF9BC     LDA $22
          CMP #$09
          BMI LF9CC
          LDA $23
          CMP $5F
          BNE LF9CC
          LDA #$01
          STA $40
LF9CC     LDA $40
          CLC
          ADC #$40
          ADC $46
          ASL A
          STA $25
          LDA $53
          BNE LF9DE
          LDA #$10
          STA $25
LF9DE     LDA #$20
          CLC
          ADC $3A
          ADC $40
          SEC
          SBC $3E
          LDX $22
          SBC $FE30,X
          ASL A
          STA $26
          LDA #$28
          CLC
          ADC $3A
          ADC $39
          LDX $22
          ADC $FE30,X
          SEC
          SBC $32
          SBC $31
          SBC $31
          BCC LFA08
          JSR LFDCD
LFA08     LDA #$50
          CLC
          ADC $38
          SEC
          SBC $3C
          SBC $30
          BCC LFA18
          LSR A
          JSR LFDCD
LFA18     LDA #$10
          ADC $3B
          SEC
          SBC $3F
          JSR LFDCD
          LDA $8A
          BPL LFA2B
          LDA #$38
          JSR LFDD9
LFA2B     LDA $50
          BEQ LFA39
          DEC $25
          CMP #$07
          BMI LFA39
          DEC $25
          DEC $25
LFA39     LDA $22
          CMP $5E
          BEQ LFA45
          CMP $5D
          BNE LFA55
          BEQ LFA50
LFA45     LDA $23
          CMP $5C
          BNE LFA50
          LDA #$20
          JSR LFDD9
LFA50     LDA #$10
          JSR LFDD9
LFA55     LDA #$00
          CLC
          LDX #$10
LFA5A     LDY $00,X
          BMI LFA61
          ADC $FE30,X
LFA61     DEX
          BPL LFA5A
          LDX #$10
          SEC
LFA67     LDY $11,X
          BMI LFA6E
          SBC $FE30,X
LFA6E     DEX
          BPL LFA67
          CMP #$F5
          BMI LFAE8
          PHA
          LDX $22
          LDA $00,X
          LDX #$03
          JSR LFAF7
          BNE LFAD1
          LDX #$08
          JSR LFAF7
          BNE LFAD1
          LDX #$0B
          JSR LFAF7
          BNE LFAD1
          LDA $23
          LDX #$04
          JSR LFAF7
          BNE LFAD1
          LDX #$07
          JSR LFAF7
          BNE LFAD1
          LDX #$0C
          JSR LFAF7
          BNE LFAD1
          LDA $71
          EOR #$77
          LDX #$05
          JSR LFAF7
          BNE LFAD1
          LDX #$0A
          JSR LFAF7
          BNE LFAD1
          LDA $72
          EOR #$77
          LDX #$06
          JSR LFAF7
          BNE LFAD1
          LDX #$09
          JSR LFAF7
          BNE LFAD1
          LDA $25
          SEC
          SBC #$06
          STA $25
LFAD1     PLA
          CMP #$00
          BMI LFAE8
          LDA $40
          BEQ LFB05
          LDA $25
          CMP #$80
          BMI LFB05
          LDA #$18
          JSR LFDCD
          JMP LFB05
LFAE8     LDX $30
          BNE LFB05
          CMP #$F6
          BMI LFB05
          LDA #$90
          STA $25
          JMP LFD8B
LFAF7     LDY $75
LFAF9     DEY
          BPL LFAFE
          LDY #$1F
LFAFE     DEX
          BNE LFAF9
          CMP RSRAM,Y
          RTS
LFB05     LDX $22
          BEQ LFB1A
          LDA $00,X
          AND #$70
          BNE LFB1A
          LDA $23
          AND #$70
          BEQ LFB1A
          LDA #$30
          JSR LFDCD
LFB1A     LDA $81
          BMI LFB52
          JSR LF7CE
          LDA $70
          PHA
          JSR LF2F0
          LDX $81
          LDA $00,X
          PHA
          LDA $82
          STA $00,X
          TXA
          JSR LF600
          LDX $81
          PLA
          STA $00,X
          JSR LF2F0
          PLA
          STA $70
          JSR LF7B4
          LDA $47
          BPL LFB4D
          LDA $25
          SEC
          SBC #$0A
          STA $25
LFB4D     LDA #$50
          JSR LFDD9
LFB52     LDA $3A
          SEC
          SBC $3E
          CMP #$10
          BMI LFB6F
          PHA
          LDA #$10
          JSR LFDCD
          PLA
          SEC
          LDX $22
          SBC $FE30,X
          BMI LFB6F
          LDA #$10
          JSR LFDCD
LFB6F     LDA $23
          CMP $72
          BNE LFB7A
          LDA #$38
          JSR LFDCD
LFB7A     LDX $22
          CPX #$09
          BPL LFB83
          JMP LFC06
LFB83     SEC
          LDA $23
          SBC $00,X
          CMP #$20
          BNE LFBAF
          LDA $23
          CLC
          ADC #$01
          LDX #$08
LFB93     CMP $1A,X
          BEQ LFBA8
          DEX
          BPL LFB93
          SEC
          SBC #$02
          LDX #$08
LFB9F     CMP $1A,X
          BEQ LFBA8
          DEX
          BPL LFB9F
          BMI LFBAF
LFBA8     LDA $25
          SEC
          SBC #$03
          STA $25
LFBAF     LDX $22
          LDA $00,X
          CMP #$13
          BEQ LFBBB
          CMP #$14
          BNE LFBC0
LFBBB     LDA #$20
          JSR LFDCD
LFBC0     LDA $23
          CMP #$33
          BEQ LFC01
          CMP #$34
          BEQ LFC01
          CMP #$43
          BEQ LFC01
          CMP #$44
          BEQ LFC01
          LDX $46
          BNE LFC06
          AND #$70
          CMP #$70
          BEQ LFBE6
          CMP #$60
          BEQ LFBFC
          CMP #$50
          BEQ LFC01
          BNE LFC06
LFBE6     JSR LF7CE
          LDA $22
          JSR LF600
          JSR LF7B4
          LDA $47
          BPL LFC06
          LDA $25
          CLC
          ADC #$10
          STA $25
LFBFC     LDA #$10
          JSR LFDCD
LFC01     LDA #$15
          JSR LFDCD
LFC06     LDA $23
          AND #$07
          STA $69
          LDX #$07
LFC0E     LDA $09,X
          AND #$07
          CMP $69
          BEQ LFC72
          DEX
          BPL LFC0E
          LDX $22
          BEQ LFC72
          CPX #$05
          BPL LFC72
          LDA $00,X
          AND #$07
          CMP $69
          BEQ LFC53
          LDX #$07
LFC2B     LDA $1A,X
          AND #$07
          CMP $69
          BEQ LFC53
          DEX
          BPL LFC2B
          LDX $22
          CPX #$03
          BMI LFC53
          LDA $11
          AND #$0F
          CMP $69
          BNE LFC53
          LDA $13
          AND #$0F
          CMP $69
          BNE LFC53
          LDA $25
          CLC
          ADC #$0A
          STA $25
LFC53     LDA #$20
          JSR LFDCD
          LDX #$04
LFC5A     LDA $00,X
          AND #$07
          CMP $69
          BNE LFC68
          CPX $22
          BEQ LFC68
          BNE LFC6D
LFC68     DEX
          BPL LFC5A
          BMI LFC72
LFC6D     LDA #$10
          JSR LFDCD
LFC72     LDA $22
          BEQ LFC87
          CMP #$05
          BPL LFC87
          LDA $23
          AND #$60
          CMP #$60
          BNE LFC87
          LDA #$18
          JSR LFDCD
LFC87     LDA $22
          BEQ LFC98
          CMP #$09
          BPL LFC98
          LDA $11
          JSR LFDE9
          ASL A
          JSR LFDD9
LFC98     LDA $22
          CMP #$03
          BEQ LFCA2
          CMP #$04
          BNE LFCDC
LFCA2     LDA $25
          CMP #$80
          BMI LFCDC
          CMP #$82
          BPL LFCDC
          LDA $40
          BNE LFCDC
          LDA $31
          CMP #$05
          BPL LFCDC
          LDA $23
          CMP #$01
          BNE LFCBE
          STA $6F
LFCBE     CMP #$02
          BNE LFCC4
          STA $6E
LFCC4     CMP #$06
          BNE LFCCA
          STA $6D
LFCCA     CMP #$05
          BNE LFCD0
          STA $6C
LFCD0     CMP #$04
          BNE LFCD6
          STA $6B
LFCD6     CMP #$03
          BNE LFCDC
          STA $6A
LFCDC     LDX $22
          CPX #$02
          BNE LFCF6
          LDX $60
          CPX #$05
          BPL LFCED
          LDA #$20
          JSR LFDD9
LFCED     CPX #$09
          BPL LFCF6
          LDA #$08
          JSR LFDD9
LFCF6     LDX $22
          CPX #$07
          BEQ LFD00
          CPX #$08
          BNE LFD1E
LFD00     LDA $23
          AND #$0F
          CMP #$00
          BEQ LFD0C
          CMP #$07
          BNE LFD11
LFD0C     LDA #$10
          JSR LFDD9
LFD11     LDA $00,X
          AND #$70
          CMP #$00
          BNE LFD1E
          LDA #$08
          JSR LFDCD
LFD1E     LDX $22
          BNE LFD6A
          JSR LFE17
          PHA
          LDA $23
          PHA
          LDA $00
          STA $23
          JSR LFE17
          PLA
          STA $23
          PLA
          SEC
          SBC $51
          BCS LFD40
          EOR #$FF
          ASL A
          ASL A
          JSR LFDCD
LFD40     LDX #$09
          LDA #$00
          CLC
LFD45     LDY $11,X
          BMI LFD4C
          ADC $FE30,X
LFD4C     DEX
          BNE LFD45
          CMP #$10
          BPL LFD65
          LDA #$44
          JSR LFDE9
          STA $51
          LDA #$20
          SEC
          SBC $51
          JSR LFDCD
          JMP LFD6A
LFD65     LDA #$30
          JSR LFDD9
LFD6A     LDA $30
          CMP #$03
          BCS LFD8B
          LDA #$FD
          STA $4C
          LDA #$05
          STA $24
          LDA $39
          PHA
          JSR LF7A8
          PLA
          STA $39
          LDA $4C
          CMP #$FF
          BNE LFD8B
          LDA #$F0
          STA $25
LFD8B     LDX #$04
          STX $24
          LDA $25
          CMP $27
          BCC LFDBC
          BNE LFD9F
          LDA $26
          CMP $28
          BCC LFDBC
          BEQ LFDBC
LFD9F     LDA $25
          STA $27
          LDA $26
          STA $28
          LDA $22
          STA $29
          LDA $23
          STA $2A
          LDA $39
          STA $79
          LDA $27
          CMP #$FF
          BNE LFDBC
          JMP LF44E
LFDBC     LDA #$00
          STA $8A
          STA $52
          STA $50
          STA $46
          LDA #$05
          STA $53
          JMP LFF7B
LFDCD     CLC
          ADC $26
          STA $26
          LDA $25
          ADC #$00
          STA $25
          RTS
LFDD9     SEC
          STA $69
          LDA $26
          SBC $69
          STA $26
          LDA $25
          SBC #$00
          STA $25
          RTS
LFDE9     PHA
          LSR A
          LSR A
          LSR A
          LSR A
          STA $69
          LDA $23
          LSR A
          LSR A
          LSR A
          LSR A
          SEC
          SBC $69
          BCS LFDFF
          EOR #$FF
          ADC #$01
LFDFF     STA $69
          PLA
          AND #$07
          STA $68
          LDA $23
          AND #$07
          SEC
          SBC $68
          BCS LFE13
          EOR #$FF
          ADC #$01
LFE13     CLC
          ADC $69
          RTS
LFE17     LDA #$00
          STA $51
          LDX #$08
LFE1D     LDA $09,X
          BMI LFE29
          JSR LFDE9
          CLC
          ADC $51
          STA $51
LFE29     DEX
          BNE LFE1D
          LDA $51
          RTS
;
; table
;          
LFE2F 

        .byte $00
; 0E30
        .byte $13
        .byte $12
        .byte $12
        .byte $0A
        .byte $0A
        .byte $06
        .byte $06
        .byte $05
        .byte $05
        .byte $02
        .byte $02
        .byte $02
        .byte $02
        .byte $02
        .byte $02
        .byte $02
; 0E40
        .byte $02
        .byte $00
        .byte $F0
        .byte $FF
        .byte $01
        .byte $10
        .byte $11
        .byte $0F
        .byte $EF
        .byte $F1
        .byte $DF
        .byte $E1
        .byte $EE
        .byte $F2
        .byte $12
        .byte $0E
; 0E50
        .byte $1F
        .byte $21

SETW   .byte $03
        .byte $CC
        .byte $04
        .byte $00
        .byte $07
        .byte $02
        .byte $05
        .byte $01
        .byte $06
        .byte $10
        .byte $17
        .byte $11
        .byte $16
        .byte $12
; 0E60
        .byte $15
        .byte $14
        .byte $13
        .byte $73
        .byte $CC
        .byte $74
        .byte $70
        .byte $77
        .byte $72
        .byte $75
        .byte $71
        .byte $76
        .byte $60
        .byte $67
        .byte $61
        .byte $66
; 0E70
        .byte $62
        .byte $65
        .byte $64
        .byte $63
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $FF
        .byte $FF
        .byte $00
        .byte $00
        .byte $00
        .byte $00
; 0E80
        .byte $08
        .byte $08
        .byte $08
        .byte $08
        .byte $FF
        .byte $FD
        .byte $FC
        .byte $FB
        .byte $FB
        .byte $FB
        .byte $FB
        .byte $FB
        .byte $55
        .byte $55
        .byte $55
        .byte $55
; 0E90
        .byte $55
        .byte $55
        .byte $55
        .byte $00
        .byte $09
        .byte $08
        .byte $08
        .byte $05
        .byte $05
        .byte $03
        .byte $03
        .byte $02
        .byte $02
        .byte $01
        .byte $01
        .byte $01
; 0EA0
        .byte $01
        .byte $01
        .byte $01
        .byte $01
        .byte $01
        .byte $F9
        .byte $F8
        .byte $F8
        .byte $F5
        .byte $F5
        .byte $F3
        .byte $F3
        .byte $F2
        .byte $F2
        .byte $F1
        .byte $F1
; 0EB0
        .byte $F1
        .byte $F1
        .byte $F1
        .byte $F1
        .byte $F1
        .byte $F1

;
; end of table 
;
; Keys and Display routines
;
; PB0-PB2 to 74LS145 
;         4 LED display
;         keys
;         piezo loudspeaker
; PA0-PA6 led segments a-g and keys            
  
; PA7 Chessmate loses
; PB3 check
; PB4 black/white LED 
;
;
; light LEDs and get key inspired by KIM-1 AK and SCAND 

LFEB6     LDA #$FF
          STA PADD
          LDX $78
          LDA $83
          JSR LFEC4
          LDA $84
LFEC4     PHA
          LSR A
          LSR A
          LSR A
          LSR A
          BIT $7F
          BPL LFED2
          JSR LFEE0
          BEQ LFED5
LFED2     JSR LFEE3
LFED5     PLA
          AND #$0F
          BIT $7F
          BMI LFEE0
          AND #$0F
          BEQ LFEE7
LFEE0     CLC
          ADC #$10
LFEE3     TAY
          LDA  TABLE,Y   ; load segment table
LFEE7     BIT $78
          BMI LFEEE
          AND #$7F
          .byte $2C     ; BIT skip next instruction 
LFEEE     ORA #$80
          LDY #$00      ; lookup conversion
          STY SAD       ; turn off segments
          STX SBD       ; output digit enable
          STA SAD       ; output segments
          INX
          LDY #$7F      ; delay 500 cycles
CONVD1    DEY
          BNE CONVD1
          RTS
          
LFF02     SEC
          .byte $24     ; BIT skip CLC instruction
LFF04     CLC
          ROR $7F
LFF07     JSR LFF80
          JSR LFF40
          CMP $80
          BEQ LFF07
          STA $80
          CMP #$00
          BEQ LFF07
LFF17     DEC $8B
LFF19     JSR LFF9F
          ASL A
          LSR $8B
          LSR $8B
          BNE LFF19
          LDA $80
          RTS
;
;
;          
LFF26     PHA
          LSR A
          LSR A
          LSR A
          LSR A
          JSR LFF31
          PLA
          AND #$0F
LFF31     JSR LFF17
LFF34     TYA
          PHA
          LDY #$40
LFF38     JSR LFF7D
          DEY
          BNE LFF38
          BEQ LFF76
LFF40     TYA
          PHA
          TXA
          PHA
          LDA #$80
          STA PADD
          LDX #$FF
LFF4B     LDA SAD
          CMP SAD
          BNE LFF4B
          ORA #$80
          EOR #$FF
          BNE LFF64
          CPX #$06
          BEQ LFF6B
          INC SBD 
          LDX #$06
          BNE LFF4B
LFF64     ASL A
          BCS LFF6A
          INX
          BPL LFF64
LFF6A     TXA
LFF6B     STA $69
LFF6D     LDA #$04
          ORA $78
          STA SBD 
          PLA
          TAX
LFF76     PLA
          TAY
          LDA $69
          RTS
;
;
;          
LFF7B     SEC
          .byte $24     ; BIT skip next instruction
LFF7D     CLC 
          ROR $7F
LFF80     TYA
          PHA
          TXA
          PHA
          BIT $7F
          BPL LFF90
          LDA $7C
          STA $83
          LDA $7D
          STA $84
LFF90     JSR LFEB6
          BEQ LFF6D
LFF95     LDA #$10
          JSR LFF9C
LFF9A     LDA #$08
LFF9C     JSR LFF9F
LFF9F     STA $69
          TYA
          PHA
          TXA
          PHA
          LDA #$06
          ORA $78
          STA SBD 
          LDY #$08
          LDA $69
LFFB0     CLC
          ADC $69
          PHA
          ROL A
          AND #$01
          EOR SBD 
          STA SBD 
          PLA
          DEX
          BNE LFFB0
          DEY
          BNE LFFB0
          BEQ LFF6D
;
; tables
;          
TABLE   .byte $00       ; segment table
        .byte $77
        .byte $7C
        .byte $39
        .byte $5E
        .byte $79
        .byte $71
        .byte $3D
        .byte $76
        .byte $00
; 0FD0
        .byte $53
        .byte $00
        .byte $00
        .byte $40
        .byte $08
        .byte $40
        .byte $3F
        .byte $06
        .byte $5B
        .byte $4F
        .byte $66
        .byte $6D
        .byte $7D
        .byte $07
        .byte $7F
        .byte $6F
; 0FE0
        .byte $53
        .byte $00
        .byte $00
        .byte $40
        .byte $08
        .byte $00
        .byte $00
        .byte $00
        .TEXT CHESSMATE 7.5
        .byte $00
        .byte $00
        .byte $00
        .byte $00
        .byte $00
; vectors 
; reset = $F000
; irq=  = $F34C
        
        .byte $00
        .byte $00
        .byte (COLDSTART & $FF)         ; Reset vector
        .byte (COLDSTART >> 8)
        .byte (IRQVECTOR & $FF)         ; IRQ/BRK vector
        .byte (IRQVECTOR >> 8)
;          
          .END
          