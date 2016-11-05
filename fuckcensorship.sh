#!/bin/bash

set -o nounset
set -o errexit

GNU_SED=/usr/gnu/bin/sed
MAC_PERL=/usr/bin/perl
SED_EXEC=sed

FOLDER_IN=./IN
FOLDER_OUT=./OUT

# OS handling borrowed from http://thegreyblog.blogspot.co.uk/2010/09/shell-script-to-find-and-remove-bom.html
if [ "$(uname)" == "SunOS" ] ; then
    if [ ! -x $GNU_SED ] ; then
        echo "Couldn't find GNU sed!"
        exit 1
    fi
    echo "Using GNU sed..."
    SED_EXEC=$GNU_SED  
fi

if [ "$(uname)" == "Darwin" ]; then
    if [ ! -x $MAC_PERL ]; then
        echo "Couldn't find perl!"
        exit 1
    fi
    SED_EXEC="$MAC_PERL -pe"
fi

if [ ! -d $FOLDER_IN ]; then
    echo "$FOLDER_IN is missing!"
    exit 2
fi
if [ ! -d $FOLDER_OUT ]; then
    echo "$FOLDER_OUT is missing!"
    exit 2
fi

for book in $FOLDER_IN/*.txt; do
    echo "Processing $book..."
    FILE_OUT=$FOLDER_OUT/$(basename "$book" .txt).censored.txt
    # https://www.npmjs.com/package/redactkit for introducing me to unicode FULL BLOCK character
    $SED_EXEC  's/\S/\xE2\x96\x88/g' < "$book" > "$FILE_OUT"
done

echo "Done! I hope you're proud of yourself!"