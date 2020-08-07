#!/bin/bash

# Path to virtual disks. Note that there is no '/' after last folder.
HDD_PATH='/run/media/qbus/Data/Virt/'
# Got CDs like installer? Give it here
CDROM=''
# Samba filder, if You use
SAMBA="/run/media/qbus/Data/Virt/Samba_shared/"
# Options variable
OPTIONS=""

# Basoic options for QEMU I use
basic_options(){
  OPTIONS="-machine q35,accel=kvm -device intel-iommu -cpu host -smp 4,sockets=1,cores=2,threads=2 -display gtk,gl=on,show-cursor=on -vga qxl -soundhw hda -rtc clock=host,base=localtime -serial none -parallel none -drive if=pflash,format=raw,readonly,file=/usr/share/ovmf/x64/OVMF_CODE.fd -drive if=pflash,format=raw,file=/tmp/my_vars.fd -net nic,model=virtio -usb -device usb-tablet -audiodev id=pa,driver=pa"
}

# Append SAMBA functions
samba() {
  OPTIONS="${OPTIONS} -net user,smb=${SAMBA}"
}

# Append RA amount
memory_amount(){
  RAM=$1
  OPTIONS="${OPTIONS} -m ${RAM}"
}

# Append boot menu options
boot_menu(){
  OPTIONS="${OPTIONS} -boot menu=on"
}

# Append CD option
install_cd(){
  CDROM=$1
  OPTIONS="${OPTIONS} -cdrom ${CDROM}"
}

virtio_drivers(){
  VIRTION_PATH=$1
  OPTIONS="${OPTIONS} -drive if=ide,media=cdrom,format=raw,file=${VIRTION_PATH}"
}

mount_hdd(){
  HDD=$1
  OPTIONS="${OPTIONS} -drive file="$HDD",format=qcow2,cache=none"
}

menu(){
  echo "Select one of possible systems:"
  # Select all .qcow2 files in path
  select system in $HDD_PATH*.qcow2
  do
    echo 'What type of system is it? (win/linux)'
    read TYPE
    
    case "$TYPE"
    in "linux" | 'win' )
      echo 'This runs.'
      basic_options
      mount_hdd "$system"
      boot_menu
      memory_amount "1536M"
      samba
      break
    ;;
    # Not win/linux? Exit
    * )
      echo "Not found."
      exit 1
    ;;
    esac
  done
}

menu

qemu-system-x86_64 ${OPTIONS}
