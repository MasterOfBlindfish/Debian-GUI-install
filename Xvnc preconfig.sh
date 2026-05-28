Hier ist die vollständige Befehlsliste als kopierbare Blöcke, um TigerVNC mit dynamischer Auflösung auf Ihrem Debian-System einzurichten und optional mit NoMachine zu verbinden.

1. Installation der Pakete
Installieren Sie den VNC-Server und (optional) den NoMachine-Server für eine performantere Verbindung.

sudo apt update
sudo apt install tigervnc-standalone-server tigervnc-common
# Optional: NoMachine Server installieren (nach Download des .deb Pakets von nomachine.com)
# sudo dpkg -i nomachine_*.deb

2. VNC-Passwort setzen
Legen Sie das Passwort fest, das Sie beim Verbinden eingeben müssen.

vncpasswd

3. Konfiguration für dynamische Auflösungen
Erstellen Sie die Konfigurationsdatei, um mehrere Auflösungen (randr) zu definieren, die Sie später live wechseln können.

mkdir -p ~/.vnc
cat <<EOF > ~/.vnc/config
geometry=1920x1080
randr=1920x1080,1600x900,1280x720,800x600
session=plasma
EOF

(Hinweis: session=plasma startet KDE. Für XFCE nutzen Sie session=xfce, für GNOME session=gnome).

4. VNC-Server starten
Starten Sie die Sitzung. Der Server läuft nun im Hintergrund auf Display :1.

vncserver :1

5. Firewall öffnen (netcup VPS)
Falls eine Firewall aktiv ist, geben Sie den VNC-Port (5901 für Display :1) und ggf. NoMachine (4000) frei.

sudo ufw allow 5901/tcp
sudo ufw allow 4000/tcp
# Oder direkt in der netcup Firewall im Webinterface die Ports 5901 und 4000 freigeben

6. Auflösung während des Betriebs ändern
Sobald Sie verbunden sind, können Sie die Auflösung ohne Neustart ändern.

Option A: Über das Terminal (innerhalb der VNC-Sitzung)

xrandr -s 1600x900
# Oder andere verfügbare Größe aus der config-Liste

Option B: Über die KDE-Einstellungen Einfach im Menü nach "Anzeige" suchen und die gewünschte Auflösung auswählen (diese erscheinen dank der randr-Einstellung in der Liste).

7. Verbindung herstellen
Via VNC-Viewer: Verbinden Sie sich mit IP-Adresse:5901 (oder IP-Adresse:1).
Via NoMachine: Fügen Sie eine neue Verbindung hinzu, wählen Sie Protokoll VNC (falls NoMachine die Sitzung nicht automatisch als NX erkennt) und geben Sie IP-Adresse sowie Port 5901 ein.
Zusatz: Server stoppen oder neu starten
Falls Sie die Konfiguration ändern wollen, müssen Sie die Sitzung vorher beenden.

# Sitzung :1 beenden
vncserver -kill :1

# Danach neu starten mit:
vncserver :1

