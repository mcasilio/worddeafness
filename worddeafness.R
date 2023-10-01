################################################################################
# Code for reproducing analyses in Casilio et al., "Situating word deafness
# in aphasia recovery"

# Last updated by Marianne Casilio on 9/25/2023
# Questions? Email marianne.e.casilio@vanderbilt.edu
################################################################################

setwd("~/Desktop/case2200/") # change if needed
data = read.table("worddeafness_data.txt", header = TRUE)

install.packages('singcar') # install packages if needed
library(singcar)

################################################################################
# Crawford-Howell t-statistics
################################################################################

# PALPA 45
TD(data[1,6], data[1,4], sd = data[1,5], alternative = c("less"), 
   sample_size = data[1,3])
TD(data[2,6], data[2,4], sd = data[2,5], alternative = c("less"), 
   sample_size = data[2,3])
TD(data[3,6], data[3,4], sd = data[3,5], alternative = c("less"), 
   sample_size = data[3,3])
TD(data[4,6], data[4,4], sd = data[4,5], alternative = c("less"), 
   sample_size = data[4,3])

# PALPA 36
TD(data[7,6], data[7,4], sd = data[7,5], alternative = c("less"), 
   sample_size = data[7,3])
TD(data[8,6], data[8,4], sd = data[8,5], alternative = c("less"), 
   sample_size = data[8,3])
TD(data[9,6], data[9,4], sd = data[9,5], alternative = c("less"), 
   sample_size = data[9,3])
TD(data[10,6], data[10,4], sd = data[10,5], alternative = c("less"), 
   sample_size = data[10,3])

# PALPA 35
TD(data[11,6], data[11,4], sd = data[11,5], alternative = c("less"), 
   sample_size = data[11,3])
TD(data[12,6], data[12,4], sd = data[12,5], alternative = c("less"), 
   sample_size = data[12,3])

# PALPA 5
TD(data[13,6], data[13,4], sd = data[13,5], alternative = c("less"), 
   sample_size = data[13,3])
TD(data[14,6], data[14,4], sd = data[14,5], alternative = c("less"), 
   sample_size = data[13,3])
TD(data[15,6], data[15,4], sd = data[15,5], alternative = c("less"), 
   sample_size = data[15,3])
TD(data[16,6], data[16,4], sd = data[16,5], alternative = c("less"), 
   sample_size = data[16,3])
TD(data[17,6], data[17,4], sd = data[17,5], alternative = c("less"), 
   sample_size = data[17,3])

# PALPA 1
TD(data[18,6], data[18,4], sd = data[18,5], alternative = c("less"), 
   sample_size = data[18,3])
TD(data[19,6], data[19,4], sd = data[19,5], alternative = c("less"), 
   sample_size = data[19,3])

# PALPA 2
TD(data[20,6], data[20,4], sd = data[20,5], alternative = c("less"), 
   sample_size = data[20,3])
TD(data[21,6], data[21,4], sd = data[21,5], alternative = c("less"), 
   sample_size = data[21,3])

# QAB
TD(data[22,6], data[22,4], sd = data[22,5], alternative = c("less"), 
   sample_size = data[22,3])
TD(data[23,6], data[23,4], sd = data[23,5], alternative = c("less"), 
   sample_size = data[23,3])
TD(data[24,6], data[24,4], sd = data[24,5], alternative = c("less"), 
   sample_size = data[24,3])
TD(data[25,6], data[25,4], sd = data[25,5], alternative = c("less"), 
   sample_size = data[25,3])
TD(data[26,6], data[26,4], sd = data[26,5], alternative = c("less"), 
   sample_size = data[26,3])
TD(data[27,6], data[27,4], sd = data[27,5], alternative = c("less"), 
   sample_size = data[27,3])

# BNT
TD(data[28,6], data[28,4], sd = data[28,5], alternative = c("less"), 
   sample_size = data[28,3])

# MBEA
TD(data[29,6], data[29,4], sd = data[29,5], alternative = c("less"), 
   sample_size = data[26,3])
TD(data[30,6], data[30,4], sd = data[30,5], alternative = c("less"), 
   sample_size = data[30,3])

# fMRI
TD(data[31,6], data[31,4], sd = data[31,5], alternative = c("less"), 
   sample_size = data[31,3])
TD(data[32,6], data[32,4], sd = data[32,5], alternative = c("less"), 
   sample_size = data[32,3])
TD(data[33,6], data[33,4], sd = data[33,5], alternative = c("less"), 
   sample_size = data[24,3])
TD(data[34,6], data[34,4], sd = data[34,5], alternative = c("less"), 
   sample_size = data[25,3])
TD(data[35,6], data[35,4], sd = data[35,5], alternative = c("less"), 
   sample_size = data[35,3])
TD(data[36,6], data[36,4], sd = data[36,5], alternative = c("less"), 
   sample_size = data[36,3])
TD(data[37,6], data[37,4], sd = data[37,5], alternative = c("less"), 
   sample_size = data[37,3])
TD(data[38,6], data[38,4], sd = data[38,5], alternative = c("less"), 
   sample_size = data[38,3])
TD(data[39,6], data[39,4], sd = data[39,5], alternative = c("less"), 
   sample_size = data[39,3])
TD(data[40,6], data[40,4], sd = data[40,5], alternative = c("less"), 
   sample_size = data[40,3])
TD(data[41,6], data[41,4], sd = data[41,5], alternative = c("less"), 
   sample_size = data[41,3])
TD(data[42,6], data[42,4], sd = data[42,5], alternative = c("less"), 
   sample_size = data[42,3])

# PPT
TD(data[43,6], data[43,4], sd = data[43,5], alternative = c("less"), 
   sample_size = data[43,3])




