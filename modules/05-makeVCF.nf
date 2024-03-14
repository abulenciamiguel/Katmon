#!/usr/bin 
process makevcf {
    tag "Making vcf file of high quality reads from bam file of ${filtered_bam.name}"
    container 'pegi3s/samtools_bcftools:latest'
    
    publishDir(
        path: "${params.out_dir}/05-makeVCF",
        mode: 'copy',
        overwrite: 'true'
    )

    input:
    path filtered_bam

    output:
    tuple val (filtered_bam.name), path ("*.vcf.gz"), emit: filtered_vcf

    script:
    """
    samtools sort ${filtered_bam} -o ${filtered_bam.name}_filtered.sorted.bam
    samtools index ${filtered_bam.name}_filtered.sorted.bam
    bcftools mpileup -Ou -f ${baseDir}/assets/sars-cov-2/reference-sequence.fasta ${filtered_bam.name}_filtered.sorted.bam | bcftools call -mv -Ob -o ${filtered_bam.name}.vcf.gz
    """
}