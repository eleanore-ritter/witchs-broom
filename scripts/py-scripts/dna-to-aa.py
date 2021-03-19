# Code to translate DNA sequences to amino acids

import Bio
from Bio.SeqRecord import SeqRecord
def make_protein_record(nuc_record):
    """Returns a new SeqRecord with the translated sequence (default table)."""
    return SeqRecord(seq = nuc_record.seq.translate(), \
                     id = "trans_" + nuc_record.id, \
                     description = "translation of CDS, using default table")

from Bio import SeqIO
proteins = (make_protein_record(nuc_rec) for nuc_rec in \
            SeqIO.parse("biopython-test.fasta", "fasta"))
SeqIO.write(proteins, "biopython-test-AAseq-1.fasta", "fasta")
