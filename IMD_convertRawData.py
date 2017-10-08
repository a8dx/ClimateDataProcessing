
# Filename: IMD_convertRawData.py
# Author: Anthony Louis D'Agostino (ald at stanford dot edu)
# Date Created: 06/01/2017 
# Last Edited: 10/07/2017
# Data: from NCC ZIP file   
# Purpose: Reads in GRaDS data files, concatenates them, and then exports netCDF versions  
# Notes: To be run after "convert_to_GrADS.R"


import os 
from cdo import * 
from netCDF4 import Dataset
import numpy as np
#import pandas as pd 


cdo = Cdo() 


root_path = "/tmp" 
ctl_root = os.path.join(root_path, "CTL_Files")


def tempOutput(var, ctl, root):
	"""
	Read in binary data and output as a netCDF file.
	var: weather variable   
	ctl: root path for all .ctl's
	root: project root path
	"""

	# -- rename variables for consistency with other projects
	temp_rename = {"MaxT": "tmax", "MinT": "tmin", "MeanT": "tmean"}

	# initialize using first year's data 
	t = cdo.import_binary(input = os.path.join(ctl, var, var + "_1951.ctl"))

	# -- loop through each remaining year 
	for y in range(1952,2015):
		print "Now processing " + str(y)
		fn = var + "_" + str(y) + ".ctl"	
		print "Processing " + str(os.path.join(ctl_root, var, fn))

		# -- concatenate into a single file
		data = cdo.import_binary(input = os.path.join(ctl_root, var, fn))
		t = cdo.cat(input = " ".join([t,data]))

	# -- save variable-specific file	
	t = cdo.copy(input = t, options = "-f nc", output = os.path.join(root, temp_rename[var] + "Proc.nc"))


tempOutput("MaxT", ctl_root, root_path)
tempOutput("MinT", ctl_root, root_path)
tempOutput("MeanT", ctl_root, root_path)
