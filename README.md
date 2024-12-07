# AOC2024
Advent of Code 2024

- Each day is a separate executable package.
- An `Input` file (no ext) is expected alongisde `main.swift` in the `Sources` directory. (The `Input` file is not checked in to git, see AOC best practices as to why)
- To run:
  - in the terminal:
    - at the root dir, run `swift run --package-path DayN -c release DayN` where N is the day of the month.
    - OR `swift run -c release DayN` in the day's dir.
  - in Xcode:
    - at the root dir, run `open DayN/package.swift`, then `cmd-R` in Xcode.
