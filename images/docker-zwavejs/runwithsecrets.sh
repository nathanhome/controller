#!/bin/bash

# Read each line from the file and export it as an environment variable
# see https://raw.githubusercontent.com/zwave-js/zwave-js-ui/master/docs/guide/env-vars.md
# for available variables
while IFS= read -r line; do
  export "$line"
done < /run/secrets/zwgate_env_secret

exec "$@"