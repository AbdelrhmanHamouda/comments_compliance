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


