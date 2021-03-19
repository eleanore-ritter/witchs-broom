#### This directory contains the Witch's Broom project. :grapes:

##### **Project goal:** To uncover the potential genetic basis for the Witch's Broom (WB) budsport in grapevine using whole genome sequencing data.

Two independent cases of WB were sequenced, alongside respective wildtype (WT) samples. One case was in the Merlot variety, and the WB and WT tissue can from the same plant. The second case was in the Dakapo variety, and the WB and WT samples came from different plants.

The directory is structured with the following subdirectories as such:

* **bin:** contains compiled files, such as installed programs
* **scripts:** contains the scripts for the project

Within scripts, there are the following subdirectories:
* **arabidopsis-orthologs:** scripts for getting Arabidopsis orthologs to candidate *V. vinifera* genes
* **lift-annotations:** scripts for lifting old grape genome annotations to new grape assembly
* **mapping:** scripts for preparing raw reads for mapping, mapping, and preparing mapped reads for downstream analysis
* **merlotref-to-pn:** scripts for matching annotations from Merlot reference genome to annotations from *V. vinifera* PN reference genome
* **misc:** miscellaneous scripts
* **py-scripts:** python scripts that may be useful for bioinformatics
* **snps:** scripts for SNP-calling pipeline (the GATK pipeline)
* **svs:** scripts for SV-calling (utilizing smoove, DELLY, and intansv)
* **teis:** scripts for TE annotation (EDTA) and TEI-calling (Jitterbug)
