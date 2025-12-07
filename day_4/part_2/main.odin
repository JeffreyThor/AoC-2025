package main

import "core:fmt"
import "core:os"
import "core:strings"

main :: proc() {
    data, ok := os.read_entire_file("input.txt")
    if !ok {
        // could not read file
        return
    }
    defer delete(data)

    it := string(data)
    grid: [dynamic][dynamic]bool
    total := 0
    width := 0
    height := 0
    defer delete(grid)
    // Transform our file into a grid and load it with bools for if there
    // is a roll there or not
    for line in strings.split_lines_iterator(&it) {
        row: [dynamic]bool
        for r in line {
            if r == '@' {
                append(&row, true)
            } else {
                append(&row, false)
            }
        }
        width = len(row)
        append(&grid, row)
        height += 1
    }

    for {
        // the only change we have to make in part 2 is to keep removing until we can't remove any more
        removed := false
        for row, row_index in grid {
            for value, col_index in row {
                count := 0

                // We only care about checking adjacent if we're currently looking at a roll (value)
                if !value do continue

                // Check every adjacent position in the grid
                if row_index > 0 && col_index > 0 {
                    // top left
                    if grid[row_index-1][col_index-1] == true do count += 1
                }
                if row_index > 0 {
                    // top middle
                    if grid[row_index-1][col_index] == true do count += 1
                }
                if row_index > 0 && col_index < width - 1 {
                    // top right
                    if grid[row_index-1][col_index+1] == true do count += 1
                }
                if col_index > 0 {
                    // middle left
                    if grid[row_index][col_index-1] == true do count += 1
                }
                if col_index < width - 1 {
                    // middle right
                    if grid[row_index][col_index+1] == true do count += 1
                }
                if row_index < height - 1 && col_index > 0 {
                    // bottom left
                    if grid[row_index+1][col_index-1] == true do count += 1
                }
                if row_index < height - 1 {
                    // bottom middle
                    if grid[row_index+1][col_index] == true do count += 1
                }
                if row_index < height - 1 && col_index < width - 1 {
                    // bottom right
                    if grid[row_index+1][col_index+1] == true do count += 1
                }

                if count < 4 {
                    total += 1
                    grid[row_index][col_index] = false
                    removed = true
                }
            }
        }

        // if we didn't remove anything we are done
        if !removed do break
    }


    fmt.println(total)
}
