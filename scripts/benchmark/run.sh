#!/usr/bin/env bash

set -eo pipefail

from_github=false
no_cache=false
ruby_version=3.3.6
verbose=false
version=latest

OPT_STRING="gnv:V"

while getopts ${OPT_STRING} opt; do
  case ${opt} in
    v) # version, optionally with embedded ruby version: <trie_version>@<ruby_version>
      if [[ "${OPTARG}" == *@* ]]; then
        version="${OPTARG%@*}"
        ruby_version="${OPTARG#*@}"
      else
        version="${OPTARG}"
      fi
      echo "version set to ${version}"
      echo "ruby_version set to ${ruby_version}";;
    g) # use git ref instead of rubygems version
      from_github=true
      echo "from_github set to ${from_github}";;
    n) # skip docker layer cache
      no_cache=true
      echo "no_cache set to ${no_cache}";;
    V) # verbose docker build output
      verbose=true
      echo "verbose set to ${verbose}";;
  esac
done

docker_build_args=()
[[ "${no_cache}" == "true" ]] && docker_build_args+=(--no-cache)
[[ "${verbose}" == "true" ]] && docker_build_args+=(--progress=plain)

echo "Building benchmark image for version=${version}, ruby=${ruby_version}, from_github=${from_github}"

image="rambling-trie:benchmark.${version}.ruby-${ruby_version}"
docker build . --file Dockerfile.benchmark \
  --build-arg VERSION=${version} \
  --build-arg FROM_GITHUB=${from_github} \
  --build-arg RUBY_VERSION=${ruby_version} \
  --tag ${image} \
  "${docker_build_args[@]}" && \
  echo "Image ${image} built!"

output_file="tmp/${version}@${ruby_version}.benchmark"
echo "Running performance[benchmark] in ${image}"
docker run -it ${image} bash -c 'bundle exec rake performance[benchmark]' | tee "${output_file}"
echo "${output_file}"
