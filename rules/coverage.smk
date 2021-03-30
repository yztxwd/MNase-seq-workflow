# bigwig and bedGraph coverage file for future use

rule genomecov_bam:
    input:
        "output/mapped/{sample}-{rep}.merge.sort.bam"
    output:
        "output/coverage/{sample}-{rep, [^.]+}.bedGraph"
    log:
        "logs/genomecov/{sample}-{rep}.log"
    params:
        config["genomecov"]
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        "genomeCoverageBed {params} -ibam {input} | sort -k1,1 -k2,2n 1> {output} 2> {log}"

rule bamCoverage:
    input:
        bam="output/mapped/{sample}-{rep}.merge.sort.bam",
        bai="output/mapped/{sample}-{rep}.merge.sort.bam.bai"
    output:
        "output/coverage/{sample}-{rep, [^.]+}.bamCov.bw"
    log:
        "logs/bamCoverage/{sample}-{rep}.log"
    params:
        config["bamCoverage"]
    conda:
        f"{snake_dir}/envs/common.yaml"
    shell:
        """
        bamCoverage --bam {input.bam} --outFileName {output} --outFileFormat bigwig {params}
        """
