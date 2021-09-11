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
  echo "S: Power on"
  echo "O: Power off"
  echo "K: Attach/Detach Keyboard"
  echo "M: Attach/Detach Mouse"
  echo "D: Start sound daemon (scream)"
  echo "F: Stop sound daemon (scream)"
}

virsh_command() {
  eval "$VIRSH_PREFIX $@"
}

usage
while true; do
  read -s -N 1 C
  C=${C^^} # convert to uppercase

  if [ "$C" = "S" ]; then
    virsh_command start $DOMAIN
  elif [ "$C" = "O" ]; then
    virsh_command shutdown $DOMAIN
  elif [ "$C" = "K" ]; then
    # Attach/Detach Keyboard
    echo $KB_XML > tmp
    if [ $KB_ATTACH -eq 0 ]; then
      virsh_command attach-device $DOMAIN $PWD/tmp --live
      KB_ATTACH=1
    else
      virsh_command detach-device $DOMAIN $PWD/tmp --live
      KB_ATTACH=0
    fi
    rm tmp
  elif [ "$C" = "M" ]; then
    # Attach/Detach Mouse
    echo $M_XML > tmp
    if [ $M_ATTACH -eq 0 ]; then
      virsh_command attach-device $DOMAIN $PWD/tmp --live
      M_ATTACH=1
    else
      virsh_command detach-device $DOMAIN $PWD/tmp --live
      M_ATTACH=0
    fi
    rm tmp
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
done
