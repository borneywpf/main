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

ROOT_DIR=`pwd`

echo "  |- generate ${TARGET}"
echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/" > ${TMP}
if test "${FOLDERS}" != ""; then
    find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$"  -printf "%f\t%p\t1\n" > "${TMP}"

    if [ "${FILE_SUFFIXS}" != __EMPTY__  ]; then
        find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2}  | grep  -v  "\.\w*$" |xargs -i sh -c 'file="{}";type=$(file $file);[ "$type" != "text" ] && echo $file'  -printf "%f\t%p\t1\n" >> "${TMP}"
    fi

else
    find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2}  -regex ".*\.("${FILE_SUFFIXS}")$"  -printf "%f\t%p\t1\n" > "${TMP}"

    if [ "${FILE_SUFFIXS}" != __EMPTY__  ]; then
        find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" |grep  -v  "\.\w*$" |xargs -i sh -c 'file="{}";type=$(file "$type");[ "$type" != "text" ] && echo $file'  -printf "%f\t%p\t1\n" >> "${TMP}"
    fi

fi
#find ${ROOT_DIR} -not -regex '.*\.\(png\|gif\)' -type f ! -path "./.*" ! -path "${ROOT_DIR}/out/*" -printf "%f\t%p\t1\n" >> ${TMP}

if [ -f "${TMP}" ]; then
    echo "  |- move ${TMP} to ${TARGET}"
    mv -f "${TMP}" "${TARGET}"
fi

echo "  |- done!"
