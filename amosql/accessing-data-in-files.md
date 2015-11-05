# Accessing data in files


The file system where an sa.amos server is running can be accessed with
a number of system functions:

 The function *pwd()* returns the path to the current working directory
of the server:
 <span style="font-family: monospace;">  pwd() -&gt; Charstring
path</span> <span style="font-family: monospace;">

 </span>The function *cd()* changes the current working directory of the
server:
 <span style="font-family: monospace;">  cd(Charstring path) -&gt;
Charstring </span> <span style="font-family: monospace;">
 </span>
 The function *dir()* returns a bag of the files in a directory <span
style="font-style: italic;"></span>:
 <span <style="font-family: monospace;">
`  dir() -> Bag of Charstring file` `        `
`   dir(Charstring path) -> Bag of Charstring file` `        `
`   dir(Charstring path, Charstring pat) -> Bag of Charstring file`
 </span>
 The first optional argument *path* specifies the path to the directory.
The second optional argument *pat* specifies a regular expression (as in
like) to match the files to return.'
 The function *file_exists()* returns true if a file with a given name
exists:
 <span style="font-family: monospace;">  file_exists(Charstring file)
-&gt; Boolean</span>

 The function *directoryp()* returns true if a path is a directory:
 <span style="font-family: monospace;">  directoryp(Charstring path)
-&gt; Boolean</span>

 The function *filedate()* returns the write time of a file with a given
name:
 <span style="font-family: monospace;">  filedate(Charstring file) -&gt;
Date</span>
 <span style="font-family: Times New Roman;"> `` </span> <span
style="font-family: Times New Roman;"> </span>

### 2.9.1 Reading and writing files

The function *readlines()* returns the lines in a file as a bag of
strings:

`  readlines(Charstring file) -> Bag of Charstring        readlines(Charstring file, Charstring sep) -> Bag of Charstring        `
The optional second argument *sep* specifies the character used to
separate the lines. The default is the standard line separator.


 The function *csv_file_tuples()* reads a CSV (*Comma Separated
Values)* file. Each line is returned as a vector.

For example, if a file named *myfile.csv* contains the following lines:
 `1,2.3,a b c` `            ` `4,5.5,d e f` `            ` the result
from the call *csv_file_tuples("myfile.csv")* is a bag containing
these vectors:
 `{1,2.3,"a b c"}` `            ` `{4,5.5,"d e f"}` `            `
 The CSV reader can, e.g., read CSV files saved by EXCEL, but is has to
be in **English** format.


 The function *read_ntuples()* imports data from a text file of space
separated values. Each line of the text file produces one vector in the
result bag. Each token on a line will be parsed into field in the
vector. Numbers in the file are parsed into numbers. All other tokens
are parsed into strings.
 `  read_ntuples(Charstring file) -> Bag of Vector`

 For example, if a file name *test.nt* contains the following:
 `"This is the first line" another word` `            ` `            `
`1 2 3 4.45 2e9` `            ` `            `
`"This line is parsed into two fields" 3.14` `            ` <span
style="font-family: Times New Roman;"> ` `
 the call *read_ntuples("test.nt")* returns a bag with the following
vectors:
 `{"This is the first line","another","word"}` `                `
`                ` `                ` `{1,2,3,4.45,2000000000.0}`
`                ` `                `
`{"This line is parsed into two fields",3.14}` <span
style="font-family: Times New Roman;"></span> <span
style="font-family: Times New Roman;">


 The function *writecsvfile()* writes the vectors in a bag *b* into a
file in CSV (Comma Separated Values) format so that it can loaded into,
e.g., EXCEL.
 `  writecsvfile(Charstring file, Bag b) -> Boolean         `

 For example, the following statement:

`  writecsvfile("myoutput.csv", bag({1,"a b",2.2},{3,"d e",4.5})                    `
produces the a file *myoutput.csv* having these lines:
 `1,a b,2.2` `                    ` `3,d e,4.5` `                    `

 The function *write_ntuples()* writes a bag of vectors into a files as
space separated tokens in lines so that they can be read again with
*read_ntuples()*:
 `  write_ntuples(Bag of Vector rowset, Charstring file) -> Charstring`
 </span> </span>
