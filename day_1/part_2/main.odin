package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

// NOTE: Comments for day 1 are AI generated since I hadn't been writing comments
// while I was working on this problem.
// Advent of Code 2025 - Day 1 Part 2: Secret Entrance (Method 0x434C49434B)
//
// Problem: Same dial as Part 1, but now we count EVERY time the dial passes through 0
// during any rotation, not just when it ends at 0. This includes:
// 1. When the dial lands on 0 at the end of a rotation
// 2. When the dial passes through 0 while moving during a rotation
// 3. Multiple passes through 0 in a single large rotation (e.g., R1000 from position 50)
//
// Key insight: Large rotations (>100) will cause multiple complete circles,
// each passing through 0 once, plus potentially one more pass during the final partial rotation.

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
    // Counter to track TOTAL number of times the dial points to 0 (including during rotations)
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

        // KEY INSIGHT: For large rotations (>=100), we complete full circles
        // Each full circle (100 clicks) passes through 0 exactly once
        // So we add the number of complete circles to our counter first
        counter += (value / 100)
        // Reduce value to just the remainder after complete circles
        // This is the actual distance we need to simulate step by step
        value = value % 100

        // Debug output: show current position and the rotation being applied
        fmt.printfln("current:   %v", current)
        fmt.printfln("value:     %v%v", line[0] == 'R' ? "+" : "-", value)

        // Process the rotation based on direction (R = right/clockwise, L = left/counter-clockwise)
        if line[0] == 'R' {
            // Right rotation: add the value to current position
            new := current + value
            if new > 99 {
                // We wrapped around past 99, so we crossed through 0
                current = new - 100
                // Only count this crossing if we didn't land exactly on 0
                // (landing on 0 will be counted separately below)
                if current != 0 {
                    counter += 1
                }
            } else {
                // No wraparound, simple move
                current = new
            }
        } else if line[0] == 'L' {
            // Left rotation: subtract the value from current position
            new := current - value
            if new < 0 {
                // We wrapped around past 0, so we crossed through 0
                if current == 0 {
                    // Special case: if we started at 0, just wrap around
                    current = 100 + new
                } else {
                    // We crossed 0 during the rotation
                    current = 100 + new
                    // Only count this crossing if we didn't land exactly on 0
                    // (landing on 0 will be counted separately below)
                    if current != 0 {
                        counter += 1
                    }
                }

            } else {
                // No wraparound, simple move
                current = new
            }
        }
        // Safety check: ensure our position is always within valid range 0-99
        if current < 0 || current > 99 {
            fmt.printfln("ERROR\ncurrent: %v\nvalue: %v", current, value)
            return
        }
        // Check if the dial now points to 0 after this rotation
        // This counts the "landing on 0" case, separate from "passing through 0"
        if current == 0 {
            counter += 1
        }
    }

    // Output the final answer: total number of times the dial pointed to 0
    // (including both landings and passings-through)
    fmt.printfln("zero count: %v", counter)
}
