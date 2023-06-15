#!/bin/bash

printf "\nBuilding Singularity image"
singularity build dlrm-cpu.sif Singularity.def
