#!/usr/bin/env bash

# create tags
echo "Creating Tags..."

# choose ctags path first
if [ -f "${DEST}/data.files" ]; then
    FILES="-L ${DEST}/data.files"
else
    FILES="-R ."
fi

# process tags by langugage
echo "  |- generate ${TMP}"
echo "  |- ${CTAGS_CMD} -o ${TMP} ${OPTIONS} ${FILES}"
${CTAGS_CMD} -o ${TMP} ${OPTIONS} ${FILES}

# replace old file
if [ -f "${TMP}" ]; then
    echo "  |- move ${TMP} to ${TARGET}"
    mv -f "${TMP}" "${TARGET}"
fi
echo "  |- done!"
