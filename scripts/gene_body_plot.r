#load libraries
library(dplyr)
library(GenomicFeatures)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(org.Hs.eg.db)
library(ggplot2)

#load in test data
nanopore_cov10_auto_100000 <- read.table("nanopore_cov10_auto_100000.txt", header=TRUE, sep="\t")

#extract just chromosome number
nanopore_cov10_auto_100000$chr_num <- substring(nanopore_cov10_auto_100000$Chromosome,4)


# Download gene locations
genes.hg38 <- genes(TxDb.Hsapiens.UCSC.hg38.knownGene)
tmp_genes<-as.data.frame(genes.hg38)
tmp_genes$seqnames<-gsub("chr", "", tmp_genes$seqnames)

## for each gene
plot.coords<-NULL
for(i in 1:nrow(tmp_genes)){
  
  ### identify sites that fall within gene boundaries
  gene.sub<-nanopore_cov10_auto_100000[which(nanopore_cov10_auto_100000$chr_num == tmp_genes$seqnames[i] & nanopore_cov10_auto_100000$Start <= tmp_genes$end[i] & nanopore_cov10_auto_100000$Start >= tmp_genes$start[i]),]
  if(nrow(gene.sub) > 0){
   if(tmp_genes$strand[i] == "+"){		
      plot.coords<-rbind(plot.coords, cbind(gene.sub$NeuN_per_methylation, gene.sub$NeuN_per_hydroxymethylation, gene.sub$Sox10_per_methylation, gene.sub$Sox10_per_hydroxymethylation, gene.sub$IRF8_per_methylation, gene.sub$IRF8_per_hydroxymethylation, (gene.sub$Start-tmp_genes$start[i])/(tmp_genes$end[i]-tmp_genes$start[i])))
    } else {
      plot.coords<-rbind(plot.coords, cbind(gene.sub$NeuN_per_methylation, gene.sub$NeuN_per_hydroxymethylation, gene.sub$Sox10_per_methylation, gene.sub$Sox10_per_hydroxymethylation, gene.sub$IRF8_per_methylation, gene.sub$IRF8_per_hydroxymethylation, (tmp_genes$end[i]-gene.sub$Start)/(tmp_genes$end[i]-tmp_genes$start[i])))
    }
  }
  
  ### identify sites 5kb downstream; depends on strand
  if(tmp_genes$strand[i] == "+"){
    gene.sub<-nanopore_cov10_auto_100000[which(nanopore_cov10_auto_100000$chr_num == tmp_genes$seqnames[i] & nanopore_cov10_auto_100000$Start <= tmp_genes$start[i] & nanopore_cov10_auto_100000$Start >= (tmp_genes$start[i]-5000)),]
    if(nrow(gene.sub) > 0){
      plot.coords<-rbind(plot.coords, cbind(gene.sub$NeuN_per_methylation, gene.sub$NeuN_per_hydroxymethylation, gene.sub$Sox10_per_methylation, gene.sub$Sox10_per_hydroxymethylation, gene.sub$IRF8_per_methylation, gene.sub$IRF8_per_hydroxymethylation, (gene.sub$Start-tmp_genes$start[i])/5000))
    }
  } else {
    gene.sub<-nanopore_cov10_auto_100000[which(nanopore_cov10_auto_100000$chr_num == tmp_genes$seqnames[i] & nanopore_cov10_auto_100000$Start <= (tmp_genes$end[i]+5000) & nanopore_cov10_auto_100000$Start >= tmp_genes$end[i]),]
    if(nrow(gene.sub) > 0){
      plot.coords<-rbind(plot.coords, cbind(gene.sub$NeuN_per_methylation, gene.sub$NeuN_per_hydroxymethylation, gene.sub$Sox10_per_methylation, gene.sub$Sox10_per_hydroxymethylation, gene.sub$IRF8_per_methylation, gene.sub$IRF8_per_hydroxymethylation, (gene.sub$Start-tmp_genes$end[i])/-5000))
    }
    
  }
  
  ### identify sites 5kb upstream; depends on strand
  if(tmp_genes$strand[i] == "-"){
    gene.sub<-nanopore_cov10_auto_100000[which(nanopore_cov10_auto_100000$chr_num == tmp_genes$seqnames[i] & nanopore_cov10_auto_100000$Start <= tmp_genes$start[i] & nanopore_cov10_auto_100000$Start >= (tmp_genes$start[i]-5000)),]
    if(nrow(gene.sub) > 0){
      plot.coords<-rbind(plot.coords, cbind(gene.sub$NeuN_per_methylation, gene.sub$NeuN_per_hydroxymethylation, gene.sub$Sox10_per_methylation, gene.sub$Sox10_per_hydroxymethylation, gene.sub$IRF8_per_methylation, gene.sub$IRF8_per_hydroxymethylation, 1+((gene.sub$Start-tmp_genes$start[i])/-5000)))
    }
  } else {
    gene.sub<-nanopore_cov10_auto_100000[which(nanopore_cov10_auto_100000$chr_num == tmp_genes$seqnames[i] & nanopore_cov10_auto_100000$Start <= (tmp_genes$end[i]+5000) & nanopore_cov10_auto_100000$Start >= tmp_genes$end[i]),]
    if(nrow(gene.sub) > 0){
      plot.coords<-rbind(plot.coords, cbind(gene.sub$NeuN_per_methylation, gene.sub$NeuN_per_hydroxymethylation, gene.sub$Sox10_per_methylation, gene.sub$Sox10_per_hydroxymethylation, gene.sub$IRF8_per_methylation, gene.sub$IRF8_per_hydroxymethylation, 1+(gene.sub$Start-tmp_genes$end[i])/5000))
    }
    
  }
  
}

