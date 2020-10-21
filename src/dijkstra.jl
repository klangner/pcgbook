using DataStructures

struct PosDepth
    pos::CartesianIndex{2}
    depth::Int
end

function PosDepth(r::Int, c::Int, depth::Int)
    PosDepth(CartesianIndex(r,c), depth)
end


function get_available_exits(tiles::BitArray{2}, pos::CartesianIndex{2})::Array{PosDepth,1}
    exits = Array{PosDepth,1}(undef, 0)
    if pos[1] > 1 && tiles[pos[1]-1, pos[2]]
        push!(exits, PosDepth(pos[1]-1, pos[2], 1))
    end 
    if pos[1] < size(tiles)[1] && tiles[pos[1]+1, pos[2]]
        push!(exits, PosDepth(pos[1]+1, pos[2], 1))
    end 
    if pos[2] > 1 && tiles[pos[1], pos[2]-1]
        push!(exits, PosDepth(pos[1], pos[2]-1, 1))
    end 
    if pos[2] < size(tiles)[2] && tiles[pos[1], pos[2]+1]
        push!(exits, PosDepth(pos[1], pos[2]+1, 1))
    end 
    exits
end


function dijkstra_map(tiles::BitArray{2}, pos::CartesianIndex{2})::Array{Int,2}
    map = Array{Int,2}(undef, size(tiles))
    max_depth = size(tiles)[1] * size(tiles)[2]
    fill!(map, max_depth)
    open_list = Deque{PosDepth}()
    push!(open_list, PosDepth(pos, 0))
    map[pos] = 0

    while !isempty(open_list)
        pos_depth = popfirst!(open_list)
        exits = get_available_exits(tiles, pos_depth.pos)
        for exit in exits
            new_depth = pos_depth.depth + exit.depth
            prev_depth = map[exit.pos]
            if new_depth < prev_depth && new_depth < max_depth
                map[exit.pos] = new_depth;
                push!(open_list, PosDepth(exit.pos, new_depth))
            end
        end
    end
    map
end

# -------------------------------------------------------------------------------------------------
# Visualization
# -------------------------------------------------------------------------------------------------

using Random
using Makie
Makie.AbstractPlotting.inline!(true)


function render(map::Array{Int,2})
    scene = Scene(resolution = size(map) .* 10)
    heatmap!(scene, map, colormap = :rainbow, show_axis = false, backgroundcolor = :black)
end


function test_dijkstra()
    tiles = bitrand(64, 64)
    map = dijkstra_map(tiles, CartesianIndex(1, 1))
    render(map)
end

# test_dijkstra()