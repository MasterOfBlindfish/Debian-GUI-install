Um die Auflösung so einfach zu wechseln wie beim Raspberry Pi (wo man oft nur ein Fenster zieht oder eine Einstellung wählt), müssen Sie die manuellen xrandr-Befehle in ein kleines Skript verpacken. 

Das folgende Skript fungiert als "Auflösungs-Menü". Sie müssen es nur einmal erstellen und können dann jederzeit bequem zwischen den Modi wechseln, ohne lange Befehle zu tippen. 

1. Das "Easy-Change" Skript erstellen
Erstellen Sie eine Datei namens setres in Ihrem Home-Verzeichnis. Dieses Skript fügt die Modi bei Bedarf hinzu und schaltet sofort um. 

cat <<EOF > ~/setres
#!/bin/bash

# 1. Bildschirmnamen automatisch erkennen (meist VNC-0, VNC-1 oder default)
SCREEN=\$(xrandr | grep " connected" | head -n1 | cut -d" " -f1)

if [ -z "\$SCREEN" ]; then
    echo "Fehler: Kein verbundener Bildschirm gefunden."
    exit 1
fi

# Funktion zum Hinzufügen und Wechseln
change_res() {
    RES=\$1
    WIDTH=\${RES%x*}
    HEIGHT=\${RES#*x}
    
    # Modeline generieren (z.B. "1920x1080_60.00" ...)
    MODELINE=\$(cvt \$WIDTH \$HEIGHT 60 | grep Modeline | sed 's/Modeline //')
    MODENAME=\$(echo \$MODELINE | awk '{print \$1}' | tr -d '"')
    
    # Prüfen, ob Modus schon beim Bildschirm hinzugefügt wurde
    if ! xrandr | grep -q "\$MODENAME"; then
        # Modus zum Server hinzufügen
        xrandr --newmode \$MODELINE
        # Modus zum spezifischen Bildschirm hinzufügen
        xrandr --addmode \$SCREEN \$MODENAME
    fi
    
    # Jetzt erst die Auflösung setzen
    xrandr --output \$SCREEN --mode \$MODENAME
    
    if [ \$? -eq 0 ]; then
        echo "Auflösung geändert auf: \$RES (\$SCREEN)"
    else
        echo "Fehler beim Setzen der Auflösung \$RES"
        exit 1
    fi
}

# Menü
case "\$1" in
    1920x1080) change_res "1920x1080" ;;
    1600x900)  change_res "1600x900" ;;
    1280x720)  change_res "1280x720" ;;
    800x600)   change_res "800x600" ;;
    *)
        echo "Verwendung: \$0 [1920x1080|1600x900|1280x720|800x600]"
        exit 1
        ;;
esac
EOF

chmod +x ~/setres

2. Auflösung wechseln (So einfach wie am Pi)
Ab jetzt können Sie die Auflösung mit einem einzigen, kurzen Befehl ändern, wann immer Sie wollen:

~/setres 1920x1080

Oder für eine kleinere Auflösung:

~/setres 1280x720

3. Optional: Automatische Anpassung an das VNC-Fenster
Wenn Sie möchten, dass sich die Auflösung automatisch anpasst, sobald Sie das VNC-Viewer-Fenster auf Ihrem lokalen PC vergrößern oder verkleinern (genau wie "Dynamic Resolution" beim Pi), müssen Sie dies im VNC-Viewer aktivieren. 

Im TigerVNC Viewer: Gehen Sie zu Options -> Expert und setzen Sie AutoSelect auf true (manchmal auch ResizeRemote genannt).
Im RealVNC Viewer: Gehen Sie zu Properties -> Expert und setzen Sie DynamicResolution auf True. 
Dann reicht es, das Fenster auf Ihrem lokalen PC zu ziehen; das Skript ist dann nicht mehr nötig, da der Server automatisch nachzieht (sofern der VNC-Server das unterstützt, was TigerVNC mit den oben genannten xrandr-Modi tut). 

