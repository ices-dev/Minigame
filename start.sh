#!/bin/bash

# Ein sinnloses Spiel um tput zu üben
# 
# ices@posteo.de
# 19.09.2017


### Variablen
LCOL=40                                                      # Spielfeld Breite
LROW=12                                                      # Spielfeld Tiefe
HPOS=0
VPOS=0
BORDER=X
PLAYER=@
ZIEL=*
ZEIT=0

### Funktionen

# Spielfeld zeichnen

zeichnerand() {
    #Oben
    tput cup $VPOS $HPOS                                     # Spielfeld Start
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
    tput cup $VPOS $HPOS                                     
    BREIT=0
    while (( $BREIT < $LCOL ));do
        printf "$BORDER"
        HPOS=$((HPOS+1))
        tput cup $VPOS $HPOS
        BREIT=$((BREIT+1))
    done   

}

hoch() {
    if (( $PVPOS > 2 ));then
        tput cup $PVPOS $PHPOS
        printf " "
        tput cup $PVPOS $PHPOS
        PVPOS=$((PVPOS-1))
        tput cup $PVPOS $PHPOS
        printf "$PLAYER"
        tput cup $PVPOS $PHPOS
    fi
}

runter() {
    if (( $PVPOS < $((LROW-1)) ));then
        tput cup $PVPOS $PHPOS
        printf " "
        tput cup $PVPOS $PHPOS
        PVPOS=$((PVPOS+1))
        tput cup $PVPOS $PHPOS
        printf "$PLAYER"
        tput cup $PVPOS $PHPOS
    fi
}

links() {
    if (( $PHPOS > 1 ));then
        tput cup $PVPOS $PHPOS
        printf " "
        tput cup $PVPOS $PHPOS
        PHPOS=$((PHPOS-1))
        tput cup $PVPOS $PHPOS
        printf "$PLAYER"
        tput cup $PVPOS $PHPOS
    fi
}

rechts() {
    if (( $PHPOS < $((LCOL-2)) ));then
        tput cup $PVPOS $PHPOS
        printf " "
        tput cup $PVPOS $PHPOS
        PHPOS=$((PHPOS+1))
        tput cup $PVPOS $PHPOS
        printf "$PLAYER"
        tput cup $PVPOS $PHPOS
    fi
}  
ghoch() {
    if (( $GVPOS > 2 ));then
        tput cup $GVPOS $GHPOS
        printf " "
        tput cup $GVPOS $GHPOS
        GVPOS=$((GVPOS-1))
        tput cup $GVPOS $GHPOS
        printf "$ZIEL"
        tput cup $GVPOS $GHPOS
    fi
}

grunter() {
    if (( $GVPOS < $((LROW-1)) ));then
        tput cup $GVPOS $GHPOS
        printf " "
        tput cup $GVPOS $GHPOS
        GVPOS=$((GVPOS+1))
        tput cup $GVPOS $GHPOS
        printf "$ZIEL"
        tput cup $GVPOS $GHPOS
    fi
}

glinks() {
    if (( $GHPOS > 1 ));then
        tput cup $GVPOS $GHPOS
        printf " "
        tput cup $GVPOS $GHPOS
        GHPOS=$((GHPOS-1))
        tput cup $GVPOS $GHPOS
        printf "$ZIEL"
        tput cup $GVPOS $GHPOS
    fi
}

grechts() {
    if (( $GHPOS < $((LCOL-2)) ));then
        tput cup $GVPOS $GHPOS
        printf " "
        tput cup $GVPOS $GHPOS
        GHPOS=$((GHPOS+1))
        tput cup $GVPOS $GHPOS
        printf "$ZIEL"
        tput cup $GVPOS $GHPOS
    fi
}

opti() {                                                     # Abfrage Optionen
    if (( $# == 2 ));then                                    # Sind genau Zwei Optionen übergeben?
        if (( $1 > 40 ));then
            let LCOL=$1                                      # Größer als Min-Breite
        fi    
        if (( $2 > 12 ));then                                # Größer als Min-Tiefe
            let LROW=$2
        fi
    fi
}

theend() {                                                   # FIN. Cursor einblenden.
    VPOS=$((VPOS+1))    
    tput cup $VPOS 0
    tput cnorm
    exit 
}

thewin() {                                                   # WIN. Cursor einblenden.
    ZEIT=$(( $(date +%s) - $ZEIT ))
    VPOS=$((VPOS+1))    
    tput cup $VPOS 0
    echo "Gewonnen in $ZEIT Sekunden!"
    tput cnorm
    sleep 1
    exit 
} 

### Spiel
clear
opti                                                         # Funktion: Sind Optionen übergeben worden?
tput civis                                                   # Cursor ausblenden
echo "WASD zum Bewegen. B endet das Spiel."
VPOS=1
zeichnerand                                                  # Funktion: Spielfeld zeichnen
PHPOS=$((LCOL/2))
PVPOS=$((LROW/2))
GHPOS=$(( $RANDOM % $((LCOL-2)) + 1 ))
GVPOS=$(( $RANDOM % $((LROW-3)) + 2 ))
tput cup $GVPOS $GHPOS                                       # Gegner aufs Spielfeld
printf "$ZIEL"
tput cup $PVPOS $PHPOS
printf "$PLAYER"                                             # Spieler aufs Feld
tput cup $PVPOS $PHPOS
while [ 1 ];do
    read -sn1 EING                        
    if (( $ZEIT == 0 ));then
        ZEIT=$(date +%s)
    fi

    GMOVE=$(( $RANDOM % 10 ))

    case $GMOVE in
        1) ghoch ;;
        2) grunter ;;
        3) glinks ;;
        4) grechts ;;
    esac

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
