#!/bin/bash
#
# This tool select a specific number of record from the fasta file
#
# Usage:
#   ./select-fa-record.sh <filename> <record-number>
#

main() {
    if [[ "$#" -ne 2 ]]; then
        echo "Usage: ./select-fa-record.sh <filename> <record-number>"
        exit 1
    fi
    
    local filename="$1"
    local record_number="$2"

    awk -v record_number=${record_number} 'BEGIN {n_seq=0;} /^>/ { ++n_seq;  } { if(n_seq==record_number) print;  } { if(n_seq>record_number) exit;  } '  < "${filename}"
}

main "$@"
