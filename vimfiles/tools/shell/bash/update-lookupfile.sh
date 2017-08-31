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
    find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$"  -printf "%f\t%p\t1\n" >> "${TMP_FILE}"

    if [ "${FILE_SUFFIXS}" != __EMPTY__  ]; then
        find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2}  | grep  -v  "\.\w*$" |xargs -i sh -c 'file="{}";type=$(file $file);[ "$type" != "text" ] && echo $file'  -printf "%f\t%p\t1\n" >> "${TMP_FILE}"
    fi

else
    find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2}  -regex ".*\.("${FILE_SUFFIXS}")$"  -printf "%f\t%p\t1\n" >> "${TMP_FILE}"

    if [ "${FILE_SUFFIXS}" != __EMPTY__  ]; then
        find ${FORCE_POSIX_REGEX_1} ${ROOT_DIR} -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" |grep  -v  "\.\w*$" |xargs -i sh -c 'file="{}";type=$(file "$type");[ "$type" != "text" ] && echo $file'  -printf "%f\t%p\t1\n" >> "${TMP_FILE}"
    fi

fi
#find ${ROOT_DIR} -not -regex '.*\.\(png\|gif\)' -type f ! -path "./.*" ! -path "${ROOT_DIR}/out/*" -printf "%f\t%p\t1\n" >> ${TMP}

GREP_TMP_FILE=${TMP_FILE}.grep
cat ${TMP_FILE} | while read line
do
    LINE_TMP=$(echo "${line}" | cut -f 2 | egrep -v "*\.(png|jar|gif|jpg|zip|gz|so|o)$")
    if [ -n "$LINE_TMP" ];then
        echo  "${line}" >> "${GREP_TMP_FILE}"
    fi
done

if [ -f "${GREP_TMP_FILE}" ]; then
    echo "  |- move ${GREP_TMP_FILE} to ${TARGET}"
    rm ${TMP_FILE}
    mv -f "${GREP_TMP_FILE}" "${TARGET}"
fi

echo "  |- done!"
