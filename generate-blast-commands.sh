#!/bin/bash
# 
# This script generates a command file that blast over all the records in a FASTA file.
#
# Usage:
#   ./generates-blast-commands -i <inputfile> -o <outputfile> -c <commandfile> -d <database> -s <blastscript>
#

main() {
    # Check and parse input
    local inputfile=""
    local outputfile=""
    local database=""
    local blastscript=""
    while getopts ":i:o:c:d:s:" opt; do
        case $opt in
            i)
                inputfile="$OPTARG"
                ;;
            o)
                outputfile="$OPTARG"
                ;;
            c)
                commandfile="$OPTARG"
                ;;
            d)
                database="$OPTARG"
                ;;
            s)
                blastscript="$OPTARG"
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
    if [[ ! -f "${inputfile}" ]]; then
        echo "Error: ${inputfile} does not exist."
        exit 1
    fi

    # Get number of records
    local nrecords=`grep ">" ${inputfile} | wc -l`
    echo "${nrecords} records found."

    # Generate the file.
    echo -n "" > ${outputfile}
    echo -n "" > "${commandfile}"
    for nr in `seq 1 ${nrecords}`; do
        echo "${blastscript} -n ${nr} -i ${inputfile} -d ${database}" >> ${commandfile}
#        echo "inputfile=\"/tmpdata/blast-input-\$\$-\${SLURM_JOBID}-${nr}.tmp\"; outputfile=\"/tmpdata/blast-output-\$\$-\${SLURM_JOBID}-${nr}.tmp\"; ./select-fa-record.sh ./input/myseq34300.fa ${nr} > \${inputfile}; module load gencore gencore_dev gencore_annotation; blastp -db=${database} -query=\${inputfile} -out=\${outputfile} -evalue=0.01 -num_threads=1 -num_alignments=5 -outfmt 5; cat \${outputfile} >> ${outputfile}; rm \${inputfile} \${outputfile};" >> ${commandfile}
    done
}

main "$@"
