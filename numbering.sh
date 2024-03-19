#!/bin/bash
LAST_STPNO_FILE="/mnt/d/sh/Numbering_test/last_stpNo.txt"
LAST_NO=$(cat ${LAST_STPNO_FILE} | awk -F '[-]' '{print $2}')

DATE=$(date +%Y%m%d)
LAST_DATE=$(cat ${LAST_STPNO_FILE} | awk -F '[-]' '{print $1}')

if [[ ${LAST_DATE} != ${DATE} ]]; then
    NO_AFT="000001"
else
    NO_AFT=$(echo ${LAST_NO} | awk '{printf "%06d\n",$1+1}')
fi

_STPNO=${DATE}-${NO_AFT}
echo ${_STPNO} | tee -i ${LAST_STPNO_FILE}
