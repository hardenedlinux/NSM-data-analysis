#!/usr/bin/env bash
set -euo pipefail

mach-nix env ./timesketch -r timesketch.txt
mach-nix env ./voila -r voila.txt
