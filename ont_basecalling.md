# Basecalling ONT sequence data using Dorado
### Software used
Dorado (v0.6.0): https://github.com/nanoporetech/dorado  
POD5 format (including tools): https://github.com/nanoporetech/pod5-file-format  
Modkit (v0.2.4): https://github.com/nanoporetech/modkit  
Samtools (v1.13): https://www.htslib.org/

### Conversion of fast5 to pod5 file format (if needed)
`pod5 convert fast5 ./<fast5>/*.fast5 --output <pod5>/ --one-to-one ./<fast5>/`  
**\<fast5\>** - directory containing fast5 files  
**\<pod5\>** - directory where pod5 files will be created
