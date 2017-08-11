if (!require(flowCore)) {
  source("http://bioconductor.org/biocLite.R")
  biocLite("flowCore")
}

for (idx in 1:1000){
 print(paste(idx, "Hello, world!", sep = " "))
}
