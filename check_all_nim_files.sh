#!/usr/bin/env bash

set -euo pipefail

find . -name "*.nim" -not -path "./scripts/*" -exec ./check_nim_file.sh {} +
