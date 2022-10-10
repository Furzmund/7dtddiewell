#!/bin/bash


ArrayToFile() {
    # Write the given array to a file
    # $1 = array
    # $2 = filename
    _names=$1[@]
    names=("${!_names}")
    printf "%s\n" "${names[@]}" >> $2
}


declare ROOT_7DTD=""
declare DEFAULT_7DTD_PATH="$HOME/.local/share/Steam/steamapps/common/7 Days To Die"

if [ -z "$1" ]; then
    echo "No 7DTD path given. Checking default path .."
    if [ ! -d "$DEFAULT_7DTD_PATH" ]; then
        echo "7DTD could not be found in the default path"
        read -p "Enter the path of 7DTD: " ROOT_7DTD
        if [ ! -d $ROOT_7DTD ]; then
            echo "Could not find 7DTD at given path"
            echo "  $ROOT_7DTD"
            exit 1
        fi
    else
        ROOT_7DTD="$DEFAULT_7DTD_PATH"
    fi
else
    ROOT_7DTD="$1"
fi

declare INSTALL_LIST=("Data/Config/items.xml" "Data/Config/recipes.xml" "Data/Config/vehicles.xml")
declare ARCHIVE_NAME="$ROOT_7DTD/backup.tar.gz"

if [ ! -f "$ARCHIVE_NAME" ]; then
    echo "Backing up original XML files .."
    ArrayToFile INSTALL_LIST backup.list
    tar -czvf "$ARCHIVE_NAME" --directory="$ROOT_7DTD" --files-from=backup.list
    echo
    echo "Backed up to"
    echo "  $ARCHIVE_NAME"
    rm backup.list
fi

echo
echo "Installing mod.."
echo
for i in "${INSTALL_LIST[@]}"; do
    cp --verbose $i "$ROOT_7DTD/$i"
done
echo
echo "done."
