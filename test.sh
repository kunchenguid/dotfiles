#!/usr/bin/env bash
# Discover and run all tests in tests/*.test.sh, report pass/fail summary.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

passed=0
failed=0
skipped=0
failed_tests=()

for test_file in tests/*.test.sh; do
  [ -e "$test_file" ] || continue

  test_name=$(basename "$test_file")

  # Capture both stdout and stderr, track exit code
  output=$(bash "$test_file" 2>&1)
  exit_code=$?

  # Check for skip indicator (output contains "skip: ")
  if echo "$output" | grep -q "^skip: "; then
    ((skipped++))
    echo "$test_name - SKIP"
  elif [ $exit_code -eq 0 ]; then
    ((passed++))
    echo "$test_name - PASS"
  else
    ((failed++))
    failed_tests+=("$test_name")
    echo "$test_name - FAIL"
    # Show first error line for context
    echo "$output" | grep "^not ok" | head -1 | sed 's/^/  /'
  fi
done

echo
echo "Summary: $passed passed, $failed failed, $skipped skipped"

if [ $failed -gt 0 ]; then
  echo "Failed tests: ${failed_tests[*]}"
  exit 1
fi

exit 0
