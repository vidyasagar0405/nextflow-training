#!/usr/bin/env bash

set -e # Exit if a tool returns a non-zero status/exit code
set -u # Treat unset variables and parameters as an error
set -o pipefail # Returns the status of the last command to exit with a non-zero status or zero if all successfully execute
set -C # No clobber - prevent output redirection from overwriting files.

multiqc \
    --force \
     \
    --config multiqc_config.yml \
     \
     \
     \
     \
     \
    .

cat <<-END_VERSIONS > versions.yml
"NFCORE_DEMO:DEMO:MULTIQC":
    multiqc: $( multiqc --version | sed -e "s/multiqc, version //g" )
END_VERSIONS
