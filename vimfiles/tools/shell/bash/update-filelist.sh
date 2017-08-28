#!/usr/bin/env bash

# create files
echo "Creating Filelist..."

# test posix regex
find . -maxdepth 1 -regextype posix-extended -regex "test" > /dev/null 2>&1
if test "$?" = "0"; then
    FORCE_POSIX_REGEX_1=""
    FORCE_POSIX_REGEX_2="-regextype posix-extended"
else
    FORCE_POSIX_REGEX_1="-E"
    FORCE_POSIX_REGEX_2=""
fi

# get filelist
echo "  |- generate ${TMP}"

echo FOLDERS=${FOLDERS}
echo FORCE_POSIX_REGEX_1=${FORCE_POSIX_REGEX_1}
echo FORCE_POSIX_REGEX_2=${FORCE_POSIX_REGEX_2}
echo IS_EXCLUDE=${IS_EXCLUDE}
echo FILE_SUFFIXS=${FILE_SUFFIXS}
echo TMP=${TMP}
echo TARGET=${TARGET}
echo DATA_TMP=${DATA_TMP}
echo DATA_TARGET=${DATA_TARGET}

if test "${FOLDERS}" != ""; then
    find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" > "${TMP}"

    if [[ "${FILE_SUFFIXS}" != __EMPTY__ ]]; then
        find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2}  |grep  -v  "\.\w*$" |xargs -i sh -c 'file="{}";type=$(file $file);[[ $type =~ "text" ]] && echo $file' >> "${TMP}"
    fi

else
    find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" > "${TMP}"

    if [ "${FILE_SUFFIXS}" != __EMPTY__  ]; then
        find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" |grep  -v  "\.\w*$" |xargs -i sh -c 'file="{}";type=$(file $file);[ "$type" != "text" ] && echo $file' >> "${TMP}"
    fi

fi

echo "  |- generate ${DATA_TMP}"
     find ${FORCE_POSIX_REGEX_1} .  -type f -not -path "./.*" -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.h' -o -name "*.cc" -o -name "*.l" -o -name "*.y" | egrep -v "\/out\/" | sort -f >${DATA_TMP}

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
