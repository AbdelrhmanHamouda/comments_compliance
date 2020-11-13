# comments_compliance
A portable bash script that searches for all for all C-files that contain less than a specific percentage of commented lines and report the results.


# Script usage and parameter description
```
Syntax: comments_compliance.sh [-p <percentage>|x <.c|.cpp>|i|s|h] [path]. 
parameters:  
p     Set the percentage for comment-lines. The provided value should be from 0 to 100 (default is '30').  
x     Set the file extension to be checked (default is '.c').  
i     Inverts the operation. Meaning that the output will be for the files that match or exceed the defined percentage.  
s     Sort the output alphanumerically.  
h     Print this help.  
path  Set the path to be used (default is '$PWD').  
  
Usage example:  
./comments_compliance.sh -is -p 40 /project/directory. 
      This command will print all compliant '.c' files in the provided directory and sort the output alphanumerically.  
```
