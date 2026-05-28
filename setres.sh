Um die Auflösung so einfach zu wechseln wie beim Raspberry Pi (wo man oft nur ein Fenster zieht oder eine Einstellung wählt), müssen Sie die manuellen xrandr-Befehle in ein kleines Skript verpacken. 

Das folgende Skript fungiert als "Auflösungs-Menü". Sie müssen es nur einmal erstellen und können dann jederzeit bequem zwischen den Modi wechseln, ohne lange Befehle zu tippen. 

1. Das "Easy-Change" Skript erstellen
Erstellen Sie eine Datei namens setres in Ihrem Home-Verzeichnis. Dieses Skript fügt die Modi bei Bedarf hinzu und schaltet sofort um. 

cat <<EOF > ~/setres
#!/bin/bash
# Einfaches Skript zum Ändern der VNC-Auflösung

# Namen des VNC-Ausgangs automatisch erkennen (meist VNC-0 oder default)
SCREEN=\$(xrandr | grep " connected" | cut -d" " -f1)

# Funktion zum Hinzufügen und Wechseln
change_res() {
    RES=\$1
    # Modeline generieren (z.B. 1920x1080_60.00)
    MODELINE=\$(cvt \${RES%x*} \${RES#*x} 60 | grep Modeline | sed 's/Modeline //')
    MODENAME=\$(echo \$MODELINE | cut -d" " -f1 | tr -d '"')
    
    # Prüfen ob Modus schon existiert, sonst hinzufügen
    if ! xrandr | grep -q "\$MODENAME"; then
        xrandr --newmode \$MODELINE
        xrandr --addmode \$SCREEN \$MODENAME
    fi
    
    # Auflösung setzen
    xrandr --output \$SCREEN --mode \$MODENAME
    echo "Auflösung geändert auf: \$RES"
}

# Menü-Anzeige
case "\$1" in
    1920x1080) change_res "1920x1080" ;;
    1600x900)  change_res "1600x900" ;;
    1280x720)  change_res "1280x720" ;;
    800x600)   change_res "800x600" ;;
    *)
        echo "Verwendung: \$0 [1920x1080|1600x900|1280x720|800x600]"
        echo "Beispiel: \$0 1920x1080"
        exit 1
        ;;
esac
EOF

# Skript ausführbar machen
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

