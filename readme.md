### This repository contains the Witch's Broom project. :grapes:

This Github repository includes scripts used in the paper titled "From buds to shoots: Insights into grapevine development from the WB budsport". This project investigated the potential genetic basis for the Witch's Broom (WB) bud sport in grapevine. Two independent cases of WB were sequenced using both Illumina and Oxford Nanopore sequencing, alongside respective wild-type (WT) samples. One case was in the Merlot variety, and the WB and WT tissue were from the same plant (but different shoots). The second case was in the Dakapo variety, and the WB and WT samples came from different plants. We called both SNPs and structural variants (SVs) using the mapped reads from the sequencing data generated. The variants were annotated using Genoscope 12X grapevine genome annotations (Jaillon et al., 2007) lifted to the 12X.v2 grapevine genome assembly (Canaguier et al., 2017). *Arabidopsis* orthologs to grapevine genes were used to investigate gene function of genes impacted by high impact variants unique to the WB samples.

#### The repository is structured with the following subdirectories as such (more subdirectories to be added closer to publication):

* **scripts:** contains the scripts for the project

#### Within scripts, there are the following subdirectories:

* **arabidopsis-orthologs:** scripts for getting *Arabidopsis* orthologs to candidate *V. vinifera* genes
* **lift-annotations:** scripts for lifting old grape genome annotations to new grape assembly
* **mapping:** scripts for preparing raw reads for mapping, mapping, and preparing mapped reads for downstream analysis
* **merlotref-to-pn:** scripts for matching annotations from Merlot reference genome to annotations from *V. vinifera* PN reference genome
* **misc:** miscellaneous scripts
* **ont-svs:** scripts for calling svs using ont reads
* **py-scripts:** python scripts that may be useful for bioinformatics
* **snps:** scripts for SNP-calling pipeline (the GATK pipeline)
