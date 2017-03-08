#!/bin/bash
#
# This script run one blast at a time
#
# Usage:
#   ./single-blast.sh <intput-fastq> <nrecord> <database>
#

single-blast() {
    # Check and parse input
    if [[ "$#" -ne 3 ]]; then
        echo "Usage: ./single-blast.sh <intput-fastq> <nrecord> <database>"
        exit 1
    fi
    local inputfile="$1"
    if [[ ! -f ${inputfile} ]]; then
        echo "${inputfile} does not exist"
        exit 1
    fi
    local nrecord="$2"
    local database="$3"
    if [[ ! -d $(dirname ${database})  ]]; then
        echo "${database} does not exist"
        exit 1
    fi

    local outputfile="./output-$(basename ${inputfile})"
    local tmpdir="/tmpdata"
    local tmp_inputfile="${tmpdir}/blast-input-$$-${nrecord}.tmp"
    local tmp_outputfile="${tmpdir}/blast-output-$$-${nrecord}.tmp"
    ./select-fa-record.sh ${inputfile} ${nrecord} > ${tmp_inputfile} 
    module load gencore gencore_dev gencore_annotation;
    time blastp -db=${database} -query=${tmp_inputfile} -out=${tmp_outputfile} -evalue=0.01 -num_threads=4 -num_alignments=1 -outfmt 6

    # show outputfile
    local lck_file=${tmpdir}/blast-lock.${SLURM_JOB_ID}
    (
        flock -e 200
        cat ${tmp_outputfile} >> ${outputfile}
    ) 200>${lck_file}
    rm ${tmp_inputfile} ${tmp_outputfile};

}

single-blast "$@"
