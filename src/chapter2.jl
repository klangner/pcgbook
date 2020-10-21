using Random


# -------------------------------------------------------------------------------------------------
# Content representation
# -------------------------------------------------------------------------------------------------

struct Map 
    genotype::Array{Int, 1}
    tiles::BitArray{2}
    starting_point::CartesianIndex{2}
    exit_point::CartesianIndex{2}
end

"""
    Map(w, h, g)

Create new random map. Add starting point in the upper left corner
end exit point int he lower right.

# Examples
```julia-repl
julia> m = Map(2, 3, [1,2]);
```
"""
function Map(width::Int, height::Int, genotype::Array{Int, 1})
    tiles = bitrand(width, height)
    starting_point = CartesianIndex(1, height)
    exit_point = CartesianIndex(width, 1)
    tiles[starting_point] = true
    tiles[exit_point] = true
    Map(genotype, tiles, starting_point, exit_point)
end

function width(map::Map)
    size(map.tiles)[1]
end

function height(map::Map)
    size(map.tiles)[2]
end

function tiles(m::Map)
    m.tiles
end

function genotype(m::Map)
    m.genotype
end


# -------------------------------------------------------------------------------------------------
# Search algorithm
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# Evaluation functions
# -------------------------------------------------------------------------------------------------

"""
The evaluate score is based on the length of the shortest path between starting and exit point.
If path doesn't exist then the score is equal to 0
"""
function evaluate(m::Map)
    0
end

# -------------------------------------------------------------------------------------------------
# Visualization
# -------------------------------------------------------------------------------------------------

using Makie
Makie.AbstractPlotting.inline!(true)


function render(map::Map)
    scene = Scene(resolution = (width(map)*10, height(map)*10))
    heatmap!(scene, tiles(map), colormap = :grays, show_axis = false, backgroundcolor = :black)
end


function test()
    m = Map(64, 64, [1,2])
    fitness = evaluate(m)
    println("Fitness: ", fitness)
    render(m)
end

test()
