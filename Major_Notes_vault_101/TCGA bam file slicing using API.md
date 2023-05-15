
[folder_locate](file://Users/leec20/Desktop/Done_projects/TCGA_WXS_slice_API/)

https://docs.gdc.cancer.gov/API/Users_Guide/BAM_Slicing/

- Code example:
```

token=$(<gdc-user-token.2022-03-09T17_15_08.189Z.txt)

cat list.txt | while read line

#the text in list.txt look like this: file_ID file_name
#00045607-0ec2-4b64-acf6-8effdca8d237	C500.TCGA-DK-A3IT-01A-31D-A20D-08.1_gdc_realn.bam

do
line="${line%$cr}"

sam1=`echo $line| awk '{print $1}'`
sam2=`echo $line| awk '{print $2}'`

curl --header "X-Auth-Token: $token" "https://api.gdc.cancer.gov/slicing/view/${sam1}?region=chr1:108497000-112378000&region=chr4:10000-6039000" --output ${sam2}

echo "done running!"

done
```


- In terminal exampe:

```
token=$(<gdc-user-token.2022-03-09T17_15_08.189Z.txt)

curl --header "X-Auth-Token: $token" "https://api.gdc.cancer.gov/slicing/view/47537107-3d29-416c-886d-da2efb942a2a?region=chr5:10000-4840000" --output ./output.bam
 
```