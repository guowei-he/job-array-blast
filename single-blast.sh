#!/bin/bash
#
# This script run one blast at a time
#
# Usage:
#   ./single-blast.sh -n <nrecord> -i <intput-fastq> -d <database>
#

single-blast() {
    # Check and parse input
    local inputfile=""
    local nrecord=""
    local database=""
    while getopts ":i:n:d:" opt; do
        case $opt in
            i)
                inputfile="$OPTARG"
                ;;
            n)
                nrecord="$OPTARG"
                ;;
            d)
                database="$OPTARG"
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                exit 1
                ;;
            :)
                echo "Option $OPTARG requires an argument." >&2
                exit 1
                ;;
        esac
    done

    local tmpdir="/tmpdata"
    local tmp_inputfile="${tmpdir}/blast-input-$$-${nrecord}.tmp"
    local tmp_outputfile="${tmpdir}/blast-output-$$-${nrecord}.tmp"
    ./select-fa-record.sh ${inputfile} ${nr} > ${tmp_inputfile} 
    module load gencore gencore_dev gencore_annotation;
    blastp -db=${database} -query=${tmp_inputfile} -out=${tmp_outputfile} -evalue=0.01 -num_threads=4 -num_alignments=5 -outfmt 5;
    # show output
    cat ${tmp_outputfile}
    rm ${tmp_inputfile} ${tmp_outputfile};

}

single-blast "$@"
