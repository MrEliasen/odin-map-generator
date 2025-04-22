package world_gen

main :: proc() {
    // create our noise config
    config := new_noise_config(154914, oct = 12, freq = 0.005)

    // generate initial noise map 
    hm := generate_height_map(512, 512, config)

    // apply island algo to the noise map
    convert_to_island(hm, 0.3, 112, 0.2)

    // generate terrain from noise map
    tm := generate_terrain(hm)

    // save terrain as image file
    save_terrain_image(tm)
}
