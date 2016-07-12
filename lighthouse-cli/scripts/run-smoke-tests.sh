#!/usr/bin/env bash

cd lighthouse-cli/test/fixtures && python -m SimpleHTTPServer 9999 &

NODE=$([ $(node -v | grep -E "v4") ] && echo "node --harmony" || echo "node")
offline200result="URL responds with a 200 when offline"

$NODE lighthouse-cli http://localhost:9999/online-only.html > results
if ! grep -q "$offline200result: false" results; then
  echo "Fail! online only site worked while offline"
  cat results
  exit 1
fi

sleep 5s


$NODE  lighthouse-cli https://www.moji-brush.com > results
if ! grep -q "$offline200result: true" results; then
  echo "Fail! offline ready site did not work while offline"
  cat results
  exit 1
fi
