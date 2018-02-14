#!/bin/bash

# API : url_encode (tooling)

function url_encode {
  # url_encode <string>
  old_lc_collate=$LC_COLLATE
  LC_COLLATE=C

  local length="${#1}"
  for (( i = 0; i < length; i++ )); do
    local c="${1:i:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf "%s" "$c" ;;
      *) printf '%%%02X' "'$c" ;;
    esac
  done

  LC_COLLATE=$old_lc_collate
}

# API : ensure_boolean (tooling)

function ensure_boolean {
  local value=$1

  case "${value}" in
    'true'|'false')
      ;;
    *)
      echo "Expect 'true' or 'false' found : '${value}'" >&2
      exit 1
      ;;
  esac
}

# API : ensure_not_empty (tooling)

function ensure_not_empty {
  local value=$1
  local message_if_empty=$2

  if [ -z "${value}" ] ; then
    echo "*** Missing value for: '${message_if_empty}'" >&2
    exit 1
  fi
}

# API :

function source_files {
  for file in $1/* ; do
    source "${file}"
  done
}

# API :

function compactJSON {
  local json=$1

  echo "${json}" | jq -c '.'
}
