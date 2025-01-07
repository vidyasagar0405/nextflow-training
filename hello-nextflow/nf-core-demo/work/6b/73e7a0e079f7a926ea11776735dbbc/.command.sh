#!/usr/bin/env bash

set -e # Exit if a tool returns a non-zero status/exit code
set -u # Treat unset variables and parameters as an error
set -o pipefail # Returns the status of the last command to exit with a non-zero status or zero if all successfully execute
set -C # No clobber - prevent output redirection from overwriting files.

printf "%s\n" sample2_R1.fastq.gz sample2_R2.fastq.gz | while read f;
do
    seqtk \
        trimfq \
         \
        $f \
        | gzip --no-name > SAMPLE2_PE_$(basename $f)
done

cat <<-END_VERSIONS > versions.yml
"NFCORE_DEMO:DEMO:SEQTK_TRIM":
    seqtk: $(echo $(seqtk 2>&1) | sed 's/^.*Version: //; s/ .*$//')
END_VERSIONS
