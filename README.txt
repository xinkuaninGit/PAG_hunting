# Code Used For Analysis of PAG Neurons' Activity in Hunting Behavior

## Contents

- [Overview](#overview)
- [File Contents](#file-contents)
- [System Requirements](#system-requirements)
- [Installation Guide](#installation-guide)
- [Demo](#demo)
- [Instructions for use](#Instructions-for-use)
- [Code availability](#code-availability)

# Overview

PAG Neuron's acitivity was obtained from OpenEphys recording system and clutered in MClust, but still need former data processing. We
wrtie these code for transforming rawdata, adding event timestamps, plotting PSTH and neuron clustering analysis in MATLAB platform.

# File Contents

- [src](./src): all source code.
- [demo](./demo): data demos.

# System Requirements

This package runs in MATLAB 2014b

## Install

extract PAG_huting.zip to some directory.
In Matlab, go to 'file>set path...>Add with Subfolders'
select the directory with the extracted PAG_huting contents
click 'Save'
click 'Close'

# Demo

This demo include data recoded in our system for a same hunting session. 

# Instructions for use

Just open code and RUN it~

## For optrode identified, use code in file '.\optrode'.
## For STEMG analysis, use code in file '.\stemg'.
## For Hunting related analysis, use code 'TransformRawdata2HuntRelated.m', 'PlotHotmapForAllNeurons.m' and 'PlotSigleNeuronInHunting.m'.
## For PCA and Clustering, use code 'PCAandHierarchicalClustering.m'.

#Code availability
The code that supports the findings of this study is available from the corresponding authors upon reasonable request.