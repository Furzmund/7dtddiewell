#!/bin/bash


ArrayToFile() {
    # Write the given array to a file
    # $1 = array
    # $2 = filename
    _names=$1[@]
    names=("${!_names}")
    printf "%s\n" "${names[@]}" >> $2
}

INSTALL_ROOT="/mnt/shared/games/steamapps/common/7 Days To Die"

INSTALL_LIST=("Data/Config/items.xml" "Data/Config/recipes.xml" "Data/Config/vehicles.xml")

ARCHIVE_NAME="$INSTALL_ROOT/backup.tar.gz"

if [ ! -f "$ARCHIVE_NAME" ]; then
    echo "Backing up original XML files .."
    ArrayToFile INSTALL_LIST backup.list
    tar -czvf "$ARCHIVE_NAME" --directory="$INSTALL_ROOT" --files-from=backup.list
    echo
    echo "Backed up to"
    echo "  $ARCHIVE_NAME"
    rm backup.list
fi

echo
echo "Installing mod.."
echo
for i in "${INSTALL_LIST[@]}"; do
    cp --verbose $i "$INSTALL_ROOT/$i"
done
echo
echo "done."