
### PDC


- Download crendital .json  

Now you need to create gen3-client API key from   [https://icgc.bionimbus.org](https://icgc.bionimbus.org/) after authentication via NIH eRA commons. To do that goto   [login page](https://icgc.bionimbus.org/login), and click on "Login with NIH" button. After authenticated successfully, please goto   [https://icgc.bionimbus.org/identity](https://icgc.bionimbus.org/identity) to create the API key. On the popup dialog click on "Download json" to retrive API key

  
### setup 


```
gen3-client configure --profile=<profilename> --_apiendpoint=_[_https://icgc_._bionimbus_._org/_](https://icgc.bionimbus.org/)
```


### once finished, test download single UUID or manifest
  
## 46 TCGA_BLCA location 

[https://icgc.bionimbus.org/files](https://icgc.bionimbus.org/files)


### steps

[https://gen3.org/resources/user/gen3-client/#4-download-a-single-data-file-using-a-guid](https://gen3.org/resources/user/gen3-client/#4-download-a-single-data-file-using-a-guid)

```
gen3-client download-single --guid=(GUID) --profile=<profilename> --no-prompt 
```

```
gen3-client download-multiple --profile=<profilename> —manifest=manifestfile --no-prompt

```



----

### GDC  CCLE
- biowulf/helix 

```

module load gdc-client

cd /data/leec20/gdc_ccle/

# for manifest file
gdc-client download -m bladder_ccle_1_to_10.txt

# for indiviual data
gdc-client download 32c43be9-d2d8-4ce5-8f16-6651c0df6f84


```

