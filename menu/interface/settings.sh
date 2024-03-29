#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/install.sh
# Menu Interface
setstart() {

  emdisplay=$(cat /var/plexguide/emergency.display)
  switchcheck=$(cat /var/plexguide/pgui.switch)
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀  Settings Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Download Path    :  Change the Processing Location
[2] MultiHD          :  Add Multiple HDs and/or Mount Points to MergerFS
[3] Change Time      :  Change the Server Time

[4] PG UI            :  $switchcheck | Port 8555 | pgui.domain.com

[5] Emergency Display:  $emdisplay

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  # Standby
  read -p 'Type a Number | Press [ENTER]: ' typed </dev/tty

  case $typed in
  1)
    bash /opt/plexguide/menu/dlpath/dlpath.sh
    setstart
    ;;
  2)
    bash /opt/plexguide/menu/pgcloner/multihd.sh
    ;;
  3)
    dpkg-reconfigure tzdata
    ;;
  4)
    echo
    echo "Standby ..."
    echo
    if [[ "$switchcheck" == "On" ]]; then
      echo "Off" >/var/plexguide/pgui.switch
      docker stop pgui
      docker rm pgui
      service localspace stop
      rm -f /etc/systemd/system/localspace.servive
      rm -f /etc/systemd/system/localspace.service
    else
      echo "On" >/var/plexguide/pgui.switch
      bash /opt/plexguide/menu/pgcloner/solo/pgui.sh
      ansible-playbook /opt/pgui/pgui.yml
      service localspace start
    fi
    setstart
    ;;
  5)
    if [[ "$emdisplay" == "On" ]]; then
      echo "Off" >/var/plexguide/emergency.display
    else echo "On" >/var/plexguide/emergency.display; fi
    setstart
    ;;
  z)
    exit
    ;;
  Z)
    exit
    ;;
  *)
    setstart
    ;;
  esac

}

setstart
