package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
    data, ok := os.read_entire_file("input.txt", context.allocator)
    if !ok {
        // could not read file
        return
    }
    defer delete(data, context.allocator)

    parts := strings.split(string(data), ",")

    sum := 0
    for part in parts {
        range := strings.split(part, "-")
        lower, lower_ok := strconv.parse_int(range[0])
        upper, upper_ok := strconv.parse_int(range[1])
        for value in lower..=upper {
            string_value := fmt.tprint(value)
            if len(string_value) % 2 != 0 {
                continue
            }
            middle := len(string_value) / 2
            first := string_value [:middle]
            second := string_value [middle:]
            if first == second {
                sum += value
            }
        }
    }

    fmt.println(sum)
}
