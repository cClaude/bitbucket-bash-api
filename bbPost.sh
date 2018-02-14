#!/bin/bash

function display_usage {
  echo "Usage: $0
    $0 --uri BB_URI --params 'PARAM1=VALUE1&PARAM2=VALUE2
    $0 --uri BB_URI --json '{ \"attrib1\": \"value1\", \"attrib2\": \"value2\" }'
" >&2
  exit 100
}

function main {
  local api_url=
  local api_params=
  local json=

  while [[ $# -gt 0 ]]; do
    local param="$1"
    shift

    case "${param}" in
    '--uri'|'--url'|'-u')
      api_url="$1"
      shift
      ;;
    '--params'|'-p')
      api_params="$1"
      shift
      ;;
    '--json'|'-j')
      json="$1"
      shift
      ;;
    *)
      # unknown option
      echo "Undefine parameter ${param}" >&2
      display_usage
      ;;
    esac
  done

  if [ -z "${api_url}" ] ; then
    echo "** Missing parameter --uri" >&2
    display_usage
  fi

  if [ -z "${api_params}${json}" ] ; then
    echo "** At least on parameter in --params --json should be define." >&2
    display_usage
  fi

  bb_post "${api_url}" "${api_params}" "${json}"
}

# Configuration - BEGIN
if [ -z "${BITBUCKET_BASH_API_PATH}" ]; then
  BITBUCKET_BASH_API_PATH=$(dirname "$(realpath "$0")")
fi

if [ ! -f "${BITBUCKET_BASH_API_PATH}/api/bitbucket_bash_api.sh" ]; then
  echo 'bitbucket_bash_api.sh not found! - Please set BITBUCKET_BASH_API_PATH' >&2
  exit 1
fi

source "${BITBUCKET_BASH_API_PATH}/api/bitbucket_bash_api.sh"
# Configuration - END

# Script start here

if [ $# -eq 0 ]; then
  display_usage
fi

main "$@"
