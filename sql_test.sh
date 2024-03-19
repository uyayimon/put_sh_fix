#!/bin/bash

PUT_FILE="/mnt/d/sh/Numbering_test/xml_sample.xml"
echo ${PUT_FILE}

################################################################
# inputDateTimeの置換
################################################################
# 2024-03-19 00:00:00
NOW_DATE=$(date "+%Y-%m-%d %H:%M:%S")
echo "NOW: ${NOW_DATE}"

INPUT_TIME=$(cat ${PUT_FILE} | grep -o '<date>.*</date>' | sed -e 's/<date>\(.*\)<\/date>/\1/')
echo ${INPUT_TIME}

# 20240320
INPUT_TIME2=$(date -d "${INPUT_TIME}" "+%Y%m%d")

if (( ${INPUT_TIME2} < 20241119 )); then
  # 20240320
  echo "${NOW_DATE}"

  perl -pi -e "s/<date>${INPUT_TIME}<\/date>/<date>${NOW_DATE}<\/date>/" ${PUT_FILE}
  cat ${PUT_FILE}
else
  echo "そのままでよい"
fi


################################################################
# swiftRefNoの置換
################################################################
SWIFT_REF_BEF=$(cat ${PUT_FILE} | grep -o '<tag1>.*</tag1>' | sed -e 's/<tag1>\(.*\)<\/tag1>/\1/')

if [[ -z ${SWIFT_REF_BEF} ]]; then
  echo "Please check tag1."
  exit
fi
echo ${SWIFT_REF_BEF}

swift_ref_no=${SWIFT_REF_BEF}

while true; do

  swift_ref_in_db=$(mysql -uroot -p -N -e "select new_tablecol1 from test_db.new_table where new_tablecol1='${swift_ref_no}';")

  if [[ ! -z ${swift_ref_in_db} ]]; then
    echo "データベース上にすでに存在するswiftRefNoのため重複エラーが起きます。変更する場合は入力してください。"
    echo "あえて変更しない場合はこのままエンターを押してください"
    echo    "Old RefNo: ${swift_ref_in_db}"
    read -p "New RefNo: " swift_ref_new

    echo ${swift_ref_new}
    if [[ ! -z ${swift_ref_new} ]]; then
      swift_ref_no=${swift_ref_new}
    else
      break
    fi

  else
    break
  fi

done

if [[ ! -z ${swift_ref_new} ]]; then
  perl -pi -e "s/<tag1>${SWIFT_REF_BEF}<\/tag1>/<tag1>${swift_ref_no}<\/tag1>/" ${PUT_FILE}

fi

cat ${PUT_FILE} | grep -o '<tag1>.*</tag1>'
swift_ref_back=$(cat ${PUT_FILE} | grep -o '<tag1>.*</tag1>' | sed -e 's/<tag1>\(.*\)<\/tag1>/\1/')
perl -pi -e "s/<tag1>${swift_ref_back}<\/tag1>/<tag1>sample<\/tag1>/" ${PUT_FILE}
cat ${PUT_FILE} | grep -o '<tag1>.*</tag1>'


# mysql -u root -p -e "select new_tablecol1 from test_db.new_table;"

# mysql -uroot -p -N test_db <<EOF
#   select new_tablecol from new_table;
#   select new_tablecol1 from new_table;
# EOF


# value1=$(mysql -uroot -p -N -e "select new_tablecol1 from test_db.new_table;")
# echo ${value1}

# if [[ ${value1} == "sample" ]]; then
#   echo "HIT"
# else
#   echo "MISS"
# fi


# s/^.*(one).*$/\1 のように抽出したい条件をカッコで括り、マッチした順番で連番が振られるので \1 等で取得します
# cat /mnt/d/sh/Numbering_test/xml_sample.xml | grep -o '<tag1>.*</tag1>' | sed -e 's/<tag1>\(.*\)<\/tag1>/\1/'
