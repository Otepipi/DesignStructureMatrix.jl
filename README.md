# DesignStructureMatrix
[![Build Status](https://travis-ci.com/Otepipi/DesignStructureMatrix.jl.svg?branch=master)](https://travis-ci.com/Otepipi/DesignStructureMatrix.jl)
[![Codecov](https://codecov.io/gh/Otepipi/DesignStructureMatrix.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Otepipi/DesignStructureMatrix.jl)
[![Coveralls](https://coveralls.io/repos/github/Otepipi/DesignStructureMatrix.jl/badge.svg?branch=master)](https://coveralls.io/github/Otepipi/DesignStructureMatrix.jl?branch=master)

## What is Design Structure Matrix?

**D**esign **S**tructure **M**atrix(**DSM**) is a simple and useful method to represent complex system architectures or projects. 
https://en.wikipedia.org/wiki/Design_structure_matrix


## What is DesignStructureMarix.jl

This package, DesignStructureMatrix offers tools for displaying and analysing DSM. 

## Installation

In Pkg mode(Please hit `]`)

`(v1.1) pkg> add https://github.com/Otepipi/DesignStructureMatrix.jl`

When you use this package, please type

`julia> using DesignStructureMatrix`

## Displaying DSM
you need to prepare adjacency matrix A for systems or projects.  
for example
```julia
##this is adjacency matrix
A = [0 1 0 0 0 1 0; 
    0 0 0 1 0 0 0;
    1 0 0 0 0 0 1;
    0 0 0 0 1 0 0;
    0 1 0 0 0 1 0;
    0 0 1 0 0 0 0;
    1 0 0 0 1 0 0]
```
then
```julia
7×7 Array{Int64,2}:
 0  1  0  0  0  1  0
 0  0  0  1  0  0  0
 1  0  0  0  0  0  1
 0  0  0  0  1  0  0
 0  1  0  0  0  1  0
 0  0  1  0  0  0  0
 1  0  0  0  1  0  0
 ```

next, you need to prepare label for elements in this adjacency matrix.
```julia
label = ["A", "B", "C", "D", "E", "F", "G"]
```
then

```julia
6-element Array{String,1}:
 "A"
 "B"
 "C"
 "D"
 "E"
 "F"
 ```

To display DSM, please type

```julia
plotDSM(A,label)
```
then

![](https://user-images.githubusercontent.com/35882132/59391598-bf501300-8daf-11e9-923b-72509125d567.png)


## Clustering DSM

One of useful ways for analysing DSM is Clustering.

Original DSM is below
```julia
original_DSM = [ 0 1 0 0 1 1 0;
                0 0 0 1 0 0 1;
                0 1 0 1 0 0 1;
                0 1 1 0 1 0 1;
                0 0 0 1 0 1 0;
                1 0 0 0 1 0 0;
                0 1 1 1 0 0 0];

original_label = ["A","B","C","D","E","F","G"];

plotDSM(original_DSM,original_label)

```
original_DSM

![ClusteroriginalDSM](https://user-images.githubusercontent.com/35882132/59392360-54eca200-8db2-11e9-8fa3-6062f31045e5.png)



To get Clustered DSM, please type
```julia
clustered_DSM, clustered_label = Clustering(original_DSM,original_label)
```
and
```julia
plotDSM(clustered_DSM,clustered_label)
```
then, you get clustered DSM

![Clustered_DSM](https://user-images.githubusercontent.com/35882132/59392602-2cb17300-8db3-11e9-8ea3-3c3367ffc18d.png)

## Sequencing DSM

Another way for analysing DSM is seaquencing.

Original DSM is below
``` julia
original_DSM = [0 0 0 0 0 0 0 0 0 0 0 0 0;
                0 0 0 1 0 0 0 0 0 0 0 0 0;
                1 0 0 1 1 0 0 1 0 1 0 0 1;
                1 0 0 0 0 0 0 0 0 0 0 0 0;
                1 1 1 1 0 0 1 1 0 1 1 0 1;
                0 1 0 0 0 0 0 0 1 0 0 0 0;
                0 0 1 1 1 0 0 1 0 1 0 0 1;
                0 1 0 1 0 0 0 0 0 1 0 0 0;
                0 0 1 1 0 0 0 0 0 1 0 0 1;
                0 1 0 1 0 0 0 1 0 0 0 0 0;
                0 0 1 1 1 0 0 1 0 1 0 0 1;
                0 0 0 0 0 0 0 0 0 0 0 0 1;
                0 1 1 1 1 0 1 1 1 1 1 1 0];
        

original_label = ["1", "2", "3", "4", "5", "6", "7", "8", 
                "9", "10", "11", "12", "13"];

plotDSM(original_DSM,original_label)

```
original DSM 

![SequencingoriginalDSM](https://user-images.githubusercontent.com/35882132/59393683-9cc1f800-8db7-11e9-9bb5-f2af79c7f7e9.png)

To get Sequenced DSM, please type

```julia
sequenced_DSM, sequenced_label = Sequencing(original_DSM, original_label);

plotDSM(sequenced_DSM, sequenced_label)
```

then, you get sequenced DSM

![SequencedDSM](https://user-images.githubusercontent.com/35882132/59393832-2d003d00-8db8-11e9-9147-cad34b77a2c7.png)


## Reference

#### Clustering algorithm

>Figueiredo Damásio, J., Almeida Bittencourt, R., Dario, D., & Guerrero, S. (n.d.). Recovery of Architecture Module Views using an Optimized Algorithm Based on Design Structure Matrices. Retrieved from https://arxiv.org/ftp/arxiv/papers/1709/1709.07538.pdf

#### Sequencing algorithm

>Warfield, J. N. (1973). Binary Matrices in System Modeling. IEEE Transactions on Systems, Man and Cybernetics, 3(5), 441–449. https://doi.org/10.1109/TSMC.1973.4309270


And original DSM in chapter `Sequencing DSM` is from the below article


>Yassine, A. A. (2004). An Introduction to Modeling and Analyzing Complex Product Development Processes Using the Design Structure Matrix ( DSM ) Method. Urbana, (January 2004), 1–17. Retrieved from http://ie406.cankaya.edu.tr/uploads/files/Modeling and Analyzing Complex Product Development Processes Using the Design Structure Matrix.pdf