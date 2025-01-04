#!/bin/bash -ue
gatk HaplotypeCaller         -R ref.fasta         -I reads_mother.bam         -O reads_mother.bam.g.vcf         -L intervals.bed         -ERC GVCF
