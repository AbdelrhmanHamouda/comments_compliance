#!/bin/bash
# Set default values for parameters
PERCENTAGE='30'
INVERT_OPERATION='False'
SORT_OUTPUT='False'
FILE_EXTENSION='.c'
COMPLIANT_FILES_LIST='compliant_files.list'
INCOMPLIANT_FILES_LIST='Incompliant_files.list'

# Define the help function
function Help(){
    progress_banner "Script usage and parameter description"
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

# Function to get all files that match $FILE_EXTENSION
function get_matching_files(){
    local file_extension=$1
    local path_to_files=$2
    echo "Searching for files with extension: $file_extension in: $path_to_files..."
    files_found=`find $path_to_files -type f -name "*$file_extension"`
}

# Function to calculate percentage of comments compliance for one file based on operation mode
function comments_compliance(){
    local desired_percentage=$1 
    local file_under_assessment=$2
    local total_lines_count=0
    local comments_count=0

    echo "Assessing file: $file_under_assessment..."

    # count lines in file
    total_lines_count=`cat $file_under_assessment | wc -l`
    
    # count single line comments
    local single_line_comments=`cat $file_under_assessment | grep "^\s*//" | wc -l `
    # count inline single line comments
    local inline_single_line_comments=`cat $file_under_assessment | grep ".*;\s*//" | wc -l `
    # count multi line comments
    local multi_line_comments_count=`cat $file_under_assessment | awk '/\/\*/,/\*\// {print}' | wc -l`

    # add total comment lines in file
    comments_count=$(($single_line_comments + $inline_single_line_comments + $multi_line_comments_count))

    # calculate percentage
    local compliance_percentage=$((($comments_count*100)/$total_lines_count))
    # populate results files
    if [ $compliance_percentage -ge $desired_percentage ]
    then
        echo -e "File name: $file_under_assessment \tCompliance percentage: $compliance_percentage" >> $COMPLIANT_FILES_LIST
    else
        echo -e "File name: $file_under_assessment \tCompliance percentage: $compliance_percentage" >> $INCOMPLIANT_FILES_LIST
    fi
    
    echo "File assessment completed. "
}

# Function to sort the output files
function sort_output(){
    sort -o $COMPLIANT_FILES_LIST $COMPLIANT_FILES_LIST > /dev/null 2>&1
    sort -o $INCOMPLIANT_FILES_LIST $INCOMPLIANT_FILES_LIST > /dev/null 2>&1
    echo "Sorting successful."
}

# Function to make output more readable
function progress_banner(){
  echo "+------------------------------------------+"
  echo "|                                          |"
  printf "|`tput bold` %-40s `tput sgr0`|\n" "$@"
  echo "+------------------------------------------+"
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
if [ -z "$PATH_TO_FILES" ] || [ $PATH_TO_FILES == '.' ]
then 
    PATH_TO_FILES=$PWD
fi



#####################
##### Main logic ####
#####################

# Clean previously generated files
progress_banner "Cleaning up enviroment..."
rm $COMPLIANT_FILES_LIST > /dev/null 2>&1
rm $INCOMPLIANT_FILES_LIST > /dev/null 2>&1
# Get files list
progress_banner "Searching for matching files..."
get_matching_files $FILE_EXTENSION $PATH_TO_FILES

# Assess files 
progress_banner "Assessing files..."
for file in $files_found
do
    comments_compliance $PERCENTAGE $file
done

# Sort output if needed
if [ $SORT_OUTPUT == 'True' ]
then
    progress_banner "Sorting output..."
    sort_output
fi


# Print compliance results based on -i parameter

if [ $INVERT_OPERATION == 'True' ]
then 
    progress_banner "Compliant files"
    cat $COMPLIANT_FILES_LIST
else
    progress_banner "Incompliant files"
    cat $INCOMPLIANT_FILES_LIST
fi