#!/bin/bash
# Convert Chromium .CRX file to .ZIP, v1.1
# Rowan H - 8/20/2015

# This is a simple one shot bash script that uses: hexdump, sed and dd to
# create a .ZIP archive from a .CRX file
# my implementation is far from perfect and its possible if PK is
# referenced sooner in the header the file header than its suppose to be
# the creation using *dd* may fail.


function checkDeps(){
echo "Checking for required programs for script to work..."
type hexdump sed  >/dev/null || echo "Your missing a dependency, make sure you have *sed* and *hexdump* installed."
}

checkDeps


clear

RED='\033[0;31m'
echo
printf "${RED}CRX 2 ZIP\n"
echo
echo
echo
read -p "Enter the .CRX file path then press (Enter): " -i "$PWD/" -e crxPath
echo

getPK=$(hexdump -C $crxPath | grep 'PK' | sed -e 's/^\(.\{8\}\).*/\1/' | sed -n '1p')
echo "PK-Address found at: $getPK"

# Passes address to 'dd' to handle the rest

zipContainerName=$(echo ${crxPath::-4})

echo "Exporting our patched ZIP file to '.' "

dd if=$crxPath of=$zipContainerName.zip bs=1 skip=$getPK
echo
echo
echo "You can now decompress your ZIP archive..."

exit