#!/usr/bin/bash

# Remove any existing test directory and recreate the folder structure
rm -rf ./my-pipeline-test/
mkdir -p ./my-pipeline-test/sam-bcf-tools
mkdir -p ./my-pipeline-test/gatk

# Define reference genome and sample BAM file paths
REF="./hello-nextflow/data/ref/ref.fasta"
SAMPLE1="./hello-nextflow/data/bam/reads_son.bam"
SAMPLE2="./hello-nextflow/data/bam/reads_father.bam"
SAMPLE3="./hello-nextflow/data/bam/reads_mother.bam"

# Extract just the file name from the full file path
filename1=$(basename "$SAMPLE1")
filename2=$(basename "$SAMPLE2")
filename3=$(basename "$SAMPLE3")

# Define output VCF file paths for SAMtools and BCFtools
SAM_BCF_OUT1="./my-pipeline-test/sam-bcf-tools/$filename1.vcf"
SAM_BCF_OUT2="./my-pipeline-test/sam-bcf-tools/$filename2.vcf"
SAM_BCF_OUT3="./my-pipeline-test/sam-bcf-tools/$filename3.vcf"

# Define output VCF file paths for GATK
GATK_OUT1="./my-pipeline-test/gatk/$filename1.vcf"
GATK_OUT2="./my-pipeline-test/gatk/$filename2.vcf"
GATK_OUT3="./my-pipeline-test/gatk/$filename3.vcf"

# Color codes for messages
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
echo "###########################################"
echo "#            SAMTOOLS, BCFTOOLS           #"
echo "###########################################"
echo ""

# Activate the bcftools Conda environment
source $(conda info --base)/etc/profile.d/conda.sh && conda activate bcftools
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to activate bcftools environment.${NC}" >&2
    exit 1
fi

# Process SAMPLE1 with SAMtools and BCFtools
samtools index $SAMPLE1 && 
bcftools mpileup -f $REF $SAMPLE1 | bcftools call -mv -Oz -o $SAM_BCF_OUT1
if [ $? -eq 0 ]; then
    echo -e "SAMPLE1 ${GREEN}SUCCESS!!!${NC}"
else
    echo -e "SAMPLE1 ${RED}FAILED!!!${NC}" >&2
fi

# Process SAMPLE2 with SAMtools and BCFtools
samtools index $SAMPLE2 && 
bcftools mpileup -f $REF $SAMPLE2 | bcftools call -mv -Oz -o $SAM_BCF_OUT2
if [ $? -eq 0 ]; then
    echo -e "SAMPLE2 ${GREEN}SUCCESS!!!${NC}"
else
    echo -e "SAMPLE2 ${RED}FAILED!!!${NC}" >&2
fi

# Process SAMPLE3 with SAMtools and BCFtools
samtools index $SAMPLE3 && 
bcftools mpileup -f $REF $SAMPLE3 | bcftools call -mv -Oz -o $SAM_BCF_OUT3
if [ $? -eq 0 ]; then
    echo -e "SAMPLE3 ${GREEN}SUCCESS!!!${NC}"
else
    echo -e "SAMPLE3 ${RED}FAILED!!!${NC}" >&2
fi

echo ""
echo "############################################"
echo "#                   GATK                   #"
echo "############################################"
echo ""

# Activate the GATK Conda environment
source $(conda info --base)/etc/profile.d/conda.sh && conda activate gatk
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to activate gatk environment.${NC}" >&2
    exit 1
fi

# Process SAMPLE1 with GATK HaplotypeCaller
gatk HaplotypeCaller \
    -R $REF \
    -I $SAMPLE1 \
    -O $GATK_OUT1
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}####################################"
    echo -e "SAMPLE1 SUCCESS!!!"
    echo -e "####################################${NC}"
    echo ""
else
    echo ""
    echo -e "${RED}####################################"
    echo -e "SAMPLE1 FAILED!!!"
    echo -e "####################################${NC}"
    echo ""
fi

# Process SAMPLE2 with GATK HaplotypeCaller
gatk HaplotypeCaller \
    -R $REF \
    -I $SAMPLE2 \
    -O $GATK_OUT2
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}####################################"
    echo -e "SAMPLE2 SUCCESS!!!"
    echo -e "####################################${NC}"
    echo ""
else
    echo ""
    echo -e "${RED}####################################"
    echo -e "SAMPLE2 FAILED!!!"
    echo -e "####################################${NC}"
    echo ""
fi

# Process SAMPLE3 with GATK HaplotypeCaller
gatk HaplotypeCaller \
    -R $REF \
    -I $SAMPLE3 \
    -O $GATK_OUT3
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}####################################"
    echo -e "SAMPLE3 SUCCESS!!!"
    echo -e "####################################${NC}"
    echo ""
else
    echo ""
    echo -e "${RED}####################################"
    echo -e "SAMPLE3 FAILED!!!"
    echo -e "####################################${NC}"
    echo ""
fi

# Count and display the number of non-header lines (variants) in each VCF file
echo ""
echo "------------------------------------------"
echo "             SAMTOOLS, BCFTOOLS           "
echo ""
echo "$filename1 - $(grep -v "#" $SAM_BCF_OUT1 | wc -l)"
echo "$filename2 - $(grep -v "#" $SAM_BCF_OUT2 | wc -l)"
echo "$filename3 - $(grep -v "#" $SAM_BCF_OUT3 | wc -l)"
echo "------------------------------------------"
echo ""

echo "-------------------------------------------"
echo "                    GATK                   "
echo ""
echo "$filename1 - $(grep -v "#" $GATK_OUT1 | wc -l)"
echo "$filename2 - $(grep -v "#" $GATK_OUT2 | wc -l)"
echo "$filename3 - $(grep -v "#" $GATK_OUT3 | wc -l)"
echo "-------------------------------------------"
echo ""

# Extract non-header lines (variant data) to TSV files
grep -v "#" $SAM_BCF_OUT1 > $SAM_BCF_OUT1.tsv
grep -v "#" $SAM_BCF_OUT2 > $SAM_BCF_OUT2.tsv
grep -v "#" $SAM_BCF_OUT3 > $SAM_BCF_OUT3.tsv

grep -v "#" $GATK_OUT1 > $GATK_OUT1.tsv
grep -v "#" $GATK_OUT2 > $GATK_OUT2.tsv
grep -v "#" $GATK_OUT3 > $GATK_OUT3.tsv

echo "'#' removed files generated"

# Extract specific columns (position and genotype) for each sample
cut -f2,6 $SAM_BCF_OUT1 | grep -v "#" > "$SAM_BCF_OUT1"_cut.tsv
cut -f2,6 $SAM_BCF_OUT2 | grep -v "#" > "$SAM_BCF_OUT2"_cut.tsv
cut -f2,6 $SAM_BCF_OUT3 | grep -v "#" > "$SAM_BCF_OUT3"_cut.tsv

cut -f2,6 $GATK_OUT1    | grep -v "#" > "$GATK_OUT1"_cut.tsv
cut -f2,6 $GATK_OUT2    | grep -v "#" > "$GATK_OUT2"_cut.tsv
cut -f2,6 $GATK_OUT3    | grep -v "#" > "$GATK_OUT3"_cut.tsv

echo "cut files generated"
