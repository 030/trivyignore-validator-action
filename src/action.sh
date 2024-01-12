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

inspectVulnerabilityExpiry() {
  echo "checking whether an expiry has been attached..."

  if ! echo ${1} | grep -qE "^[A-Z]+\-.*exp:[0-9]{4}(\-[0-9]{2}){2}$"; then
    echo "no expiry associated to: '${1}'. Add it by adding: 'exp:yyyy-mm-dd'"
    exit 1
  fi
}

inspectVulnerabilityExpiryMaxOneMonth() {
  echo "checking whether the expiry will take place in one month..."
  current=$(echo "${1}" | sed -e "s|^[A-Z]\{3,\}\-.*exp:\(.*\)|\1|g")
  if ! echo "${current}" | grep -qE "^[0-9]{4}(\-[0-9]{2}){2}$"; then
    echo "extracted date: ${current} is invalid"
    exit 1
  fi

  max=$(date +"%F" --date="$(date +%F) next month")

  if [ "${current}" \> "${max}" ]; then
    echo "current date: '${current}' in line: '${1}' exceeds"
    echo "the maximum date of one month. Choose a new date that is"
    echo "before: ${max}"
    exit 1
  fi
}

inspectVulnerabilityExpiryAndMaxOneMonth() {
  while read -r line; do
    if echo "${line}" | grep -qE "^[A-Z]+\-"; then
      echo "found a vulnerability entry in the ${filename}...";

      inspectVulnerabilityExpiry "${line}"
      inspectVulnerabilityExpiryMaxOneMonth "${line}"
    fi
  done < "${filename}"
}

main() {
  createEmptyDotTrivyignoreIfAbsent
  inspectVulnerabilityExpiryAndMaxOneMonth
}

main
