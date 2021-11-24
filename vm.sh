#!/bin/sh

# VM script
# Joe Lewis 2021
#
# CMD interface for starting gaming vm, attaching/detaching usb devices, and
# starting scream (audio daemon)

DOMAIN="win10"
VIRSH_PREFIX="virsh -c qemu:///system"
KB_ATTACH=0
M_ATTACH=0
SOUND_STARTED=0

KB_XML=$(cat <<-END
<hostdev mode="subsystem" type="usb" managed="yes">
  <source>
    <vendor id="0x1b80"/>
    <product id="0xb514"/>
  </source>
</hostdev>
END
)

M_XML=$(cat <<-END
<hostdev mode="subsystem" type="usb" managed="yes">
  <source>
    <vendor id="0x1b1c"/>
    <product id="0x1b5a"/>
  </source>
</hostdev>
END
)

usage() {
  echo "VM Control Script"
  echo "Controls"
  echo "P: Power on"
  echo "O: Power off"
  echo "S: Switch to VM"
  echo "W: Switch back to Host"
  echo "K: Attach/Detach Keyboard"
  echo "M: Attach/Detach Mouse"
  echo "D: Start sound daemon (scream)"
  echo "F: Stop sound daemon (scream)"
}

virsh_command() {
  eval "$VIRSH_PREFIX $@"
}

run_cmd() {
  C=$1
  if [ "$C" = "P" ]; then
    virsh_command start $DOMAIN
  elif [ "$C" = "O" ]; then
    virsh_command shutdown $DOMAIN
  elif [ "$C" = "S" ]; then
    # Switch from host to vm
    # Attach keyboard and mouse
    run_cmd "K"
    run_cmd "M"

    # Turn off screensaver
    xset s off

    # Turn off VGA output
    xrandr --output VGA1 --off
    xrandr --output HDMI3 --primary

  elif [ "$C" = "W" ]; then
    # Switch from VM to host
    # Detach keyboard and mouse
    run_cmd "K"
    run_cmd "M"

    # Turn off screensaver
    xset s on

    # Turn on VGA output
    xrandr --output VGA1 --primary --mode 1920x1080
    xrandr --output HDMI3 --mode 1920x1080 --left-of VGA1

  elif [ "$C" = "K" ]; then
    # Attach/Detach Keyboard
    KB_FILE=$PWD/tmp_kbd
    echo $KB_XML > $KB_FILE
    if [ $KB_ATTACH -eq 0 ]; then
      virsh_command attach-device $DOMAIN $KB_FILE --live
      KB_ATTACH=1
    else
      virsh_command detach-device $DOMAIN $KB_FILE --live
      KB_ATTACH=0
    fi
    rm -f $KB_FILE
  elif [ "$C" = "M" ]; then
    # Attach/Detach Mouse
    M_FILE=$PWD/tmp_m
    echo $M_XML > $M_FILE
    if [ $M_ATTACH -eq 0 ]; then
      virsh_command attach-device $DOMAIN $M_FILE --live
      M_ATTACH=1
    else
      virsh_command detach-device $DOMAIN $M_FILE --live
      M_ATTACH=0
    fi
    rm -f $M_FILE
  elif [ "$C" = "D" ]; then
    # Start sound daemon
    if pgrep -c scream > /dev/null; then
      echo "Scream already running"
    else
      scream -i virbr0 & 
      echo "Scream started"
      SOUND_STARTED=1
    fi
  elif [ "$C" = "F" ]; then
    pkill scream
  fi

}

usage
while true; do
  read -s -N 1 C
  C=${C^^} # convert to uppercase
  run_cmd $C
done
