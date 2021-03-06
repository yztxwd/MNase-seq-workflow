import pandas as pd
from snakemake.utils import validate, min_version

#### Set minimum snakemake version ####
min_version("5.1.2")

#### Load config and sample sheets ####

configfile: "config.yaml"
#validate(config, schema="schemas/config.schema.yaml")

samples = pd.read_table(config["samples"]).set_index(["sample", "rep", "unit"], drop=False)
#validate(samples, schema="schemas/samples.schema.yaml")

#units = pd.read_table(config["units"], dtype=str).set_index(["sample", "unit"], drop=False)
#units.index = units.index.set_levels([i.astype(str) for i in units.index.levels])
#validate(units, schema="schemas/units.schema.yaml")

#### target rules ####

rule all:
    input:
        "output/qc/multiqc/multiqc.html",
        expand("output/qc/bamPEFragmentSize/{samples}-{rep}.hist.png", zip, samples=samples["sample"], rep=samples["rep"]),
        expand("output/coverage/{samples}-{rep}.bamCov.bw", zip, samples=samples["sample"], rep=samples["rep"]),

#### setup singularity ####

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
singularity: "docker://continuumio/miniconda3"

#### setup report ####
report: "report/workflow.rst"

#### load rules ####
include: "rules/global.smk"
include: "rules/qc.smk"
include: "rules/trim.smk"
include: "rules/bowtie2.smk"
include: "rules/filter.smk"
include: "rules/merge.smk"
include: "rules/coverage.smk"
