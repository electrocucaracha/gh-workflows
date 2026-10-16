#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2026
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit
set -o pipefail
if [[ ${DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

go_temp=""
trap 'if [[ -n "$go_temp" ]]; then rm -rf "$go_temp"; fi; make fmt' EXIT

if ! command -v go >/dev/null; then
    go_release="$(curl -fsSL https://go.dev/VERSION?m=text | sed -n '1s/^go//p')"
    if [[ ! ${go_release} =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Unable to determine a valid Go release." >&2
        exit 1
    fi
    go_archive="go${go_release}.linux-amd64.tar.gz"
    go_directory="${HOME}/.local/go-${go_release}"
    go_checksum="$(curl -fsSL "https://go.dev/dl/${go_archive}.sha256")"
    if [[ ! ${go_checksum} =~ ^[a-fA-F0-9]{64}$ ]]; then
        echo "The official Go release checksum is malformed." >&2
        exit 1
    fi
    go_temp="$(mktemp -d)"
    curl -fsSL "https://go.dev/dl/${go_archive}" -o "${go_temp}/${go_archive}"
    printf '%s  %s\n' "${go_checksum}" "${go_temp}/${go_archive}" | sha256sum --check --status
    mkdir -p "${go_directory}"
    tar -C "${go_directory}" --strip-components=1 -xzf "${go_temp}/${go_archive}"
    rm -rf "${go_temp}"
    go_temp=""
    export PATH="${go_directory}/bin:${PATH}"
fi

go_version="$(curl -fsSL https://go.dev/VERSION?m=text | sed -n '1s/^go//;s/\.[^.]*$//p')"
if [[ ! ${go_version} =~ ^[0-9]+\.[0-9]+$ ]]; then
    echo "Unable to determine a valid Go minor release." >&2
    exit 1
fi
find .github/workflows -type f \( -name '*.yml' -o -name '*.yaml' \) \
    -exec grep -l 'go-version:' {} + \
    -exec env go_version="${go_version}" bash -s {} + <<'EOF'
    for file; do
        sed -i \
            "s|^\([[:space:]]*go-version:[[:space:]]*\).*|\
\1\"^${go_version}\"|" \
            "${file}"
    done
EOF

if ! command -v uvx >/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
uvx pre-commit autoupdate
uv run --no-project --with git+https://github.com/electrocucaracha/gh-updater.git@2ed5822e66da4dfc35f5de1a56a2f6836556dc34 gh-updater .
uvx --refresh zizmor --offline --min-severity low .github/ --fix=all

# markdownlint runs as a local npx hook (avoids npm EALLOWGIT), which autoupdate skips.
markdownlint_version="$(npm view markdownlint-cli version)"
sed -i "s|npx --yes markdownlint-cli@[0-9.]*|npx --yes markdownlint-cli@${markdownlint_version}|" \
    .pre-commit-config.yaml
