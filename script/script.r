if (!require(flowCore)) {
  source("http://bioconductor.org/biocLite.R")
  biocLite("flowCore")
}

# for (idx in 1:1000){
#  print(paste(idx, "Hello, world!", sep = " "))
# }

print(paste("Start", "Hello, world!", sep = " "))
Sys.sleep(350)
print(paste("End", "Hello, world!", sep = " "))
