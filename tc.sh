#!/bin/bash

set -e

# Get modified files, excluding test files
MODIFIED_FILES=$(git diff --name-only HEAD | rg --pcre2 '(?<!test|spec)\.(js|jsx|ts|tsx)')

if [ -z "$MODIFIED_FILES" ]; then
    echo "ℹ️  No modified source files found."
    exit 0
fi

# Run Jest with findRelatedTests option
yarn jest --findRelatedTests $MODIFIED_FILES

