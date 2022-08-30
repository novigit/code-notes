#!/bin/bash

GNU SED

'''
- sed stands for stream editor
- sed has two buffers: the pattern buffer & the hold buffer. Both are initially empty
- execution cycle:
    1. read line from file or stdin
    2. remove any trailing newline
    3. store line in pattern buffer
    4. modify pattern buffer according to user instructions
    5. print pattern buffer to stdout
'''

# sed 's///' #
sed 's/PATTERN/REPLACE/' file > outfile

# by default sed will only replace the first hit in a line
# to replace all hits in a line, set it to (g)lobal
sed 's/PATTERN/REPLACE/g' file > outfile

# do case-insensitive search
sed 's/PATTERN/REPLACE/i' file > outfile

# any character works as delimiter in sed, besides the default '/'
sed 's|PATTERN|REPLACE|g' file > outfile 
# tip: if you want to replace a PATTERN expressed as a $STRING, and the $STRING contains '/', use a different delimiter instead

# you can surround the sed command with ' or "
# use " if the command includes bash variables like $STRING
sed "s/$SEARCH/$REPLACE/"

# change the file in-place
sed -i 's/PATTERN/REPLACE/g' file

# use extended regular expressions (ERE)
sed -r 's/PATTERN/REPLACE/g' 
sed -E 's/PATTERN/REPLACE/g' 

# only do replacements in lines that match PATTERN
sed '/PATTERN/ s/SEARCH/REPLACE/g'

# do replacements in all lines except those that match PATTERN
sed '/PATTERN/! s/SEARCH/REPLACE/g'

# do multiple replacements at once
sed -e "s/_R_//" -e "s/,/_/"
sed "s/_R_// ; s/,/_/" 
## note that the second -e assumes the state of the file contents after the first -e, and so on

# do replacements only between certain lines
## only replace 'foo' with 'bar' between line numbers 100 and 200
sed '100,200{s/foo/bar/}'      
# only replace 'foo' with 'bar' between lines 100 and the first line that matches 'foo'
sed '100,/foo/{s/foo/bar/}'    

# delete lines that match PATTERN
sed 's/PATTERN/d' file

# capture a part of a search string, and use it in the replacement string
## the backreference \1 contains the content of the first regexp (.+) 
## the backreference \2 contains the content of the second regexp ([0-9]+)
sed -r 's/(.+)_([0-9]+)/\2_\1/'
## if you use extended regular expressions, '(' is assumed to have the special meaning
## if you do not use them, you have to give them special meaning with the '\', so '\(' and '\)'

# replaces 3rd occurrence of _ in the line with a tab
sed "s/_/\t/3"      
# replaces 3rd occurrence until last occurrence of _ in the line with a tab
sed "s/_/\t/g3"     

# find the line with the word 'exon', then go to the next line and do a search replace there
sed '/exon/{n;s/SEARCH/REPLACE/}'   

# introduce a new first line that contains "foo"
sed "1s/^/foo\n/"


# sed -n #

## -n supresses automatic printing of pattern space (= pattern buffer ?)
## (step 5 in the default execution cycle)
## p invokes printing of pattern buffer

# general syntax || sed -n 'ADDRESS'p
# general syntax || sed -n '/PATTERN/p'

# prints line number 3
sed -n '3'p               

# prints lines in range 3,5
sed -n '3,5'p

# prints from line 3 to the last line
sed -n '3,$'p

# prints every second line, starting from line 3
sed -n '3~2'p

# prints the last line of the file
sed -n '$'p

# print line that matches PATTERN
sed -n '/PATTERN/p'

# general syntax || sed -n '/PATTERN/,ADDRESS'

# print from line that matches PATTERN until 6 lines after that
sed -n '/PATTERN/,6p'

# general syntax || sed -n 'ADDRESS,/PATTERN/'

# print from third line until line that matches PATTERN
sed -n '3,/PATTERN/p'


# sed 'y///' #

# y/// means that each character is replaced separately, kind of like tr (?)
sed "/^>/! y/acgt/ACGT/" 

# USEFUL SNIPPETS

# convert rna sequences to dna sequences in a FASTA file
sed '/^>/! s/U/T/gi' rna.fasta > dna.fasta

# delete empty lines
sed "s/^$/d"

# NOTES

## sed on MacOS
### sed on MacOS is NOT GNU sed, and will behave very strangely if you are not aware of this
### to circumvent this issue, simply install GNU sed with brew
### brew install coreutils







