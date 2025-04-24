package terrain

import "core:math"
import "core:math/noise"
import "core:mem"

Noise_Config :: struct {
	seed:        int,
	inverse:     bool,
	octaves:     int, // how much detail to add; lower value = less detail
	frequency:   f64, // x axis; lower value = larger features 
	amplitude:   f64, // Y axis; lower value = taller peaks and deeper valleys
	lacunarity:  f64, // > 1; frequency multiplier for the octaves; larger = more details
	persistence: f64, // 0-1; amplitude multiplier for the octaves; larger = more influence
}

/*
    Kept some reasonable defaults.
*/
new_world_config :: proc(
	seed: int,
	inverse: bool = false,
	oct: int = 8,
	freq: f64 = 0.01,
	amp: f64 = 1.0,
	lac: f64 = 2.0,
	per: f64 = 0.6,
) -> Noise_Config {
	return Noise_Config {
		seed = seed,
		inverse = inverse,
		octaves = oct,
		frequency = freq,
		amplitude = amp,
		lacunarity = lac,
		persistence = per,
	}
}

generate_world_noise_map :: proc(height, width: int, config: Noise_Config) -> [][]f32 {
	heightmap := make([][]f32, height)

	lowest: f64 = 0
	highest: f64 = 0
	for y in 0 ..< height {
		heightmap[y] = make([]f32, width)

		for x in 0 ..< width {
			frequency := config.frequency
			amplitude := config.amplitude
			noise_value: f64 = 0

			for _ in 0 ..< config.octaves {
				sample := noise.Vec2{f64(x), f64(y)}
				sample *= frequency

				noise := noise.noise_2d_improve_x(i64(config.seed), sample)
				noise_value += f64(noise) * amplitude

				amplitude *= config.persistence
				frequency *= config.lacunarity
			}

			if noise_value > highest {
				highest = noise_value
			} else if noise_value < lowest {
				lowest = noise_value
			}

			heightmap[y][x] = f32(noise_value)
		}
	}

	n_min := f32((lowest + 1.0) / 0.5)
	n_max := f32((highest + 1.0) / 0.5)

	for y in 0 ..< height {
		for x in 0 ..< width {
			value := heightmap[y][x]
			if config.inverse {
				value *= -1
			}

			value = (value + 1.0) / 0.5
			heightmap[y][x] = inverse_lerp(n_min, n_max, value)
		}
	}

	return heightmap
}
