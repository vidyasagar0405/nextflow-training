#!/bin/bash -ue
gatk GenomicsDBImport         -V reads_mother.bam.g.vcf -V reads_son.bam.g.vcf -V reads_father.bam.g.vcf         -L intervals.bed         --genomicsdb-workspace-path family_trio_gdb

gatk GenotypeGVCFs         -R ref.fasta         -V gendb://family_trio_gdb         -L intervals.bed         -O family_trio.joint.vcf
