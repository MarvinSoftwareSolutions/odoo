#!/bin/bash

set -o errexit
set -o nounset

scripts_dir="$(dirname "${0}")"
PROJECT_ROOT="$(dirname "$(readlink -f "${scripts_dir}")")"

DOWNLOADED_MODULES_PATH="${PROJECT_ROOT}/submodules"

cd "${DOWNLOADED_MODULES_PATH}"
git submodule add -b 16.0 git@github.com:OCA/reporting-engine.git
git submodule add -b 16.0 git@github.com/OCA/account-reconcile.git
git submodule add -b 16.0 git@github.com/OCA/bank-statement-import.git
git submodule add -b 16.0 git@github.com/OCA/helpdesk.git
git submodule add -b 16.0 git@github.com/OCA/vertical-association.git
git submodule add -b 16.0 git@github.com/a2systems/odoo-argentina.git
git submodule add -b 16.0 git@github.com/ingadhoc/account-financial-tools.git
git submodule add -b 16.0 git@github.com/ingadhoc/account-payment.git
git submodule add -b 16.0 git@github.com/odoomates/odooapps.git
git submodule add git@github.com:MarvinSoftwareSolutions/odoo-road-union.git

cd "${scripts_dir}"
