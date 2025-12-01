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

    current := 50
    counter := 0

    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        value, ok := strconv.parse_int(line[1:])
        if !ok {
            // could not parse int
            return
        }
        value = value % 100

        fmt.printfln("current:   %v", current)
        fmt.printfln("value:     %v%v", line[0] == 'R' ? "+" : "-", value)

        if line[0] == 'R' {
            new := current + value
            if new > 99 {
                current = new - 100
            } else {
                current = new
            }
        } else if line[0] == 'L' {
            new := current - value
            if new < 0 {
                current = 100 + new
            } else {
                current = new
            }
        }
        if current < 0 || current > 99 {
            fmt.printfln("ERROR\ncurrent: %v\nvalue: %v", current, value)
            return
        }
        if current == 0 {
            counter += 1
        }
    }

    fmt.printfln("zero count: %v", counter)
}
