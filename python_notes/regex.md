Regex module

https://github.com/mrabarnett/mrab-regex

Essentially an extension of the built-in `re` module
Most if not all `re` functions exist in the `regex` module,
but the `regex` module has some additional functionality.

Most notably, the ability for fuzzy matching, or,
allowing for a certain number of mismatches when searching
for strings matching your regular expression

#### Load the module
```py
import regex as re
```

#### Example regular expressions
```py
# match the motif exactly
'TGTTTGTT'

# allow for insertions
(?:TGTTTGTT){i}

# allow for deletions
(?:TGTTTGTT){d}

# allow for substitutions
(?:TGTTTGTT){s}

# allow for insertions and substitutions
(?:TGTTTGTT){i,s}

# allow for errors (insertions, deletions or substitutions)
(?:TGTTTGTT){e}

# allow for up to 1 insertions and 2 substitutions, but no deletions
(?:TGTTTGTT){i<=1,s<=2}

# allow for at least 1 error (?) and at the most 3 errors 
(?:TGTTTGTT){1<=e<=3}

# allow for up to 2 substitution
(?:TGTTTGTT){s<=2}

# only report matches with exactly 2 substitutions
# not sure if this works, needds to be confirmed
(?:TGTTTGTT){2<=s<=2}
# this does not seem to work in any case:
(?:TGTTTGTT){s==2}
```

#### Finding matches with re.match()

```py
# does the regex exist in some string?
if re.match(r'(?:TGTTTGTT){s<=2}', some_string):
    # match found
else:
    # match not found
```

#### Finding matches with re.search()
```py
match = re.search('[_F](.+)pi1,', line)
matched_string = match.group(1)
```

#### Find matches with re.finditer()

re.finditer() will yield an iterator of match objects?

```py
# iterate over all matches in some string
for match in re.finditer(r'(?:TGTTTGTT){e<=1}', some_string):
    
    # get the match starting coordinate (0-indexed)
    start: int = match.start()

    # get the match end coordinate (1-indexed)
    end: int   = match.end()

    # the entire match
    match.group(0)
    
    # the first, and second parenthesized subgroups
    match.group(1)
    match.group(2)

    # extract the number of substitutions, insertions, deletions necessary to make the match
    subs, inss, dels = match.fuzzy_counts

    # extract the positions of the changes necessary to make the match
    subs_pos, inss_pos, dels_pos = match.fuzzy_changes

# allow for overlapping regular expression matches
for match in re.finditer(r'regex', some_string, overlapped=True):
    ....

```

#### Find matches with re.findall()

re.findall() will yield a list of matched strings?

```py
matched_strings = re.findall(r'\W+', some_string)
```

#### Search and replace with re.sub()

```py
# search and replace
replace_seq = re.sub(r'([ACTG]*)(T|TA|TG)[ACTG]{2}([ACTG]{2}(?:TGTTTGTT){s<=2})', r'\1\2AA\3', search_seq)
# \1 refers to ([ACTG]*) match
# \2 refers to (T|TA|TG) match
# \3 refers to ([ACTG]{2}(?:TGTTTGTT){s<=2}) match
```

#### Compiling regex patterns into pattern objects with re.compile()

Compiling the pattern once and reusing the compiled object is more efficient
than recompiling the pattern multiple times.

```py
# compile a regular expression pattern into a regular expression object
pattern = re.compile(r'\d+')

# use the compiled pattern to search for matches in a string
match = pattern.search("There are 123 apples")
if match:
    print("Match found:", match.group())

# checking the actual regular expression:
sequence = 'ACCTCC'
pattern = re.compile(rf'(?:{sequence}){{e<=1}}')
# pattern.pattern = '(?:ACCTCC){e<=1}'
```

#### Regular expressions that contain variables

```py
for i in range(0,4):

    # {i} here contains 0, 1, 2, or 3
    # the s<={i} is wrapped up by double {{ and }}
    # to ensure the { and } are not used by the f-string as special characters
    # but only as special characters in the regular expression
    # NOTE that it is an rf'' string
    pattern = re.compile(rf'(?:TGTTTGTT){{s<={i}}}')

    # .match() only checks whether the pattern matches with the START of the string!
    if pattern.match(some_string):
        ... pattern match was found at the start of the string...

    # use .search() to check whether the pattern matches anywhere WITHIN the string!
    if pattern.search(some_string):
        ... pattern match was found ...
```
