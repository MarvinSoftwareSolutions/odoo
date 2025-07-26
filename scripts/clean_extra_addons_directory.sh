#!/bin/bash

set -o errexit
set -o nounset

# Functions ----------------------------------------------------------------------------------------
function remove_addons_from_extra_addons_path {
  local extra_addons_path="${1}"
  rm -rf "${extra_addons_path}/"*"/" # noqa SC2115
}

# Execution ----------------------------------------------------------------------------------------
scripts_dir="$(dirname "${0}")"
PROJECT_ROOT="$(dirname "$(readlink -f "${scripts_dir}")")"

INSTALLED_MODULES_PATH="${PROJECT_ROOT}/extra-addons"


if ! remove_addons_from_extra_addons_path "${INSTALLED_MODULES_PATH}"; then
  echo "[ERROR] Failed to add extra-addons. Check logs for more info."
  exit 1
fi

exit 0
