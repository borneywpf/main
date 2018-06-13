#!/usr/bin/env bash

# create lookupfile
echo "Creating Lookupfile..."

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

echo "  |- generate ${TARGET}"

TMP_FILE=${TMP}.tmp

echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/" > ${TMP_FILE}
if test "${FOLDERS}" != ""; then
    find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" -exec grep -Iq . {} \; -and -printf "%f\t%p\t1\n" >> "${TMP_FILE}"
else
    find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" -exec grep -Iq . {} \; -and  -printf "%f\t%p\t1\n" >> "${TMP_FILE}"
fi
#find ${ROOT_DIR} -not -regex '.*\.\(png\|gif\)' -type f ! -path "./.*" ! -path "${ROOT_DIR}/out/*" -printf "%f\t%p\t1\n" >> ${TMP}

if [ -f "${TMP_FILE}" ]; then
    echo "  |- move ${TMP_FILE} to ${TARGET}"
    mv -f "${TMP_FILE}" "${TARGET}"
fi

echo "  |- done!"
