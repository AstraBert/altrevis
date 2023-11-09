# Usage function
usage() {
    echo "Usage: altrevis -i,--infile INFILE [-at, --alignment_type nt OR aa]

    REQUIRED ARGUMENTS:
    -i, --infile: Provide the path to the original fasta file from which to start the phylogenetic analysis
    -at, --alignment_type: Choose between nt (for DNA/RNA alignment) and aa (for protein alignments): default is nt."
    exit 1
}


infile=""
alignment_type=""

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            ;;
        -i|--infile)
            infile="$2"
            shift 2
            ;;
        -at|--alignment_type)
            alignment_type="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
fi

if [ -z "$alignment_type" ] && [ ! "$1" = "-h" ] && [ ! "$1" = "--help" ]; then
    alignment_type="nt"
fi

if [ -z "$infile" ] && [ ! "$1" = "-h" ] && [ ! "$1" = "--help" ]; then
    echo "Missing required argument: INFILE"
    usage
fi

if [ ! -f "$infile" ]
then
    echo "Provided path does not represent an existing file"
else
    flnm=$(basename "$infile")
    no_ext="${flnm%.*}"
    fold_name=$(dirname "$infile")
    folder_name=$(realpath "$fold_name")
    mkdir -p ${folder_name}/altrevis_results
    if [[ "$alignment_type" == "nt" ]]
    then 
        mafft $infile > ${folder_name}/altrevis_results/${no_ext}.afn
        fasttree -nt ${folder_name}/altrevis_results/${no_ext}.afn > ${folder_name}/altrevis_results/${no_ext}.tree
    else
        muscle -in $infile -out ${folder_name}/altrevis_results/${no_ext}.afaa
        fasttree ${folder_name}/altrevis_results/${no_ext}.afaa > ${folder_name}/altrevis_results/${no_ext}.tree
    fi
    seaview ${folder_name}/altrevis_results/${no_ext}.tree
fi
