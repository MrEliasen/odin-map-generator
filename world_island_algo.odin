package terrain

import "core:math"

/*
    Will fade out the height of the tiles towards target_height, based on distance to the edge.

    -> target_height: the height to fade to
    -> fade_distance: how far in the fade should start, bigger number == smoother fade
    -> fade_amount: the height multiplier to use when at the edge of the map

    Eg. if your fade_distance is "5" and fade_amount is "0.35" the fading curve would look like:
    
    |==========|===================|
    | Distance | Height Multiplier |
    |==========|===================|
    | 5        | 1.0               |
    |----------|-------------------|
    | 4        | 0.87              |
    |----------|-------------------|
    | 3        | 0.74              |
    |----------|-------------------|
    | 2        | 0.61              |
    |----------|-------------------|
    | 1        | 0.47999..         |
    |----------|-------------------|
    | 0        | 0.34999..         |
    |----------|-------------------|
*/
noise_map_to_island :: proc(
    hm: [][]f32,
    target_height: f32,
    fade_distance: int,
    fade_amount: f32 = 0.2,
) {
    height := len(hm)
    width := len(hm[0])

    for y in 0 ..< height {
        for x in 0 ..< width {
            if hm[y][x] <= target_height {
                continue
            }

            dist := distance_to_edge(width, height, x, y)

            if dist >= fade_distance {
                continue
            }

            hm[y][x] *=
                (fade_amount +
                    ((1.0 - fade_amount) * inverse_lerp(0, f32(fade_distance), f32(dist))))
        }
    }
}
