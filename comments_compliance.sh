#!/bin/bash
# Set default values for parameters
PERCENTAGE='30'
INVERT_OPERATION='False'
SORT_OUTPUT='False'
FILE_EXTENSION='.c'

# Define the help function
function Help(){
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
PATH_TO_FILES=$1
# Set default for PATH_TO_FILES if not set
if [ $PATH_TO_FILES == '.' ] || [ -z "$PATH_TO_FILES" ]
then 
    PATH_TO_FILES=$PWD
fi

# Objective #2
# add the main logic to detect the files with ext -x that have less that -p lines of comments
# define all possible ways to comment a line or lines 
# implement logic based on variables 
# working by default for 30% and .c 

# Function to get all files that match $FILE_EXTENSION
function get_matching_files(){
    local file_extension=$1
    local path_to_files=$2
    echo "Searching for files with extension: $file_extension in: $path_to_files..."
    files_found=`find $path_to_files -type f -name "*$file_extension"`
}

# Function to calculate percentage of comments compliance for one file based on operation mode
function comments_compliance(){
    local percentage=$1 
    local operation_mode=$2
    local file_under_assessment=$3
    echo "Assessing file: $file_under_assessment..."

}

# Main logic

# Get files list
get_matching_files $FILE_EXTENSION $PATH_TO_FILES

for file in $files_found
do
    echo $file
done