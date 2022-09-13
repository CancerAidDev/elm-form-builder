#!/bin/bash

COVERAGE_THRESHOLD=$1
COVERAGE_DIR="./.coverage"

TESTSTR=$(yarn elm-coverage ./src)
rm -r $COVERAGE_DIR
echo "$TESTSTR"

case "$TESTSTR" in
*"TEST RUN PASSED"*)
    TOTAL=$(echo $TESTSTR | sed -E 's/(.*)│(.*)/\2/')
    PASSEDRATIO=$(echo $TOTAL | sed -E 's/(.*)\((.*)/\1/')
    NUM_PASSES=$(echo $PASSEDRATIO | sed -E 's/(.*)\/(.*)/\1/')
    NUM_TESTS=$(echo $PASSEDRATIO | sed -E 's/(.*)\/(.*)/\2/')
    NUM_PASSES_REQUIRED=$(($NUM_TESTS * $COVERAGE_THRESHOLD / 100))
    PASS_PERCENTAGE=$(($NUM_PASSES * 100 / $NUM_TESTS))

    if [ "$NUM_PASSES" -lt "$NUM_PASSES_REQUIRED" ]; then
        echo "Coverage is below threshold of $COVERAGE_THRESHOLD%. Required passes: $NUM_PASSES_REQUIRED, actual passes: $NUM_PASSES ($PASS_PERCENTAGE%)"
        exit 1
    else
        exit 0
    fi
    ;;
esac

exit 1
