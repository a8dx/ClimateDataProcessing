# Filename: convert_to_GrADS.R  
# Author: Anthony Louis D'Agostino (ald at stanford dot edu)
# Date Created: September 16, 2015
# Last Edited: October 07, 2017
# Purpose: Modifies the NCC-provided CTL file and generates unique versions for each year of data, each type of temperature
#   max, min, mean. 

# Notes: While perhaps an overkill, this is generalizable to a setting where grids are file-specific.  


rm(list = ls())


root.path <- "/tmp"

# -- create path for generated GrADS control .CTL files. 
ctl.path <- paste(root.path, "CTL_Files", sep = "/")
if (file.exists(ctl.path) == FALSE){
  dir.create(ctl.path)
}

# -- data stored in three separate variable-specific folders
temp_types = c("MinT", "MaxT", "MeanT")

for (x in temp_types) { 
  type.path <- paste(ctl.path, x, sep = "/")
  if (file.exists(type.path) == FALSE){
    dir.create(type.path)
  }
  
  # -- year range for which data is available
  for (i in 1951:2014){  
    print(paste0("Now processing year ", i, " for variable ", x))
    
    # -- read in and update template .CTL provided by IMD
    ctl_file <- read.delim(paste0(root.path, "/Temp.ctl"), header = FALSE, sep = " ", stringsAsFactors = FALSE)
    
    # -- file reference for source GRD 
    ctl_file[1,"V2"] <- paste0(root.path, "/", x, "/", x, "_", i, ".GRD")
    if (i %% 4 == 0){
      ctl_file[7,"V2"] <- 366   # account for leap years in total number of timesteps 
    } else {
      ctl_file[7, "V2"] <- 365 
    }
    ctl_file[7, "V5"] <- paste0("1JAN", i)
    
    # -- write updated .CTL to file
    write.table(ctl_file, paste(type.path, paste0(x, "_", i, ".ctl"), sep = "/"), quote = FALSE, col.names = FALSE, na = "", row.names = FALSE)
  }
}









