#!/usr/bin/env bash

set -e # Exit if a tool returns a non-zero status/exit code
set -u # Treat unset variables and parameters as an error
set -o pipefail # Returns the status of the last command to exit with a non-zero status or zero if all successfully execute
set -C # No clobber - prevent output redirection from overwriting files.

printf "%s %s\n" sample1_R1.fastq.gz SAMPLE1_PE_1.gz sample1_R2.fastq.gz SAMPLE1_PE_2.gz | while read old_name new_name; do
    [ -f "${new_name}" ] || ln -s $old_name $new_name
done

fastqc \
    --quiet \
    --threads 4 \
    --memory 3840 \
    SAMPLE1_PE_1.gz SAMPLE1_PE_2.gz

cat <<-END_VERSIONS > versions.yml
"NFCORE_DEMO:DEMO:FASTQC":
    fastqc: $( fastqc --version | sed '/FastQC v/!d; s/.*v//' )
END_VERSIONS
