# Obtain settings from config file.
configfile: "./config.yml"

# Define a genome file pattern using the configured genome directory
# and acceptable FASTA suffix
IDS, = glob_wildcards(f'{config["genomedir"]}/{{name}}.{config["fasta_suffix"]}')

rule all: 
	input: expand(f'{config["pngdir"]}/{{name}}.png', name=IDS)
	
rule download_db:
	output: config["sprot_local"]
	shell: "wget -O {config[sprot_local]} {config[sprot_url]}"

rule build_db:
	input: config["sprot_local"]
	output: config["dbpath"]
	shell: "diamond makedb --db {config[dbpath]} --in {config[sprot_local]}"

rule prodigal:
	input: f'{config["genomedir"]}/{{name}}.fna'
	output: f'{config["prodigaldir"]}/{{name}}.faa'
	shell: "prodigal -a {output} -q -i {input} -o /dev/null"

rule diamond:
	input:
		seqfile=f'{config["prodigaldir"]}/{{name}}.faa',
		db=config["dbpath"]
	output: f'{config["diamond_dir"]}/{{name}}.data'
	shell: "diamond blastp --quiet --max-target-seqs 1 --db {input.db} --query {input.seqfile} --outfmt {config[diamond_params]} --out {output}"

rule hist:
	input: f'{config["diamond_dir"]}/{{name}}.data'
	output: f'{config["pngdir"]}/{{name}}.png'
	shell: "scripts/hist.R {input} {output}"
