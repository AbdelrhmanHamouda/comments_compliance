#!/bin/bash


# objective: Build a base for the script that takes -p, -x, -i, -s and -h parameters and echo what they have been passed
# result: parameters working
# result: help working 

# Set default values for parameters
PERCENTAGE='30'
INVERT_OPERATION='False'
SORT_OUTPUT='False'
FILE_EXTENSION='.c'
PATH='.'

# Define the help function
function Help(){
   # Display Help
   echo "The script searches for all C-files that contain less than a specific percentage of commented lines. "
   echo
   echo "Syntax: comments_compliance.sh [-p|x|i|s|h] [path]"
   echo "parameters:"
   echo "p     Set the percentage for comment-lines. The provided value should be from 0 to 100 (default is '30')."
   echo "x     Set the file extension to be checked (default is '.c')."
   echo "i     Inverts the operation. Meaning that the output will be for the files that match or exceed the defined percentage."
   echo "s     Sort the output alphanumerically."
   echo "h     Print this help."
   echo "path  Set the path to be used (default is '\$PWD')."
   echo
}

# Get parameters if provided
while getopts p:x:ish parameters
do
    case "${parameters}" in
        p) PERCENTAGE=${OPTARG};;
        x) FILE_EXTENSION=${OPTARG};;
        i) INVERT_OPERATION='True';;
        s) SORT_OUTPUT='True';;
        h)
            Help
            exit;;
    esac
done

# Shift parameters to get $PATH
shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift
PATH=$1


