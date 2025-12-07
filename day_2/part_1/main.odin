package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

// NOTE: Comments for day 2 are AI generated since I hadn't been writing comments
// while I was working on this problem.
// Advent of Code 2025 Day 2 Part 1: Gift Shop
// Find invalid product IDs in ranges where an ID is invalid if it's made of
// some sequence of digits repeated exactly twice (e.g., 55, 6464, 123123)
main :: proc() {
    // Read the input file containing comma-separated ranges like "11-22,95-115,..."
    data, ok := os.read_entire_file("input.txt", context.allocator)
    if !ok {
        // could not read file
        return
    }
    defer delete(data, context.allocator)

    // Split the input by commas to get individual ranges like ["11-22", "95-115", ...]
    parts := strings.split(string(data), ",")

    // Keep track of the sum of all invalid product IDs found
    sum := 0

    // Process each range (e.g., "11-22")
    for part in parts {
        // Split each range by "-" to get start and end values
        range := strings.split(part, "-")
        lower, lower_ok := strconv.parse_int(range[0])  // Parse the lower bound
        upper, upper_ok := strconv.parse_int(range[1])  // Parse the upper bound
        // Check every number in the range (inclusive) for invalid IDs
        for value in lower..=upper {
            // Convert the number to a string so we can analyze its digits
            string_value := fmt.tprint(value)
            // Skip numbers with odd length - they can't be repeated sequences
            // (e.g., 123 can't be split into two equal parts)
            if len(string_value) % 2 != 0 {
                continue
            }
            // Split the string in half to check if both halves are identical
            middle := len(string_value) / 2
            first := string_value [:middle]   // First half of the digits
            second := string_value [middle:]  // Second half of the digits
            // If both halves are identical, this is an invalid ID (repeated pattern)
            // Examples: "55" -> "5" == "5", "6464" -> "64" == "64"
            if first == second {
                sum += value
            }
        }
    }

    // Print the total sum of all invalid product IDs found across all ranges
    fmt.println(sum)
}
