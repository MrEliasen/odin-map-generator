package terrain

import "core:math"
import "core:os"
import "core:strconv"
import stbi "vendor:stb/image"

Vector4 :: [4]f32
Vector2 :: [2]f32
Vector2i :: [2]int

distance_to_edge :: proc(width, height, x, y: int) -> int {
    return math.min(x, width - x, y, height - y)
}

inverse_lerp :: proc(min, max, value: f32) -> f32 {
    t := (value - min) / (max - min)
    return math.clamp(t, 0.0, 1.0)
}

hex_string_to_rgba :: proc(color_str: string) -> Vector4 {
    if len(color_str) < 6 {
        return {}
    }

    s := color_str
    if s[0] == '#' {
        s = s[1:]
    }

    if len(s) != 6 {
        return {}
    }

    red_str := s[0:2]
    green_str := s[2:4]
    blue_str := s[4:6]

    red, rok := strconv.parse_int(red_str, 16)
    if !rok {
        return {}
    }
    green, gok := strconv.parse_int(green_str, 16)
    if !gok {
        return {}
    }
    blue, bok := strconv.parse_int(blue_str, 16)
    if !bok {
        return {}
    }

    return Vector4{f32(red) / 255.0, f32(green) / 255.0, f32(blue) / 255.0, 1.0}
}

save_terrain_image :: proc(terrain: [][]Terrain) {
    MAP_WIDTH := len(terrain[0])
    MAP_HEIGHT := len(terrain)

    pixel_data := make([]u8, MAP_WIDTH * MAP_HEIGHT * 4)
    defer delete(pixel_data)

    for row, y in terrain {
        for tile, x in row {
            // probably don't need to clamp here,
            // but I am afraid to completely trust the hex->rgba math
            r := u8(math.clamp(tile.colour[0], 0.0, 1.0) * 255.0)
            g := u8(math.clamp(tile.colour[1], 0.0, 1.0) * 255.0)
            b := u8(math.clamp(tile.colour[2], 0.0, 1.0) * 255.0)
            a := u8(math.clamp(tile.colour[3], 0.0, 1.0) * 255.0)

            index := (y * MAP_WIDTH + x) * 4

            pixel_data[index + 0] = r
            pixel_data[index + 1] = g
            pixel_data[index + 2] = b
            pixel_data[index + 3] = a
        }
    }

    stbi.write_png(
        "terrain.png",
        i32(MAP_WIDTH),
        i32(MAP_HEIGHT),
        4,
        raw_data(pixel_data),
        4 * i32(MAP_WIDTH),
    )
}

save_cave_image :: proc(layout: [][]bool) {
	MAP_HEIGHT := len(layout)
	MAP_WIDTH := len(layout[0])

	pixel_data := make([]u8, MAP_WIDTH * MAP_HEIGHT * 4)
    defer delete(pixel_data)

	white := hex_string_to_rgba("#FFFFFF")
	black := hex_string_to_rgba("#000000")

	for row, y in layout {
		for is_wall, x in row {
			colour := is_wall ? black : white

			// probably don't need to clamp here,
			// but I am afraid to completely trust the hex->rgba math
			r := u8(math.clamp(colour[0], 0.0, 1.0) * 255.0)
			g := u8(math.clamp(colour[1], 0.0, 1.0) * 255.0)
			b := u8(math.clamp(colour[2], 0.0, 1.0) * 255.0)
			a := u8(math.clamp(colour[3], 0.0, 1.0) * 255.0)

			index := (y * MAP_WIDTH + x) * 4

			pixel_data[index + 0] = r
			pixel_data[index + 1] = g
			pixel_data[index + 2] = b
			pixel_data[index + 3] = a
		}
	}

	stbi.write_png(
		"cave.png",
		i32(MAP_WIDTH),
		i32(MAP_HEIGHT),
		4,
		raw_data(pixel_data),
		4 * i32(MAP_WIDTH),
	)
}
