rule fastqc:
    input:
        "data/{sample}.fastq.gz"
    output:
        html="output/qc/fastqc/{sample}_fastqc.html",
        zip="output/qc/fastqc/{sample}_fastqc.zip"
    params: ""
    log:
        "logs/fastqc/{sample}.fastqc.log"
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        fastqc {params} --quiet \
          --outdir output/qc/fastqc/ {input[0]} \
          > {log}
        mv output/qc/fastqc/$(basename {input} .fastq.gz)_fastqc.html {output.html}
        mv output/qc/fastqc/$(basename {input} .fastq.gz)_fastqc.zip {output.zip}
        """

rule multiqc:
    input:
        ["output/qc/fastqc/" + str(i).replace('.fastq.gz', '_fastqc.html') for i in list(samples[["fq1", "fq2"]].values.flatten()) if not pd.isnull(i)]
    output:
        html="output/qc/multiqc/multiqc.html"
    params:
        config["multiqc"]["params"],
        fastqc_dir="output/qc/fastqc",
        multiqc_dir="output/qc/multiqc/"
    log:
        "logs/multiqc/multiqc.log"
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        multiqc {params} --force \
          -o {params.multiqc_dir} \
          -n "multiqc.html" \
          {params.fastqc_dir} \
          &> {log}
        """

rule count_size:
    input:
        bam="output/mapped/{sample}-{rep}.merge.sort.bam",
        bai="output/mapped/{sample}-{rep}.merge.sort.bam.bai"
    output:
        png="output/qc/bamPEFragmentSize/{sample}-{rep, [^-]+}.hist.png"
    params:
        title="{sample}-{rep}",
        extra="--plotFileFormat png"
    log:
        "logs/bamPEFragmentSize/{sample}-{rep}.log"
    threads:
        config["threads"]
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        "bamPEFragmentSize --bamfiles {input.bam} --histogram {output.png} {params.extra} -T {params.title} -p {threads} > {log}"
