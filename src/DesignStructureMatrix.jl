module DesignStructureMatrix

using Luxor
using LinearAlgebra

export plotDSM
export toReachableMatrix
export OrderReachable
export Sequencing
export Clustering

include("plotDSM.jl")
include("sequencing.jl")
include("clustering.jl")

end
