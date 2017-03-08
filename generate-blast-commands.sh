#!/bin/bash
# 
# This script generates a command file that blast over all the records in a FASTA file.
#
# Usage:
#   ./generates-blast-commands <inputfile> <database>
#

generates-blast-commands() {
    # Check and parse input
    if [[ "$#" -ne 2 ]]; then
        echo "Usage: ./generates-blast-commands <inputfile> <database>"
        exit
    fi
    local inputfile="$1"
    local database="$2"
    if [[ ! -f "${inputfile}" ]]; then
        echo "Error: ${inputfile} does not exist."
        exit 1
    fi
    if [[ ! -d $(dirname ${database})  ]]; then
        echo "${database} does not exist"
        exit 1
    fi

    # Built-in variables
    local commandfile="./commands.txt"
    local blastscript="./single-blast.sh"
    local outputfile="./output-$(basename ${inputfile})"
    # Get number of records
    local nrecords=`grep ">" ${inputfile} | wc -l`
    echo "${nrecords} records found."

    # Generate the file.
    echo -n "" > ${outputfile}
    echo -n "" > "${commandfile}"
    for nr in `seq 1 ${nrecords}`; do
        echo "${blastscript} ${inputfile} ${nr} ${database}" >> ${commandfile}
    done
}

generates-blast-commands "$@"
