### This repository contains the Witch's Broom project. :grapes:

**This Github repository includes scripts used in the paper titled "From buds to shoots: Insights into grapevine development from the WB budsport".** This project investigated the potential genetic basis for the Witch's Broom (WB) bud sport in grapevine. Two independent cases of WB were sequenced using both Illumina and Oxford Nanopore sequencing, alongside respective wild-type (WT) samples. One case sequenced was in the Merlot variety, and the WB and WT tissue were from the same plant (but distinct shoots). The second case was in the Dakapo variety, and the WB and WT tissue samples were taken from different plants. We called both SNPs and structural variants (SVs) using the mapped reads from the sequencing data generated. The variants were annotated using Genoscope 12X grapevine genome annotations (Jaillon et al., 2007) lifted to the 12X.v2 grapevine genome assembly (Canaguier et al., 2017). *Arabidopsis* orthologs to grapevine genes were used to investigate gene function of genes impacted by high impact variants unique to the WB samples.

#### The repository is structured with the following subdirectories as such (more subdirectories to be added closer to publication):

* **scripts:** contains the scripts for the project

#### Within scripts, there are the following subdirectories:

* **arabidopsis-orthologs:** scripts for getting *Arabidopsis* orthologs to candidate grapevine genes
* **lift-annotations:** scripts for lifting old grapevine genome annotations to the new grapevine assembly
* **misc:** miscellaneous scripts
* **ont-mapping-and-svs:** scripts for mapping ONT reads, calling SVs using ONT data, and all downstream processes used for analyzing the SVs, such as filtering
* **py-scripts:** python scripts that may be useful for bioinformatics
* **short-read-mapping:** scripts for preparing raw short reads for mapping, mapping the reads, and preparing mapped reads for downstream analysis
* **snps:** scripts for SNP-calling pipeline (the GATK pipeline) and downstream processes used for analyzing the SNPs
