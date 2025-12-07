package main

import "core:fmt"
import "core:log"
import "core:os"
import "core:strconv"
import "core:strings"

find_largest :: proc(nums: string) -> (int, int) {
    largest := 0
    largest_index := 0
    for num, i in nums {
        value, _ := strconv.parse_int(fmt.tprint(num))
        if value > largest {
            largest = value
            largest_index = i
        }
    }
    return largest, largest_index
}

main :: proc() {
    data, ok := os.read_entire_file("input.txt")
    if !ok {
        // could not read file
        return
    }
    defer delete(data)

    it := string(data)
    total := 0
    for line in strings.split_lines_iterator(&it) {
        largest, largest_index := find_largest(line[:len(line) - 1])
        next_largest, _ := find_largest(line[largest_index+1:])
        value, _ := strconv.parse_int(fmt.tprintf("%v%v", largest, next_largest))
        total += value
    }

    fmt.println(total)
}
