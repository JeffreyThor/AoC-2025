package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

// NOTE: Comments for day 2 are AI generated since I hadn't been writing comments
// while I was working on this problem.
// Advent of Code 2025 Day 2 Part 2: Gift Shop (Extended Rules)
// Find invalid product IDs in ranges where an ID is invalid if it's made of
// some sequence of digits repeated AT LEAST twice (not just exactly twice)
// Examples: 123123 (123 twice), 123123123 (123 three times), 1212121212 (12 five times)
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
            // Convert the number to a string so we can analyze its digit patterns
            string_value := fmt.tprint(value)
            // Try all possible numbers of repetitions from 2 to the full length
            // i = number of times the pattern should repeat
            // Example: for "123123", we try i=2 (pattern repeats 2 times), i=3, etc.
            for i in 2..=len(string_value) {
                // Skip if the string length isn't divisible by the number of repetitions
                // (can't have fractional patterns)
                if len(string_value) % i != 0 {
                    continue
                }
                // Calculate the size of each repeating chunk
                // Example: "123123" with i=2 repetitions → chunk_size = 6/2 = 3
                chunk_size := len(string_value) / i
                // Extract the first chunk as our pattern to match against
                chunk := string_value[:chunk_size]
                // Flag to track if we found a valid repeating pattern
                repeating := false
                // Check if all subsequent chunks match the first chunk
                // Start from the second chunk and step by chunk_size
                for index := chunk_size; index < len(string_value); index+= chunk_size {
                    // Extract the current chunk and compare with the first chunk
                    if chunk != string_value[index:index+chunk_size] {
                        // If any chunk doesn't match, this pattern doesn't work
                        repeating = false
                        break
                    } else {
                        // This chunk matches, continue checking
                        repeating = true
                    }
                }
                // If we found a valid repeating pattern, add to sum and stop checking
                // other pattern lengths for this number (avoid double counting)
                if repeating == true {
                    sum += value
                    break
                }
            }
        }
    }

    // Print the total sum of all invalid product IDs found across all ranges
    fmt.println(sum)
}
