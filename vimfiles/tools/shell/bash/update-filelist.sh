#!/usr/bin/env bash

# create files
echo "Creating Filelist..."

ROOT_DIR=`pwd`

# test posix regex
find $ROOT_DIR -maxdepth 1 -regextype posix-extended -regex "test" > /dev/null 2>&1
if test "$?" = "0"; then
    FORCE_POSIX_REGEX_1=""
    FORCE_POSIX_REGEX_2="-regextype posix-extended"
else
    FORCE_POSIX_REGEX_1="-E"
    FORCE_POSIX_REGEX_2=""
fi

# get filelist
echo "  |- generate ${TMP}"

TMP_FILE="${TMP}".tmp

if test "${FOLDERS}" != ""; then
    find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" > "${TMP_FILE}"
    if [ "${FILE_SUFFIXS}" != __EMPTY__  ]; then
        find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2}  | grep  -v  "\.\w*$" |xargs -i sh -c 'file="{}";type=$(file $file);[ "$type" != "text" ] && echo $file' >> "${TMP_FILE}"
    fi

else
    find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" > "${TMP_FILE}"

    if [ "${FILE_SUFFIXS}" != __EMPTY__  ]; then
        find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" |grep  -v  "\.\w*$" |xargs -i sh -c 'file="{}";type=$(file "$type");[ "$type" != "text" ] && echo $file' >> "${TMP_FILE}"
    fi
fi
egrep -i -v '*\.(png|jar|gif|jpg|zip|tar.gz|tar|rar|exe|pyc|so|o|dll)$' ${TMP_FILE} > "${TMP}"

echo "  |- generate ${DATA_TMP}"

DATA_TMP_FILE="${DATA_TMP}".tmp

if test "${FOLDERS}" != ""; then
     find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" > "${DATA_TMP_FILE}"
else
   find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" > "${DATA_TMP_FILE}"
fi

egrep -i '*\.(java|c|cpp|h|l|y|cc)$' ${DATA_TMP_FILE} > "${DATA_TMP}"

# DISABLE
# # find . -type f -not -path "*/\.*" > "${TMP}"
# if [ -f "${TMP}" ]; then
#     echo "  |- filter by gawk ${TMP}"
#     gawk -v file_filter=${FILE_FILTER_PATTERN} -v folder_filter=${FOLDER_FILTER_PATTERN} -f "${TOOLS}/gawk/file-filter-${GAWK_SUFFIX}.awk" "${TMP}">"${TMP2}"
#     rm "${TMP}"
# fi


# replace old file
if [ -f "${TMP}" ]; then
    echo "  |- move ${TMP} to ${TARGET}"
    rm ${TMP_FILE}
    mv -f "${TMP}" "${TARGET}"
fi

if [ -f "${DATA_TMP}" ]; then
    echo "  |- move ${DATA_TMP} to ${DATA_TARGET}"
    rm ${DATA_TMP_FILE}
    mv -f "${DATA_TMP}" "${DATA_TARGET}"
fi

if [ -f "${TARGET}" ]; then
    echo "  |- generate ${ID_TARGET}"
    gawk -f "${TOOLS}/gawk/null-terminal-files.awk" "${TARGET}">"${ID_TARGET}"
fi

echo "  |- done!"
