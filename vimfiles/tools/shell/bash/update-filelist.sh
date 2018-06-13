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
    find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" -exec grep -Iq . {} \; -and -print > "${TMP}"
else
    find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" -exec grep -Iq . {} \; -and -print > "${TMP}"

fi

echo "  |- generate ${DATA_TMP}"

if test "${FOLDERS}" != ""; then
    find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" -exec grep -Iq . {} \; -and -print > "${DATA_TMP}"
else
    find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" -exec grep -Iq . {} \; -and -print > "${DATA_TMP}"
fi


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
    mv -f "${TMP}" "${TARGET}"
fi

if [ -f "${DATA_TMP}" ]; then
    echo "  |- move ${DATA_TMP} to ${DATA_TARGET}"
    mv -f "${DATA_TMP}" "${DATA_TARGET}"
fi

if [ -f "${TARGET}" ]; then
    echo "  |- generate ${ID_TARGET}"
    gawk -f "${TOOLS}/gawk/null-terminal-files.awk" "${TARGET}">"${ID_TARGET}"
fi

echo "  |- done!"
