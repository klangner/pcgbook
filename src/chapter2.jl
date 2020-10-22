using Random

include("dijkstra.jl")

# -------------------------------------------------------------------------------------------------
# Content representation
# -------------------------------------------------------------------------------------------------

struct Map 
    tiles::BitArray{2}
    starting_point::CartesianIndex{2}
    exit_point::CartesianIndex{2}
end

"""
    Map(w, h)

Create new random map. Add starting point in the upper left corner
end exit point int he lower right.

# Examples
```julia-repl
julia> m = Map(2, 3);
```
"""
function Map(width::Int, height::Int)
    tiles = bitrand(width, height)
    starting_point = CartesianIndex(1, 1)
    exit_point = CartesianIndex(width, height)
    tiles[starting_point] = true
    tiles[exit_point] = true
    Map(tiles, starting_point, exit_point)
end

function Map(tiles::BitArray{2})
    starting_point = CartesianIndex(1, 1)
    dims = size(tiles)
    exit_point = CartesianIndex(dims[1], dims[2])
    tiles[starting_point] = true
    tiles[exit_point] = true
    Map(tiles, starting_point, exit_point)
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

function simulate(μ, λ, num_epoch, mut_prob)
    # Generate μ + λ maps
    population = Array{Map,1}(undef,μ+λ)
    fitness = Array{Int,1}(undef,μ+λ)
    for i in 1:μ
        population[i] = Map(8, 8)
        fitness[i] = evaluate(population[i])
    end
    
    for n in 1:num_epoch
        # Generate λ new offspring based on the best so far
        for i in 1:λ
            parent_map = population[rand(1:μ)]
            tiles = copy(parent_map.tiles)
            # Mutate tiles
            for i in 1:8
                for j in 1:8
                    if rand() <= mut_prob
                        tiles[i,j] = !tiles[i,j]
                    end
                end
            end
            population[μ+i] = Map(tiles)
            fitness[μ+i] = evaluate(population[μ+i])
        end
        # Sort by fitness score
        indices = sortperm(fitness, rev=true)
        population = population[indices]
        fitness = fitness[indices]
    end

    population[1]
end


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

using Statistics
using Makie
Makie.AbstractPlotting.inline!(true)


function render(tiles::BitArray{2})
    scale = 700 / max(size(tiles)[1], size(tiles)[2]) 
    scene = Scene(resolution = size(tiles) .* scale)
    heatmap!(scene, tiles, colormap = :grays, show_axis = false, backgroundcolor = :black)
end


function test()
    num_simulation = 100
    num_epoch = 1_000
    prob_mutation = 0.05
    μ = 100
    λ = 100

    best_score = Array{Int,1}(undef,num_simulation)
    sample_map = undef
    for i in 1:num_simulation
        sample_map = simulate(μ, λ, num_epoch, prob_mutation)
        best_score[i] = evaluate(sample_map)
    end
    println("Mean score: ", mean(best_score))
    render(sample_map.tiles)
end

test()
