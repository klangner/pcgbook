using Random

include("dijkstra.jl")

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
    starting_point = CartesianIndex(1, 1)
    exit_point = CartesianIndex(width, height)
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
    dm = dijkstra_map(m.tiles, m.starting_point)
    dist = dm[m.exit_point]
    if dist < size(dm)[1] * size(dm)[2]
        dist
    else
        0
    end
end

# -------------------------------------------------------------------------------------------------
# Visualization
# -------------------------------------------------------------------------------------------------

using Makie
Makie.AbstractPlotting.inline!(true)


function render(tiles::BitArray{2})
    scale = 700 / max(size(tiles)[1], size(tiles)[2]) 
    scene = Scene(resolution = size(tiles) .* scale)
    heatmap!(scene, tiles, colormap = :grays, show_axis = false, backgroundcolor = :black)
end


function test()
    m = Map(8, 8, [1,2])
    fitness = evaluate(m)
    println("Fitness: ", fitness)
    dm = dijkstra_map(m.tiles, m.starting_point)
    render(m.tiles)
end

test()
