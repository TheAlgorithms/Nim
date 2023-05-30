#!/usr/bin/env bash

set -euo pipefail

find . -name "*.nim" -exec nimpretty {} +
