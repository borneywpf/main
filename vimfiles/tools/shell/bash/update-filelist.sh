#!/usr/bin/env bash

# create files
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

echo "Find Os:"${machine}

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
    if [ "${machine}" = "Linux" ]; then
        echo "  |- find ${FORCE_POSIX_REGEX_1} . -type f -not -path \"*/\.*\" ${FORCE_POSIX_REGEX_2} -regex \".*\.(\"${FILE_SUFFIXS}\")$\" -exec grep -Iq . {} \; -and -print > \"\"${TMP}\""
        find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" -exec grep -Iq . {} \; -and -print > "${TMP}"
    elif [ "${machine}" = "Mac" ]; then
        echo "  |- find ${FORCE_POSIX_REGEX_1} . -type f -not -path \"*/\.*\" ${FORCE_POSIX_REGEX_2} -regex \".*\.(\"${FILE_SUFFIXS}\")$\" -exec grep -Il \"\" {} \; -and -print > \"\"${TMP}\""
        find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" -exec grep -Il "" {} \; -and -print > "${TMP}"
    else
        echo "  |- find ${FORCE_POSIX_REGEX_1} . -type f -not -path \"*/\.*\" ${FORCE_POSIX_REGEX_2} -regex \".*\.(\"${FILE_SUFFIXS}\")$\" -exec grep -Iq . {} \; -and -print > \"\"${TMP}\""
        find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" -exec grep -Iq . {} \; -and -print > "${TMP}"
    fi

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
    echo "  |- cp ${TARGET} to ${DATA_TARGET}"
    cp "${TARGET}" "${DATA_TARGET}"
fi

if [ -f "${TARGET}" ]; then
    echo "  |- generate ${ID_TARGET}"
    gawk -f "${TOOLS}/gawk/null-terminal-files.awk" "${TARGET}">"${ID_TARGET}"
fi

echo "  |- done!"
