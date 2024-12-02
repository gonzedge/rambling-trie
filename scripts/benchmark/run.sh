#!/usr/bin/env bash

set -eo pipefail

version=latest
from_github=false

OPT_STRING="gv:"

while getopts ${OPT_STRING} opt; do
  case ${opt} in
    v) # override version
      version=${OPTARG}
      echo "version set to ${version}";;
    g) # use git commit
      from_github=true
      echo "from_github set to ${from_github}";;
  esac
done

echo "Building benchmark image for version=${version} and from_github=${from_github}"

image="rambling-trie:benchmark.${version}"
docker build . --file Dockerfile.benchmark \
  --build-arg VERSION=${version} \
  --build-arg FROM_GITHUB=${from_github} \
  --tag ${image} && \
  echo "Image ${image} built!"

echo "Running performance[benchmark] in ${image}"
docker run -it ${image} bash -c 'bundle exec rake performance[benchmark]' | tee "tmp/${version}.benchmark"
