#!/usr/bin/env bash

readonly filename=".trivyignore"

createEmptyDotTrivyignoreIfAbsent() {
  if test -f "${filename}"; then
    echo "found a ${filename} file...";
    return
  fi

  echo "no ${filename} file found. Creating empty one..."
  touch "${filename}"
  exit 0
}

inspectCveExpiry() {
  echo "checking whether an expiry has been attached..."

  if ! echo ${1} | grep -qE "^CVE\-.*exp:[0-9]{4}(\-[0-9]{2}){2}$"; then
    echo "no expiry associated to: '${1}'. Add it by adding: 'exp:yyyy-mm-dd'"
    exit 1
  fi
}

inspectCveExpiryMaxOneMonth() {
  echo "checking whether the expiry will take place in one month..."
  current=$(echo "${1}" | sed -e "s|CVE\-.*exp:\(.*\)|\1|g")
  max=$(date +"%F" --date="$(date +%F) next month")

  if [[ "${current}" > "${max}" ]]; then
    echo "current date: '${current}' in line: '${1}' exceeds"
    echo "the maximum date of one month. Choose a new date that is"
    echo "before: ${max}"
    exit 1
  fi
}

inspectCveExpiryAndMaxOneMonth() {
  while read -r line; do
    if echo "${line}" | grep -qE "^CVE\-"; then
      echo "found a 'CVE-' entry in the ${filename}...";

      inspectCveExpiry "${line}"
      inspectCveExpiryMaxOneMonth "${line}"
    fi
  done < "${filename}"
}

main() {
  createEmptyDotTrivyignoreIfAbsent
  inspectCveExpiryAndMaxOneMonth
}

main
