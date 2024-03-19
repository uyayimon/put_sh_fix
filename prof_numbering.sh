#!/bin/bash

. /mnt/d/sh/Numbering_test/last_numbering.prof

echo ${TEST1}
echo ${TEST2}
echo ${TEST3}
echo ${_SAMPLE_NO:-99999}

_STPNO=${DATE}-${NO_AFT:-000001}
echo ${_STPNO} | tee -i ${LAST_STPNO_FILE}
