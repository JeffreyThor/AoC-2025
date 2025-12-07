package main

import "core:fmt"
import "core:log"
import "core:os"
import "core:strconv"
import "core:strings"

// Returns just the first instance of the largest number in the array
// along with its index.
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
        // Get the value and first index of the largest number in the list.
        // Ignore the last number since we do not want to end up with a
        // single digit number in the case that the last is the largest.
        largest, largest_index := find_largest(line[:len(line) - 1])
        // Then find the next largest number after the first largest.
        next_largest, _ := find_largest(line[largest_index+1:])
        value, _ := strconv.parse_int(fmt.tprintf("%v%v", largest, next_largest))
        total += value
    }

    fmt.println(total)
}
