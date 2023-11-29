#!/bin/bash
# remove a single page from PDF file
ME=$(basename $0)

function usage() {
    echo "Usage: ${ME} [pdf_file] [page_no]"
    exit 1
}

command -v pdfinfo >/dev/null 2>&1 || { echo >&2 "pdfinfo is required but not installed. Aborting."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo >&2 "docker is required but not installed. Aborting."; exit 1; }
command -v uuidgen >/dev/null 2>&1 || { echo >&2 "uuidgen is required but not installed. Aborting."; exit 1; }

pdffile=${1}
pageno=${2}

if [ -z "${pdffile}" ]; then
    usage
fi

if [ -z "${pageno}" ]; then
    usage
fi

if [ ! -e $pdffile ]; then
    echo "$pdffile not found"
    exit 1
fi

#echo ${pdffile} ${pageno}

page_count=`pdfinfo "${pdffile}" | grep 'Pages:' | awk '{print $2}'`

echo total page: ${page_count}

if [ $page_count -lt 1 ]; then
    echo "total page < 1" && exit 1
fi

if [ $pageno -gt $page_count ]; then
    echo "exceed page count" && exit 1
fi

if [ $pageno -lt 1 ]; then
    echo "page < 1" && exit 1
fi

tmpfile=${pdffile}.$(uuidgen -r).pdf

if [ $pageno -eq 1 ]; then
    echo "remove first page"
    docker run --rm -it --volume $(pwd):/work pdftk/pdftk:latest ${pdffile} cat 2-end output ${tmpfile}
elif [ $pageno -eq $page_count ]; then
    echo "remove last page"
    docker run --rm -it --volume $(pwd):/work pdftk/pdftk:latest ${pdffile} cat 1-r2 output ${tmpfile}
else
    firstend=$(( $pageno - 1 ))
    secondstart=$(( $pageno + 1 ))
    echo "remove page ${pageno}"
    #echo 1-${firstend} ${secondstart}-end
    docker run --rm -it --volume $(pwd):/work pdftk/pdftk:latest ${pdffile} cat 1-${firstend} ${secondstart}-end output ${tmpfile}
fi

if [ -e $tmpfile ]; then
    rm --preserve-root -f ${pdffile} || exit 1
    mv ${tmpfile} ${pdffile} || exit 1
    echo done
fi
