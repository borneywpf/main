#!/usr/bin/env bash

# create lookupfile
echo "Creating Lookupfile..."

# test posix regex
find ./ -maxdepth 1 -regextype posix-extended -regex "test" > /dev/null 2>&1
if test "$?" = "0"; then
    FORCE_POSIX_REGEX_1=""
    FORCE_POSIX_REGEX_2="-regextype posix-extended"
else
    FORCE_POSIX_REGEX_1="-E"
    FORCE_POSIX_REGEX_2=""
fi

echo "  |- generate ${TARGET}"
echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/" > ${TMP}
find ./ -not -regex '.*\.\(png\|gif\)' -type f ! -path "./.*" ! -path "./out/*" -printf "%f\t%p\t1\n" >> ${TMP}

if [ -f "${TMP}" ]; then
    echo "  |- move ${TMP} to ${TARGET}"
    mv -f "${TMP}" "${TARGET}"
fi

echo "  |- done!"
