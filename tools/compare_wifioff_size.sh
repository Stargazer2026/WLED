#!/usr/bin/env bash
set -euo pipefail

ENV_ON="${1:-slwf09_eth_wifi_on}"
ENV_OFF="${2:-slwf09_eth_wifi_off}"

echo "==> Building $ENV_ON"
pio run -e "$ENV_ON"
echo "==> Building $ENV_OFF"
pio run -e "$ENV_OFF"

BIN_ON=".pio/build/${ENV_ON}/firmware.bin"
BIN_OFF=".pio/build/${ENV_OFF}/firmware.bin"

if [[ ! -f "$BIN_ON" || ! -f "$BIN_OFF" ]]; then
  echo "Binary missing. Expected:"
  echo "  $BIN_ON"
  echo "  $BIN_OFF"
  exit 2
fi

SIZE_ON=$(stat -c '%s' "$BIN_ON")
SIZE_OFF=$(stat -c '%s' "$BIN_OFF")
DELTA=$((SIZE_OFF - SIZE_ON))

echo
echo "Firmware binaries:"
echo "  WiFi ON : $BIN_ON"
echo "  WiFi OFF: $BIN_OFF"
echo
echo "Sizes (bytes):"
printf '  %-10s %12d\n' "WiFi ON" "$SIZE_ON"
printf '  %-10s %12d\n' "WiFi OFF" "$SIZE_OFF"
printf '  %-10s %12d\n' "Delta" "$DELTA"
echo

echo "SHA256:"
sha256sum "$BIN_ON" "$BIN_OFF"
