#!/bin/bash
cr=$'\r'

token=$(<gdc-user-token.2022-03-09T17_15_08.189Z.txt)

cat kid_test.txt | while read line

do
line="${line%$cr}"
#url=https://api.gdc.cancer.gov/slicing/view/
sam1=`echo $line| awk '{print $1}'`
sam2=`echo $line| awk '{print $2}'`

curl --header "X-Auth-Token: $token" "https://api.gdc.cancer.gov/slicing/view/${sam1}?region=chr1:108497000-112378000&region=chr4:10000-6039000" --output ${sam2}

echo "done running!"

done

