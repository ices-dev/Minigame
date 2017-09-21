#!/bin/bash

# Ein sinnloses Spiel um tput zu üben
#
# Mit der übergabe von 2 Zahlen lässt sich die Spielfeldgröße einstellen.
# Wenn man zusätzlich als 3. Parameter "vim" übergibt wird mit HJKL gesteuert.
#
# Author        :       ices@posteo.de
# Last Edit     :       21.09.2017


### Variablen
LCOL=40                                                         # Spielfeld Breite
LROW=12                                                         # Spielfeld Tiefe
HPOS=0
VPOS=0
BORDER=X                                                        # Aussehen Rand
PLAYER=@                                                        # Aussehen Spieler
ZIEL=*                                                          # Aussehen Ziel
ZEIT=0
UP="w"
DOWN="s"
LEFT="a"
RIGHT="d"
MKEYS="WASD"

### Funktionen

# Spielfeld zeichnen

zeichnerand() {
    #Oben
    tput cup $VPOS $HPOS                                        # Spielfeld Start
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

hoch() {                                                        # Spieler hoch
    if (( $PVPOS > 2 ));then
        tput cup $PVPOS $PHPOS
        printf " "
        tput cup $PVPOS $PHPOS
        PVPOS=$((PVPOS-1))
        tput cup $PVPOS $PHPOS
        printf "$PLAYER"
    fi
}

runter() {                                                      # Spieler runter
    if (( $PVPOS < $((LROW-1)) ));then
        tput cup $PVPOS $PHPOS
        printf " "
        tput cup $PVPOS $PHPOS
        PVPOS=$((PVPOS+1))
        tput cup $PVPOS $PHPOS
        printf "$PLAYER"
    fi
}

links() {                                                       # Spieler links
    if (( $PHPOS > 1 ));then
        tput cup $PVPOS $PHPOS
        printf " "
        tput cup $PVPOS $PHPOS
        PHPOS=$((PHPOS-1))
        tput cup $PVPOS $PHPOS
        printf "$PLAYER"
    fi
}

rechts() {                                                      # Spieler rechts
    if (( $PHPOS < $((LCOL-2)) ));then
        tput cup $PVPOS $PHPOS
        printf " "
        tput cup $PVPOS $PHPOS
        PHPOS=$((PHPOS+1))
        tput cup $PVPOS $PHPOS
        printf "$PLAYER"
    fi
}  

ghoch() {                                                       # Ziel hoch
    if (( $GVPOS > 2 ));then
        tput cup $GVPOS $GHPOS
        printf " "
        tput cup $GVPOS $GHPOS
        GVPOS=$((GVPOS-1))
        tput cup $GVPOS $GHPOS
        printf "$ZIEL"
    fi
}

grunter() {                                                     # Ziel runter
    if (( $GVPOS < $((LROW-1)) ));then
        tput cup $GVPOS $GHPOS
        printf " "
        tput cup $GVPOS $GHPOS
        GVPOS=$((GVPOS+1))
        tput cup $GVPOS $GHPOS
        printf "$ZIEL"
    fi
}

glinks() {                                                      # Ziel links
    if (( $GHPOS > 1 ));then
        tput cup $GVPOS $GHPOS
        printf " "
        tput cup $GVPOS $GHPOS
        GHPOS=$((GHPOS-1))
        tput cup $GVPOS $GHPOS
        printf "$ZIEL"
    fi
}

grechts() {                                                     # Ziel rechts
    if (( $GHPOS < $((LCOL-2)) ));then
        tput cup $GVPOS $GHPOS
        printf " "
        tput cup $GVPOS $GHPOS
        GHPOS=$((GHPOS+1))
        tput cup $GVPOS $GHPOS
        printf "$ZIEL"
    fi
}

parameter() {                                                   # Abfrage Optionen
    if (( $# == 1 ));then
        if [[ $1 == "-h" ]] || [[ $1 == "--help" ]];then
            hilfe
            exit
        fi
    fi
    if (( $# >= 2 ));then                                       # Sind genau Zwei Optionen übergeben?
        if (( $1 > 40 ));then
            let LCOL=$1                                         # Größer als Min-Breite
        fi    
        if (( $2 > 12 ));then                                   # Größer als Min-Tiefe
            let LROW=$2
        fi
        if [[ $3 == "vim" ]];then
            MKEYS="HJKL"    
            UP="k"
            DOWN="j"
            LEFT="h"
            RIGHT="l"
        fi
    fi
}

theend() {                                                      # FIN. Cursor einblenden.
    VPOS=$((VPOS+1))    
    tput cup $VPOS 0
    tput cnorm
    exit 
}

thewin() {                                                      # WIN. Cursor einblenden.
    ZEIT=$(( $(date +%s) - $ZEIT ))                             # Berechnung Spielzeit
    VPOS=$((VPOS+1))    
    tput cup $VPOS 0
    echo " Gewonnen in $ZEIT Sekunden!"
    tput cnorm
    sleep 1
    exit 
} 

hilfe() {
    echo "    usage: $0 [COLUMNS] [ROWS]"
    echo "           $0 [COLUMNS] [ROWS] [OPTION]"
    echo "  options: vim -- hjkl movement"
}

### Spiel
parameter $1 $2 $3                                              # Funktion: Sind Optionen übergeben worden?
clear
tput civis                                                      # Cursor ausblenden
echo " $MKEYS zum bewegen. B beendet das Spiel."
VPOS=1
zeichnerand                                                     # Funktion: Spielfeld zeichnen
PHPOS=$((LCOL/2))
PVPOS=$((LROW/2))
GHPOS=$(( $RANDOM % $((LCOL-2)) + 1 ))
GVPOS=$(( $RANDOM % $((LROW-3)) + 2 ))
tput cup $GVPOS $GHPOS                                          # Gegner aufs Spielfeld
printf "$ZIEL"
tput cup $PVPOS $PHPOS
printf "$PLAYER"                                                # Spieler aufs Feld
tput cup $PVPOS $PHPOS
while [ 1 ];do                                                  # Spielschleife
    read -sn1 EING

    if (( $ZEIT == 0 ));then                                    # Start Spielzeit
        ZEIT=$(date +%s)
    fi

    case $EING in                                               # Bewegung Spieler
        $UP) hoch ;;
        $DOWN) runter ;;
        $LEFT) links ;;
        $RIGHT) rechts ;;
        b) theend ;;
    esac

    if (( $GVPOS == $PVPOS )) && (( $GHPOS == $PHPOS ));then    # Abfrage Sieg
        thewin
    fi 

    GMOVE=$(( $RANDOM % 5 ))                                    # Bewegung Ziel

    case $GMOVE in
        1) ghoch ;;
        2) grunter ;;
        3) glinks ;;
        4) grechts ;;
    esac                             
done
