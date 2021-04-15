###########################################################################
###########################################################################
###
###
### ipak ("Install R Packages")
### 
### Author: Monica C. 
### Revised: Samir Rachid Zaim
### Date modified: 3/30/2021 
###
### Desc: This function is intended to provide a list of R packages used 
###       by the CompBio group and provide an automated way to install
###       all required R packages from CRAN, Bioconductor, and GitHub 
###       using an install.package shortcut ("ipak") to install across
###       different repositories
###
### Function: ipak
### Input:  [1] R package list, 
###         [2] associated repository
###
### output: Package installation onto PC/laptop
### 
###
###########################################################################
###########################################################################

installPackage=F

ipak <- function(pkg, repository = c("CRAN", "Bioconductor", "github")) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  # new.pkg <- pkg
  if (length(new.pkg)) {
    if (repository == "CRAN") {
      install.packages(new.pkg, dependencies = TRUE)
    }
    if (repository == "Bioconductor") {
      if (strsplit(version[["version.string"]], " ")[[1]][3] > "3.6.0") {
        if (!requireNamespace("BiocManager")) {
          install.packages("BiocManager")
        }
        BiocManager::install(new.pkg, dependencies = TRUE, ask = FALSE)
      }
      if (strsplit(version[["version.string"]], " ")[[1]][3] < "3.6.0") {
        stop(message("powsimR depends on packages that are only available in R 3.6.0 and higher."))
      }
    }
    if (repository == "github") {
      devtools::install_github(new.pkg, build_vignettes = FALSE, force = FALSE, 
                               dependencies = TRUE)
    }
  }
}


# ##########################################################################
# ##########################################################################
# ###### Install packages 

# CRAN PACKAGES
cranpackages <- c("broom", "cobs", "cowplot", "data.table", "doParallel", "dplyr",
                  "DrImpute", "fastICA", "fitdistrplus", "foreach", "future", "gamlss.dist", "ggplot2",
                  "ggpubr", "grDevices", "grid", "Hmisc", "kernlab", "MASS", "magrittr", "MBESS",
                  "Matrix", "matrixStats", "mclust", "methods", "minpack.lm", "moments", "msir",
                  "NBPSeq", "nonnest2", "parallel", "penalized", "plyr", "pscl", "reshape2", "Rmagic",
                  "rsvd", "Rtsne", "scales", "Seurat", "snow", "sctransform", "stats", "tibble",
                  "tidyr", "truncnorm", "VGAM", "ZIM", "zoo", "pryr")

# BIOCONDUCTOR
biocpackages <- c("bayNorm", "baySeq", "BiocGenerics", "BiocParallel", "DEDS", "DESeq2",
                  "EBSeq", "edgeR", "IHW", "iCOBRA", "limma", "Linnorm", "MAST", "monocle", "NOISeq",
                  "qvalue", "ROTS", "RUVSeq", "S4Vectors", "scater", "scDD", "scde", "scone", "scran",
                  "SCnorm", "SingleCellExperiment", "SummarizedExperiment", "zinbwave", "annotate", "genefilter")

# GITHUB
githubpackages <- c("nghiavtr/BPSC", "cz-ye/DECENT", "mohuangx/SAVER", "statOmics/zingeR")

##########################################################################
##########################################################################

## Package install

if(installPackage){
  pak(biocpackages, repository = "Bioconductor")
  ipak(cranpackages, repository = "CRAN")
  ipak(githubpackages, repository = "github")
  
  ##----------------- Code for installing libraries----------------
  install.packages("devtools")
  library(devtools)
  
  
  
  # To check whether all dependencies are installed, you can run the following lines:
  powsimRdeps <- data.frame(Package = c(cranpackages,
                                        biocpackages,
                                        sapply(strsplit(githubpackages, "/"), "[[", 2)),
                            stringsAsFactors = F)
  
  ip <- as.data.frame(installed.packages()[,c(1,3:4)], stringsAsFactors = F)
  
  ip.check <- cbind(powsimRdeps,
                    Version = ip[match(powsimRdeps$Package, rownames(ip)),"Version"])
  
  ip.table <- table(is.na(ip.check$Version))  # all should be FALSE
  cat(paste('package', ip.check[which(is.na(ip.check[,2])),][1], 'was not installed'))
  
}
