package world_gen

import "core:fmt"
import "core:mem"

main :: proc() {
	// World / Island Generation
	// create our noise config
	world_config := new_world_config(154914, oct = 12, freq = 0.005)
	// generate initial noise map 
	hm := generate_world_noise_map(512, 512, world_config)
    defer cleanup(hm)

	// apply island algo to the noise map
	noise_map_to_island(hm, 0.3, 112, 0.2)
	// generate terrain from noise map
	tm := generate_terrain(hm)
    defer cleanup(tm)

	// save terrain as image
	save_terrain_image(tm)
}

cleanup :: proc(data: [][]$T) {
	for y in 0 ..< len(data) {
		delete(data[y])
	}

	delete(data)
}
