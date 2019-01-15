#!/usr/bin/env bash

# create lookupfile
echo "Creating Lookupfile..."

TMP_FILE=${TMP}.tmp

echo "  |- generate ${TARGET}"

# choose ctags path first
echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/" > ${TMP_FILE}
if [ -f "${DEST}/data.files" ]; then
    FILES="${DEST}/data.files"
    cat ${FILES} | while read line
    do
        name=`basename $line`
        echo "${name}\t${line}\t1" >> "${TMP_FILE}"
    done
else
    if test "${FOLDERS}" != ""; then
        find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} ${IS_EXCLUDE} -regex ".*/("${FOLDERS}")/.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" -exec grep -Iq . {} \; -and -printf "%f\t%p\t1\n" >> "${TMP_FILE}"
    else
        find ${FORCE_POSIX_REGEX_1} . -type f -not -path "*/\.*" ${FORCE_POSIX_REGEX_2} -regex ".*\.("${FILE_SUFFIXS}")$" -exec grep -Iq . {} \; -and  -printf "%f\t%p\t1\n" >> "${TMP_FILE}"
    fi
    #find ${ROOT_DIR} -not -regex '.*\.\(png\|gif\)' -type f ! -path "./.*" ! -path "${ROOT_DIR}/out/*" -printf "%f\t%p\t1\n" >> ${TMP}
fi

if [ -f "${TMP_FILE}" ]; then
    echo "  |- move ${TMP_FILE} to ${TARGET}"
    mv -f "${TMP_FILE}" "${TARGET}"
fi

echo "  |- done!"
