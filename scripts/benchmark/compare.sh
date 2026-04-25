#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  echo "Usage: $0 [-g] <version1> <version2>"
  echo ""
  echo "Each version may optionally embed a ruby version as <trie_version>@<ruby_version>."
  echo "If omitted, ruby defaults to 3.3.6."
  echo ""
  echo "Options:"
  echo "  -g   treat versions as git refs (passed to run.sh -g)"
  echo ""
  echo "Examples:"
  echo "  # two trie versions, same ruby"
  echo "  $0 2.6.0 2.6.1"
  echo "  $0 -g abc1234 def5678"
  echo ""
  echo "  # same trie version, two ruby versions"
  echo "  $0 2.6.0@3.3.6 2.6.0@3.4.0"
  echo "  $0 -g abc1234@3.3.6 abc1234@3.4.0"
  echo ""
  echo "  # mix: different versions and different rubies"
  echo "  $0 -g abc1234@3.3.6 def5678@3.4.0"
  exit 1
}

git_flag=""

OPT_STRING="g"

while getopts ${OPT_STRING} opt; do
  case ${opt} in
    g)
      git_flag="-g";;
  esac
done

shift $((OPTIND - 1))

if [ $# -ne 2 ]; then
  usage
fi

spec1=$1
spec2=$2

# Parse <version>@<ruby_version> or just <version>
if [[ "${spec1}" == *@* ]]; then
  version1="${spec1%@*}"
  ruby1="${spec1#*@}"
else
  version1="${spec1}"
  ruby1="3.3.6"
fi

if [[ "${spec2}" == *@* ]]; then
  version2="${spec2%@*}"
  ruby2="${spec2#*@}"
else
  version2="${spec2}"
  ruby2="3.3.6"
fi

echo "==> Running benchmark for ${version1} (ruby ${ruby1})"
file1=$(bash "${SCRIPT_DIR}/run.sh" ${git_flag} -v "${version1}@${ruby1}" | tail -1)

echo ""
echo "==> Running benchmark for ${version2} (ruby ${ruby2})"
file2=$(bash "${SCRIPT_DIR}/run.sh" ${git_flag} -v "${version2}@${ruby2}" | tail -1)

echo ""
echo "==> Diff: ${spec1} vs ${spec2}"
output_file="tmp/${version1}@${ruby1}-vs-${version2}@${ruby2}.benchmark.diff"
diff "${file1}" "${file2}" | tee "${output_file}"
echo "${output_file}"
