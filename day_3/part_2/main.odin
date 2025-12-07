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
        values: [12]int
        index := 0
        for i := 12; i > 0; i-=1 {
            // Get the largest number that is at least "i" back from the last number
            // since we always want to end up with at least a 12 digit number.
            largest, largest_index := find_largest(line[index:len(line) - i + 1])
            values[12-i] = largest
            index += largest_index + 1
        }
        value, _ := strconv.parse_int(fmt.tprintf("%v%v%v%v%v%v%v%v%v%v%v%v", values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7], values[8], values[9], values[10], values[11]))
        total += value
    }

    fmt.println(total)
}
