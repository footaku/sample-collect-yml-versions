#!/usr/bin/env bash

set -eu

function versions {
  local line=""
  while read -r file
  do
    local module_name=$(echo "${file}" | sed -r 's#\./\w+/([a-zA-Z0-9_\-]+)/.*#\1#g')
    local version="$(yq r ${file} 'app.version')"
    line=${line}${module_name},${version}" "
  done <<END
$(find . -type f -path '*/src/main/*' -name 'application.yml' \
| sort \
| grep -E "^./(ddd)")
END

  while read -r file
  do
    local module_name=$(echo "${file}" | sed -r 's#\./([a-zA-Z0-9_\-]+)/.*#\1#g')
    local version=$(yq r ${file} 'app.version')
    line=${line}${module_name},${version}" "
  done <<END
$(find . -type f -path '*/src/main/*' -name 'application.yml' \
| sort \
| grep -E -v "^./(ddd)")
END

  echo ${line}
}

versions

exit 0
