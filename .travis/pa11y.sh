#!/bin/bash

set -e
set -x

./bin/rails s &
RAILS_PID=$!

# Wait for the server to come online
while ! nc -z -w1 localhost 3000 > /dev/null; do
  sleep 1
done

pa11y --standard=Section508 --level=warning http://localhost:3000/caseflow/login

kill $RAILS_PID
