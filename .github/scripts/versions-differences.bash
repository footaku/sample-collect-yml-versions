#!/usr/bin/env bash

set -eu

function diffVersions {
  declare -A before
  for line in ${1}
  do
    name=$(printf "${line}" | cut -d ',' -f 1)
    version=$(printf "${line}" | cut -d ',' -f 2)
    before[${name}]=${version}
  done

  declare -A after
  for line in ${2}
  do
    name=$(printf "${line}" | cut -d ',' -f 1)
    version=$(printf "${line}" | cut -d ',' -f 2)
    after[${name}]=${version}
  done

  for key in ${!before[@]}
  do
    printf "| ${key} | "
    if [[ "${before[${key}]}" != "${after[${key}]}" ]]; then
        printf "${before[${key}]} -> ${after[${key}]}"
    else
        printf "${after[${key}]}"
    fi
    printf " |  |\n"
  done | sort -k1
}

cat <<- EOL
| モジュール/OS | バージョン | 備考 |
| --- | --- | --- |
$(diffVersions "${1}" "${2}")
| iOS |  |  |
| Android |  |  |
EOL

exit 0
