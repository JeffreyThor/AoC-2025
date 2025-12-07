package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

// NOTE: Comments for day 1 are AI generated since I hadn't been writing comments
// while I was working on this problem.
// Advent of Code 2025 - Day 1 Part 1: Secret Entrance
//
// Problem: We have a safe with a dial numbered 0-99. Starting at position 50,
// we follow a series of rotation instructions (L for left/lower numbers,
// R for right/higher numbers). The dial wraps around (0 connects to 99).
//
// The actual password is the count of how many times the dial points to 0
// after any rotation in the sequence.

main :: proc() {
    // Read the input file containing rotation instructions (one per line)
    data, ok := os.read_entire_file("input.txt", context.allocator)
    if !ok {
        // could not read file
        return
    }
    defer delete(data, context.allocator)

    // Initialize the dial position to 50 (starting position as per problem)
    current := 50
    // Counter to track how many times the dial points to 0
    counter := 0

    // Convert file data to string and iterate through each line
    it := string(data)
    for line in strings.split_lines_iterator(&it) {
        // Parse the numeric value from the line (skip first character which is L/R)
        // Example: "L68" -> parse "68" to get the rotation distance
        value, ok := strconv.parse_int(line[1:])
        if !ok {
            // could not parse int
            return
        }
        // Ensure value is within 0-99 range (though input should already be valid)
        value = value % 100

        // Debug output: show current position and the rotation being applied
        fmt.printfln("current:   %v", current)
        fmt.printfln("value:     %v%v", line[0] == 'R' ? "+" : "-", value)

        // Process the rotation based on direction (R = right/clockwise, L = left/counter-clockwise)
        if line[0] == 'R' {
            // Right rotation: add the value to current position
            new := current + value
            if new > 99 {
                // Wrap around: if we go past 99, subtract 100 to get back in range
                current = new - 100
            } else {
                current = new
            }
        } else if line[0] == 'L' {
            // Left rotation: subtract the value from current position
            new := current - value
            if new < 0 {
                // Wrap around: if we go below 0, add 100 to get back in range
                // (e.g., -5 becomes 95)
                current = 100 + new
            } else {
                current = new
            }
        }
        // Safety check: ensure our position is always within valid range 0-99
        if current < 0 || current > 99 {
            fmt.printfln("ERROR\ncurrent: %v\nvalue: %v", current, value)
            return
        }
        // Check if the dial now points to 0 after this rotation
        // If so, increment our counter (this is what we're ultimately counting)
        if current == 0 {
            counter += 1
        }
    }

    // Output the final answer: how many times the dial pointed to 0
    fmt.printfln("zero count: %v", counter)
}
