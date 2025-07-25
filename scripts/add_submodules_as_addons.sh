#!/bin/bash

set -o errexit
set -o nounset

# Functions ----------------------------------------------------------------------------------------
function create_destination_path {
  local DEST_PATH=${1}
  if [ ! -d "$DEST_PATH" ]; then
    echo "[INFO] Creating directory '$DEST_PATH'"
    if ! mkdir "${DEST_PATH}/deleteme"; then
      echo "[ERROR] Unable to create the '$DEST_PATH' destination path."
      return 1
    fi
  fi
}

function copy_submodule_into_addons_path {
  local origin_path="${1}"
  local destination_path="${2}"
  local excluded_files_file="${3}"
  rsync -ah \
        --exclude-from="${excluded_files_file}" \
        --include '*' \
        "${origin_path}/" "${destination_path}"
}

function prepare_extra_addons_requirements_file {
  local origin_path="${1}"
  local destination_path="${2}"

  local all_requirements_file_path="${destination_path}/requirements.txt"

  # Create empty requirements.txt file. Blank it if exists.
  touch "${all_requirements_file_path}"
  echo "" > "${all_requirements_file_path}"

  # Get all requirements.txt files in submodules
  find "${origin_path}" -type f -name "requirements.txt" -exec cat {} > "${all_requirements_file_path}" \;
  # find ./submodules/ -type f -name "requirements.txt" -exec file {} \;

  # Sort and delete repeated lines
  sort "${all_requirements_file_path}" | uniq > "${all_requirements_file_path}.sort"
  mv "${all_requirements_file_path}.sort" "${all_requirements_file_path}"

  return 0
}

# Execution ----------------------------------------------------------------------------------------
scripts_dir="$(dirname "${0}")"
PROJECT_ROOT="$(dirname "$(readlink -f "${scripts_dir}")")"

DOWNLOADED_MODULES_PATH="${PROJECT_ROOT}/submodules"
INSTALLED_MODULES_PATH="${PROJECT_ROOT}/extra-addons"
EXCLUDED_FILES_FILE="${scripts_dir}/exclude.txt"

declare -a submodule_names_list=(
  "account-financial-tools"
  "account-payment"
  "account-reconcile"
  "bank-statement-import"
  "helpdesk"
  "odoo-argentina"
  "odoo-argentina-ce"
  "odoo-road-union"
  "odoo-union"
  "odoo-vialidad-cordoba"
  "odooapps"
  "reporting-engine"
  "vertical-association"
)


if ! create_destination_path "${INSTALLED_MODULES_PATH}"; then
  echo "[ERROR] Failed to add extra-addons. Check logs for more info."
  exit 1
fi

if [ ! -f "${EXCLUDED_FILES_FILE}" ]; then
  echo "[ERROR] The exclusion file '${EXCLUDED_FILES_FILE}' does not exist."
  echo "[ERROR] Failed to add extra-addons. Check logs for more info."
  exit 1
fi

for submodule in "${submodule_names_list[@]}"; do

  submodule_path="${DOWNLOADED_MODULES_PATH}/${submodule}"
  if [ ! -d "${submodule_path}" ]; then
    echo "[ERROR] Directory '${submodule_path}' does not exist. Clone the repository including its submodules."
    echo "[ERROR] Failed to add extra-addons. Check logs for more info."
    exit 1
  fi

  if ! copy_submodule_into_addons_path "${submodule_path}" "${INSTALLED_MODULES_PATH}" "${EXCLUDED_FILES_FILE}"; then
    echo "[ERROR] Unable to copy '${submodule_path}' into '${INSTALLED_MODULES_PATH}'."
    echo "[ERROR] Failed to add extra-addons. Check logs for more info."
    exit 1
  fi

  echo "[INFO] Success: Module '${submodule_path}' into '${INSTALLED_MODULES_PATH}' copied correctly."

done

# prepare_extra_addons_requirements_file "${DOWNLOADED_MODULES_PATH}" "${PROJECT_ROOT}"

exit 0
