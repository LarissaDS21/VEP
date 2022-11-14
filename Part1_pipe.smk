#Created in Snakemake
#Pipeline to config Raw VCFs from VarSeq, after that to count variants and then separate VCFs with at least one variant need to Pipeline part II 

VCF = open('Raw_data_varseq/{lote}/samples_{lote}.txt').read().strip().split('\n')

rule all:
    input:
         "Raw_data_varseq/{lote}/CountVariants/VCFs_cheios.txt"

#The INFO field from VCFs generated in VarSeq software contains whitespaces which are harmful to the next analysis of counting variants by the GATK

rule sed:
    input:
        vcf="Raw_data_varseq/{lote}/{samples}.vcf.gz"
    output:
        vcf_c="Raw_data_varseq/{lote}/{samples}_corrigido.vcf.gz"
    log:
        "Raw_data_varseq/{lote}/logs/sed_vcf_corrigidos/{samples}.log"
    threads: 1
    resources:
        mem_gb=1
    params:
        jobname = "sed_{lote}_{samples}"
    shell:
        "zcat {input} | sed 's/ /_/g' | bgzip -c > {output}"

rule tabix:
    input:
        vcf_c="Raw_data_varseq/{lote}/{samples}_corrigido.vcf.gz"
    output:
        vcf_c_tbi="Raw_data_varseq/{lote}/{samples}_corrigido.vcf.gz.tbi"
    log:
        "Raw_data_varseq/{lote}/logs/tabix_raw_vcfs/{samples}.log"
    threads: 1
    resources:
        mem_gb=1
    params:
        jobname = "tabix_{lote}_{samples}"
    shell:
        "tabix -p vcf {input}"

rule gatk4:
    input:
        vcf_c="Raw_data_varseq/{lote}/{samples}_corrigido.vcf.gz",
        vcf_c_tbi="Raw_data_varseq/{lote}/{samples}_corrigido.vcf.gz.tbi",
    output:
        variants_txt="Raw_data_varseq/{lote}/CountVariants/{samples}.txt"
    conda:
        "gatk4"
    log:
        "Raw_data_varseq/{lote}/logs/CountVariants/{samples}.log"
    threads: 1
    resources:
        mem_gb=1
    params:
        jobname = "gatk4_{lote}_{samples}"
    shell:
        "gatk CountVariants -V {input.vcf_c} > {output}"

#Script to create separated lists of VCFs with at least one variant (VCFs_cheios.txt) and another list of VCFs without any variants (VCFs_vazios.txt)   

rule vcf_cheio:
    input:
        variants_txt=expand("Raw_data_varseq/{lote}/CountVariants/{samples}.txt", samples=VCF)
    output:
        variants_txt="Raw_data_varseq/{lote}/CountVariants/VCFs_cheios.txt"
    log:
        "Raw_data_varseq/{lote}/logs/vcfs_cheios.log"
    threads: 1
    resources:
        mem_gb=1
    params:
        jobname = "vcf_cheio_{lote}_joincounts"
    shell:
        "for arquivo in {input.variants_txt}; do "
        "nvariants=$(tac $arquivo | head -n1); "
        "if [ $nvariants -gt 0 ]; then "
        "nome_arquivo=$(basename $arquivo | sed 's/.txt//'); "
        "echo $nome_arquivo >> {output}; "
        "elif [ $nvariants -eq 0 ]; then "  
        "nome_arquivo2=$(basename $arquivo | sed 's/.txt//'); "
        "echo $nome_arquivo2 >> Raw_data_varseq/{lote}/CountVariants/VCFs_vazios.txt; fi; "
        "done"