### sort so can plot moving average

plot.coords<-plot.coords[order(plot.coords[,7]),]

### calculate moving average for each type of methylation for overlap 1% sliding windows
mav<-matrix(NA, nrow = 300, ncol = 7)
count<-0
for(i in seq(-1, 1.99, 0.01)){
  count<-count+1
  index<-which(plot.coords[,7] < (i+0.01) & plot.coords[,7] >= i)
  sub<-plot.coords[index,]
  if(length(index) > 1){
    mav[count, 2]<-mean(sub[,1], na.rm = TRUE)
    mav[count, 3]<-mean(sub[,2], na.rm = TRUE)
    mav[count, 4]<-mean(sub[,3], na.rm = TRUE)
    mav[count, 5]<-mean(sub[,4], na.rm = TRUE)
    mav[count, 6]<-mean(sub[,5], na.rm = TRUE)
    mav[count, 7]<-mean(sub[,6], na.rm = TRUE)
  } else {
    mav[count, 2]<-sub[1]
    mav[count, 3]<-sub[2]
    mav[count, 4]<-sub[3]
    mav[count, 5]<-sub[4]
    mav[count, 6]<-sub[5]
    mav[count, 7]<-sub[6]
  }
  
}
mav[,1]<-seq(-0.995, 2, 0.01)
colnames(mav)<-c("RelativeDistance", "NeuN_per_methylation", "NeuN_per_hydroxymethylation","Sox10_per_methylation", "Sox10_per_hydroxymethylation", "IRF8_per_methylation", "IRF8_per_hydroxymethylation")
rects<-data.frame(start = c(-1,0,1), end = c(0,1,2), group = c("Upstream", "Gene Body", "Downstream"))


#Gene Body Plot - NeuN + Sox10 + IRF8: 5mC + 5hmC
ggplot(data = as.data.frame(mav),aes(x=RelativeDistance)) +
  geom_line(aes(y = NeuN_per_methylation, color = "NeuN 5mC"), lwd=1) +
  geom_line(aes(y = NeuN_per_hydroxymethylation, color = "NeuN 5hmC"), lwd=1) +
  geom_line(aes(y = Sox10_per_methylation, color = "Sox10 5mC"), lwd=1) +
  geom_line(aes(y = Sox10_per_hydroxymethylation, color = "Sox10 5hmC"), lwd=1) +
  geom_line(aes(y = IRF8_per_methylation, color = "IRF8 5mC"), lwd=1) +
  geom_line(aes(y = IRF8_per_hydroxymethylation, color = "IRF8 5hmC"), lwd=1) +
  scale_color_manual("",breaks = c("NeuN 5mC","NeuN 5hmC","Sox10 5mC","Sox10 5hmC","IRF8 5mC","IRF8 5hmC"), values = c("darkblue","lightblue","darkred","pink","darkgreen","lightgreen")) +
  
  geom_rect(data = rects, inherit.aes=FALSE, aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf, fill = group), alpha = 0.05)  + scale_x_continuous("Position Relative to Gene", breaks = c(-1,0,1,2), labels = c("5kb Upstream", "Gene Start", "Gene End", "5kb Downstream"), limits = c(-1,2), expand = c(0,0)) +
  labs(title="",y = "% (hydroxy)methylation") + ylim(0,100)  + theme_bw()
