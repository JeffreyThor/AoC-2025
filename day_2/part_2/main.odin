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
            for i in 2..=len(string_value) {
                if len(string_value) % i != 0 {
                    continue
                }
                chunk_size := len(string_value) / i
                chunk := string_value[:chunk_size]
                repeating := false
                for index := chunk_size; index < len(string_value); index+= chunk_size {
                    if chunk != string_value[index:index+chunk_size] {
                        repeating = false
                        break
                    } else {
                        repeating = true
                    }
                }
                if repeating == true {
                    sum += value
                    break
                }
            }
        }
    }

    fmt.println(sum)
}
