#!/bin/bash

source "${BITBUCKET_BASH_API_PATH}/api/tools_api.sh"

function bb_get {
  local api_url="$1"
  local api_params="$2"

  curl -X GET \
   --user "${BITBUCKET_API_USER}:${BITBUCKET_API_PASSWORD}" \
   -H "X-Atlassian-Token: no-check" \
   --silent \
   "${BITBUCKET_API_URL_PREFIX}${api_url}?limit=1000&${api_params}"
  local curl_rc=$?

  echo "bbGet: ${api_url} - curl_rc=${curl_rc}" >&2
}

function bb_post {
  local api_url="$1"
  local api_params="$2"
  local json="$3"
  local curl_rc

  if [ -z "${json}" ]; then
    curl -X POST \
      --user "${BITBUCKET_API_USER}:${BITBUCKET_API_PASSWORD}" \
      -H "X-Atlassian-Token: no-check" \
     --silent \
     "${BITBUCKET_API_URL_PREFIX}${api_url}?limit=1000&${api_params}"
    curl_rc=$?
  else
    curl -X POST \
      --user "${BITBUCKET_API_USER}:${BITBUCKET_API_PASSWORD}" \
      -H "X-Atlassian-Token: no-check" \
      -H "Content-Type: application/json" \
      -d "${json}" \
      --silent \
      "${BITBUCKET_API_URL_PREFIX}${api_url}?limit=1000&${api_params}" | jq . | >&2
    curl_rc=$?
  fi

  echo "bbPost: ${api_url} - curl_rc=${curl_rc}" >&2
}

function bb_create_user {
  local name=$1
  local password=$2
  local displayName=$3
  local emailAddress=$4
  local addToDefaultGroup=$5
  local notify=$6

  name=$(url_encode "${name}")
  password=$(url_encode "${password}")
  displayName=$(url_encode "${displayName}")
  emailAddress=$(url_encode "${emailAddress}")

  #ensure_not_empty "${name}" 'name' || exit 1
  ensure_boolean "${addToDefaultGroup}" || exit 1
  ensure_boolean "${notify}" || exit 1

  local api_params=

  api_params+="name=${name}&"
  api_params+="password=${password}&"
  api_params+="displayName=${displayName}&"
  api_params+="emailAddress=${emailAddress}&"
  api_params+="addToDefaultGroup=${addToDefaultGroup}&"
  api_params+="notify=${notify}"

  bb_post '/rest/api/1.0/admin/users' "${api_params}"
}

function bb_create_group {
  local name=$1

  name=$(url_encode "${name}")

  local api_params=

  api_params+="name=${name}&"

  bb_post '/rest/api/1.0/admin/groups' "${api_params}"
}

function bb_create_project {
  local key=$1
  local name=$2
  local description=$3

  local json

  json=$(
  compactJSON "{
   \"key\": \"${key}\",
   \"name\": \"${name}\",
    \"description\": \"${description}\"
}"
  ) || exit 1

  bb_post '/rest/api/1.0/projects' '' "${json}"
}

function bb_create_repo {
  local projectKey=$1
  local name=$2

  ensure_not_empty "${projectKey}" 'projectKey'

  local json

  json=$(
  compactJSON "{
   \"name\": \"${name}\",
   \"scmId\": \"git\",
    \"forkable\": true
}"
  ) || exit 1

  bb_post "/rest/api/1.0/projects/{projectKey}/repos" '' "${json}"
}

function jq_is_required {
  which jq >/dev/null
  if [ $? -ne 0 ]; then
    echo 'jq command is missing. Please install it.
  sudo apt install jq
or
  sudo yum install jq
' >&2
    exit 1
 fi
}

jq_is_required || exit 1
#
# Load configuration
#
#source_files "${BITBUCKET_BASH_API_PATH}/config"

if [ -d "${BITBUCKET_BASH_API_PATH}/my-config" ]; then
  source_files "${BITBUCKET_BASH_API_PATH}/my-config"
fi

if [ ! -z "$BITBUCKET_BASH_API_CONFIG" ]; then
  if [ ! -d "${BITBUCKET_BASH_API_CONFIG}" ]; then
    echo "BITBUCKET_BASH_API_CONFIG=${BITBUCKET_BASH_API_CONFIG} - Folder not found." >&2
    exit 1
  fi

  source_files "${BITBUCKET_BASH_API_CONFIG}"
fi

#
# Check configuration
#
if [ -z "${BITBUCKET_API_USER}" ]; then
  echo "BITBUCKET_API_USER is missing." >&2
  exit 1
fi

  if [ -z "${BITBUCKET_API_PASSWORD}" ]; then
  echo "BITBUCKET_API_PASSWORD is missing." >&2
  exit 1
fi

if [ -z "${BITBUCKET_API_URL_PREFIX}" ]; then
  echo "BITBUCKET_API_URL_PREFIX is missing." >&2
  exit 1
fi
