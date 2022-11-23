# Notes(# bold size)
# the filename shoud called xxx.md so that the hightlight stuff can work
# how to write code inside the github => use \``` ``` this symbol to cover the code 
# use "\\" to esacpe some keys, just like regex
 

## Awk, grep, sed, Regex in Linux 

### Regex cheat sheet

https://scilifelab.github.io/courses/ngsintro/1809/files/Bash_cheat_sheet_level2.pdf

https://www.rexegg.com/regex-quickstart.html

#### Regex ```|``` in R: 

``` | => either or ```

Two regular expressions may be joined by the infix operator ‘⁠|⁠’; the resulting regular expression matches any string matching either subexpression. For example, ‘⁠abba|cde⁠’ matches either the string abba or the string cde. Note that alternation does not work inside character classes, where ‘⁠|⁠’ has its literal meaning.




### awk example:
https://www.geeksforgeeks.org/awk-command-unixlinux-examples/
```
NR (number of row)
‘NR==row/line number’
```
### print 4th line and concat into final txt
```
for i in *.txt ; do cat $i | awk 'NR==4' >> final.txt ; done
```
### how to spereate lines in awk?
https://askubuntu.com/questions/231995/how-to-separate-fields-with-space-or-tab-in-awk
##### tab-sep
```
awk {'print $5 "\t" $1'}
```
##### new line (enter seperate)
```
awk {‘print $5 “\n” $1'}
```

### how to add a character with awk?
https://stackoverflow.com/questions/12455116/how-to-add-a-character-at-the-end-of-each-line-with-awk


### awk to seperated the file name such as``` “file.txt” or “file.bam” to “file” ```
### awk -F , -F means --field-separator
### the `` is able to assign echo … to a variable 
https://stackoverflow.com/questions/34532677/how-to-assign-the-result-of-echo-to-a-variable-in-bash-script

``for i in *.bam; do sample_name=`echo $i | awk -F "." '{print $1}'`; samtools sort -@ 7 $i >  ${sample_name}.sorted.bam``

###  curl and variable in read line in linux
https://stackoverflow.com/questions/8865241/bash-curl-and-variable-in-the-middle-of-the-url

### awk print variable 
 https://linuxhint.com/awk_command_variables/

### EOF meaning 
#### ```cat << EOF > …..txt ```
#### ```cat << ‘__EOF__’ > ```
https://www.delftstack.com/howto/linux/cat-eof-in-bash/

### how to skip “#” in the file 
### using ```grep -v  ‘^#’```
https://stackoverflow.com/questions/8195950/reading-lines-in-a-file-and-avoiding-lines-with-with-bash


### double``` ‘//‘ ‘///‘ ``` in linux?
### the same with single /
https://unix.stackexchange.com/questions/1910/how-does-linux-handle-multiple-consecutive-path-separators-home-username'



### how to replace tab to new line ?
### tr command
### ```tr ‘\t’ ‘\n’ < input > output.txt```
https://unix.stackexchange.com/questions/49735/convert-a-tab-delimited-file-to-use-newlines


### grep, Extracting A Subset Of Sequences from fasta file based on word in id line
### ```awk '/^>/ { p = ($0 ~ /Eukaryota/)} p' test_db.fasta>new.fa```

### Extract fasta sequences from a file using a list in another file.
https://www.biostars.org/p/319099/
```$ grep -w -A 1 -Ff test.txt test.fa --no-group-separator```

### regex of linux using in grep 
https://ubuntu.com/blog/regex-basics
ex: 

```$cat test.tt | grep ">0[1-5 9]"```

>01_03_22...
>05_04_23..
>04_09_34_dase
>09_04_04_saslkmmdlkmd
>03_99_90_asddastatcgfg
>03_98_dd_dsfsfsf



