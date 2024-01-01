setup() {
  filename=".trivyignore"
}

teardown() {
  echo "found filename: '${filename}'. Removing it..."
  rm "${filename}"
}

@test "create empty dot trivyignore if absent" {
  run ./src/action.sh
  [ "$status" -eq 0 ]
  regex=".*no ${filename} file found. Creating empty one.*"
  [[ "$output" =~ $regex ]]
}
