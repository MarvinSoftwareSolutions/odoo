#!/bin/bash

# set -o errexit
set -o nounset

odoo_version="${1}"

scripts_dir="$(dirname "${0}")"
PROJECT_ROOT="$(dirname "$(readlink -f "${scripts_dir}")")"

SUBMODULES_PATH="${PROJECT_ROOT}/submodules"

declare -a submodule_git_urls_list=(
  "git@github.com:MarvinSoftwareSolutions/odoo-road-union.git"
  "git@github.com:MarvinSoftwareSolutions/odoo-union.git"
  "git@github.com:MarvinSoftwareSolutions/odoo-vialidad-cordoba.git"
  "git@github.com:OCA/account-reconcile.git"
  "git@github.com:OCA/bank-statement-import.git"
  "git@github.com:OCA/helpdesk.git"
  "git@github.com:OCA/reporting-engine.git"
  "git@github.com:OCA/vertical-association.git"
  "git@github.com:ingadhoc/odoo-argentina.git"
  "git@github.com:ingadhoc/odoo-argentina-ce.git"
  "git@github.com:ingadhoc/account-financial-tools.git"
  "git@github.com:ingadhoc/account-payment.git"
  "git@github.com:odoomates/odooapps.git"
)

cd "${SUBMODULES_PATH}" || exit 1
for submodule_url in "${submodule_git_urls_list[@]}"; do
  if ! git submodule add -b "${odoo_version}" "${submodule_url}"; then
    continue
  fi
done
cd "${PROJECT_ROOT}" || exit 0

git submodule init
git submodule update --recursive
git submodule foreach "git checkout ${odoo_version}"
git submodule foreach "git pull"

exit 0
