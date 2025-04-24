package world_gen

import "core:fmt"
import "core:math"
import "core:math/noise"
import "core:mem"
import stbi "vendor:stb/image"

Cave_Config :: struct {
	seed:             int,
	fill_percent:     f32, // 0.0 = 1.0
	smoothing_parses: int,
}

new_cave_config :: proc(
	seed: int,
	fill_percent: f32 = 0.48,
	smoothing_parses: int = 2,
) -> Cave_Config {
	return Cave_Config {
		seed = seed,
		fill_percent = fill_percent,
		smoothing_parses = smoothing_parses,
	}
}

generate_cave :: proc(width, height: int, config: Cave_Config) -> [][]bool {
	layout := make([][]bool, height)
	for y in 0 ..< height {
		layout[y] = make([]bool, width)

		for x in 0 ..< width {
			if x == 0 || x == width - 1 || y == 0 || y == height - 1 {
				layout[y][x] = true
				continue
			}

			sample := noise.Vec2{f64(x), f64(y)}
			noise := (noise.noise_2d_improve_x(i64(config.seed), sample) + 1.0) * 0.5
			layout[y][x] = noise <= config.fill_percent
		}
	}

	for n := 0; n < config.smoothing_parses; n += 1 {
		for y in 0..<height {
			for x in 0..<width {
				neighbours := 0

				for yy := y - 1; yy <= y + 1; yy += 1 {
					for xx := x - 1; xx <= x + 1; xx += 1 {
						if xx < 0 || xx >= width || yy < 0 || yy >= height {
							neighbours += 1
							continue
						}

						if xx == x && yy == y {
							continue
						}

						if layout[yy][xx] {
							neighbours += 1
						}
					}
				}


				if neighbours == 4 {
					continue
				}

				layout[y][x] = neighbours > 4
			}
		}
	}


	return layout
}
