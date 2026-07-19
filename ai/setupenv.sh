#!/usr/bin/env bash
# Create/activate the conda environment for the ai/ regression scripts.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/environment.yml"
ENV_NAME="regression-analysis"

if ! command -v conda >/dev/null 2>&1; then
  echo "conda was not found. Install Miniconda/Anaconda or load your course conda module first."
  exit 1
fi

if conda env list | awk '{print $1}' | grep -qx "${ENV_NAME}"; then
  echo "Environment '${ENV_NAME}' already exists."
else
  echo "Creating conda environment from ${ENV_FILE} ..."
  conda env create -f "${ENV_FILE}"
fi

echo
echo "Activate with:"
echo "  conda activate ${ENV_NAME}"
echo
echo "Then run (from this ai/ directory):"
echo "  python linear_model.py regression_data-1.csv YearsExperience Salary"
echo "  Rscript linear_model.R regression_data-1.csv YearsExperience Salary"
