package world_gen

import "core:mem"

Terrain :: struct {
    name:      string,
    elevation: f32,
    colour:    [4]f32,
}

/*
    The elevation is just some values I found gives a good result for what I am after.
    If you want to crate terrain which weighted different, simply change below:
*/
terrain_tiles := [8]Terrain {
    {name = "deep water", elevation = 0.2, colour = hex_string_to_rgba("#3A6EC7")},
    {name = "shallow water", elevation = 0.3, colour = hex_string_to_rgba("#4071CD")},
    {name = "sand", elevation = 0.35, colour = hex_string_to_rgba("#D5D788")},
    {name = "grass", elevation = 0.5, colour = hex_string_to_rgba("#60A217")},
    {name = "forest", elevation = 0.65, colour = hex_string_to_rgba("#477613")},
    {name = "rock", elevation = 0.75, colour = hex_string_to_rgba("#634A44")},
    {name = "mountain", elevation = 0.93, colour = hex_string_to_rgba("#4A3C39")},
    {name = "show", elevation = 1.0, colour = hex_string_to_rgba("#D4D4D4")},
}

generate_terrain :: proc(heightmap: [][]f32) -> [][]Terrain {
    terrain := make([][]Terrain, len(heightmap))
    for y in 0 ..< len(heightmap) {
        terrain[y] = make([]Terrain, len(heightmap[y]))

        for x in 0 ..< len(heightmap[y]) {
            for tile in terrain_tiles {
                if heightmap[y][x] <= tile.elevation {
                    terrain[y][x] = tile
                    break
                }
            }
        }
    }

    return terrain
}
