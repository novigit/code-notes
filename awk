#!/bin/bash

AWK
awk 'PREDICATE {CODEBLOCK}'
awk parses a file line by line by default

FS = Field Separator
Default FS is whitespace (space and tab characters)

# sets only tab or colon as field separator
awk -F "\t"
awk -F ":"

# print the 3rd field
awk '{print $3}'
# print the whole line
awk '{print $0}'

# print fields in whatever order
awk '{print $2 "\t" $1}'

# print line if 3rd field is greater than 98
awk 'if ($3 >= 98) {print $0}'
# short form
awk '$3 >= 98 {print $0}'

# print line if two conditions are true
awk 'if ( ($3 >= 0.3) && ($5 >= 0.3) ) {print $0}'
# short form
awk '$3 >= 0.3 && $5 >= 0.3 {print $0}'

# print line if 2nd field matches a regex
awk 'if ($2 ~ /regex/) {print $0}'
# short form
awk '$2 ~ /regex/ {print $0}'
# case insensitive regex
awk '$2 ~ /regex/i {print $0}'
# search for multiple strings
awk '$1 ~ /tig00000016|tig00000012|tig00000492/ {print $0}'
# search for anything except multiple strings
awk '$1 !~ /tig00000016|tig00000012|tig00000492/ {print $0}'

# if else statement
awk '{ if ($3 ~ /gene/) {print "\n"$0}  else {print $0} }'
# you can omit some curly braces like this
awk '{ if ($3 ~ /gene/)  print "\n"$0 ; else  print $0  }'
# using the ternary operator
## awk '{ print (condition) ? if_true : if_false }'
awk '{ print ($3 ~ /gene/) ? "\n"$0 : $0 }'

# apply a function
## length() returns the length the string held by $10 
awk '{print length($10)}'
## sub() does a search replace in defined field
## replace the first space with tab in the 15th field, then print the whole edited line
awk '{sub(" ","\t",$15); print $0}'

# pass on a variable from the shell
awk -v var="$shellvar" '$2 ~ var {print $0}'

# math operations
## if $9 is an integer, add a 1000 to its value when printing
awk '{print $9+1000}'

# calculate mean of a list of numbers
awk '{ sum += $1 } END { if (NR > 0) print sum / NR }'

# calculate stdev of a list of numbers
## '73' here is an example mean value
awk '{ sum += ($1-73)^2 } END { if (NR > 0) print sqrt(sum / NR) }'
## or if you don't know the mean a priori
awk '{ sum += $1 ; sumsq += $1*$1 } END { print sqrt(sumsq/NR - (sum/NR)**2) }'

# set Output Field Separator
## in print statement use commas!
awk 'OFS="\t" {print $3,$1,$2}'

# 'NR' refers to Number of Record
## by default the line number   
awk 'NR>2'

# BEGIN block followed by if else statement
## note that if else statement is within {}
## note that NF (number of fields in record)
##    (record is the line), so $NF returns $15 if there are 15 records
##    thus, $NF automatically means its the last column of the record
awk '
    BEGIN{OFS="\t"} {
    if ($7 == "+")
        {print $1,$2,$3,$4,$5,$6,$7,$8,$9" "$10" "$11" "$12";"$NF}
    else
        {print $1,$2,$3,$4,$5,$6,$7,$8,$9" "$10" "$13" "$12":"$NF}
    }
' 
# check if two consecutive lines have the same value in the same column
awk '$3==prev3 {print prevline; print $0; getline; print} {prev3 = $3; prevline = $0}' 01_curated_purged.gff3

# meaning of 'NF'
# NF is a predefined variable whose value is the number of fields in the current record.
# awk automatically updates the value of NF each time it reads a record.


# various awk statements
awk '{ for(i=1;i<=NF;i++){ print $i}}'      Merge multiple columns into single column
# Only print line numbers (Number Records) 3 and higher
l | awk 'NR>2'

NOTE: When filtering columns for fractions, i.e. $7 > 0.3, make sure that the input files decimal separators are DOTS, not COMMAS !!

NR      = Number of total records (default => record is one line)
FNR         = Number of file records
map[$1] = $2    = awk array (like a perl hash)

# print every 10th line
awk 'NR % 10 == 0' input > output
