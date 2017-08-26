#!/usr/bin/env bash

# create cscope.out
echo "Creating Cscope..."

# choose cscope path first
if [ -f "${DEST}/data.files" ]; then
    FILES="-i ${DEST}/data.files"
# else
    # FILES="-R ."
fi

# process tags by langugage
echo "  |- generate ${TMP}"
echo "  |- ${CSCOPE_CMD} -f ${TMP} ${OPTIONS} ${FILES}"
${CSCOPE_CMD} -f ${TMP} ${OPTIONS} ${FILES}

# replace old file
if [ -f "${TMP}" ]; then
    echo "  |- move ${TMP} to ${TARGET}"
    mv -f "${TMP}" "${TARGET}"
fi

if [ -f "${TMP}.in" ]; then
    echo "  |- move ${TMP}.in to ${TARGET}.in"
    mv -f ${TMP}.in ${TARGET}.in
fi

if [ -f "${TMP}.po" ]; then
    echo "  |- move ${TMP}.po to ${TARGET}.po"
    mv -f ${TMP}.po ${TARGET}.po
fi

echo "  |- done!"
