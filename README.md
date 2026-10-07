# C Programming Project 1

This project contains solutions for the four assignment questions. Each solution has its own folder with source code, a README, and evidence or design files.

## Assignments

1. [Water quality monitoring](assignments/water-quality-monitoring-system/README.md)
2. [Mobile money transactions](assignments/mobile-money-transaction-system/README.md)
3. [Delivery route analysis](assignments/delivery-route-analysis/README.md)
4. [Smart parking system](assignments/smart-parking-system/README.md)

See [assignment.md](assignment.md) for the full requirements and grading benchmarks.

## Testing

Run `powershell -ExecutionPolicy Bypass -File scripts/test-c-programs.ps1` to compile the C programs and check normal, boundary, and invalid inputs. It uses GCC when available, or the Android NDK and a running emulator when `ANDROID_HOME` is set. Temporary files are removed when it finishes.
