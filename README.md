# trivyignore-validator-action

Trivyignore Validator Action validates a .trivyignore file if it resides in a
repository.

## checks

- Expiry before next month, e.g.: if expiry 2024-06-06 on 2023-12-31, then an
  exit 1 will be thrown as the max allowed date would be: 2024-01-31.

## usage

Create a .github/workflows/trivyignore-validator.yml file:

```bash
---
name: Trivyignore-validator
"on": push
jobs:
  trivyignore-validator-action:
    runs-on: ubuntu-20.04
    steps:
      - uses: actions/checkout@v4.1.1
      - uses: 030/trivyignore-validator-action@v0.1.0
```

## unit tests

```bash
docker run -it -v "${PWD}:/code" --entrypoint=bash bats/bats:v1.10.0
apk add --no-cache coreutils
bats --tap test --print-output-on-failure
```
