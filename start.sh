#!/bin/bash

# Ein sinnloses Spiel um tput zu üben
# 
# ices@posteo.de
# 14.09.2017


### Variablen
LCOL=40                                                      # Spielfeld Breite
LROW=12                                                      # Spielfeld Tiefe
HPOS=0
VPOS=0
BORDER=X
PLAYER=@
ZEIL=*

### Funktionen

# Spielfeld zeichnen

zeichnerand() {
    #Oben
    tput cup $VPOS $HPOS                                  # Spielfeld Start
    BREIT=0
    while (( $BREIT < $LCOL ));do
        printf "$BORDER"
        HPOS=$((HPOS+1))
        tput cup $VPOS $HPOS
        BREIT=$((BREIT+1))
    done

    #Seiten
    TIEF=0
    while (( $TIEF < $LROW-2 ));do
        HPOS=0
        VPOS=$((VPOS+1))
        tput cup $VPOS $HPOS
        printf "$BORDER"
        tput cup $VPOS $((LCOL-1))
        printf "$BORDER"
        TIEF=$((TIEF+1))
    done

    #Unten 
    VPOS=$((VPOS+1))
    tput cup $VPOS $HPOS                                  # Spielfeld Start
    BREIT=0
    while (( $BREIT < $LCOL ));do
        printf "$BORDER"
        HPOS=$((HPOS+1))
        tput cup $VPOS $HPOS
        BREIT=$((BREIT+1))
    done   

}

hoch() {
    printf " "
    tput cup $PVPOS $PHPOS
    PVPOS=$((PVPOS-1))
    tput cup $PVPOS $PHPOS
    printf "$PLAYER"
    tput cup $PVPOS $PHPOS
}

runter() {                  
    printf " "
    tput cup $PVPOS $PHPOS
    PVPOS=$((PVPOS+1))
    tput cup $PVPOS $PHPOS
    printf "$PLAYER"
    tput cup $PVPOS $PHPOS  
}

links() {
    printf " "
    tput cup $PVPOS $PHPOS
    PHPOS=$((PHPOS-1))
    tput cup $PVPOS $PHPOS
    printf "$PLAYER"
    tput cup $PVPOS $PHPOS  
}

rechts() {                  
    printf " "
    tput cup $PVPOS $PHPOS
    PHPOS=$((PHPOS+1))
    tput cup $PVPOS $PHPOS
    printf "$PLAYER"
    tput cup $PVPOS $PHPOS  
}

theend() {                                                  # FIN. Cursor einblenden.
    tput cup $VPOS $HPOS
    tput cnorm
    exit 
}

thewin() {                                                  # WIN. Cursor einblenden.
    VPOS=$((VPOS+1))    
    tput cup $VPOS 0
    echo "Gewonnen!"
    tput cnorm
    exit 
} 

### Spiel
clear
tput civis                                              # Cursor ausblenden
echo "WASD zum Bewegen. B endet das Spiel."
VPOS=1
zeichnerand
PHPOS=$((LCOL/2))
PVPOS=$((LROW/2))
GHPOS=$(( $RANDOM % $((LCOL-2)) + 1 ))
GVPOS=$(( $RANDOM % $((LROW-3)) + 1 ))
tput cup $GVPOS $GHPOS
printf "$ZEIL"
tput cup $PVPOS $PHPOS
printf "$PLAYER"
tput cup $PVPOS $PHPOS
while [ 1 ];do
    read -sn1 EING                        
    case $EING in
        w) hoch ;;
        s) runter ;;
        a) links ;;
        d) rechts ;;
        b) theend ;;
    esac
    if (( $GVPOS == $PVPOS )) && (( $GHPOS == $PHPOS ));then
        thewin
    fi
done
