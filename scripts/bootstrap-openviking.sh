#!/usr/bin/env bash
set -eou pipefail

#
# Setup the user in OpenViking
# Get users API key
#
# TODO: Make this script automatically inject the key into ./data/hermes-agent/.env

OPENVIKING_HERMES_ACCOUNT=default
OPENVIKING_HERMES_USER=default
OPENVIKING_HERMES_AGENT=hermes

CURRENT_KEY=$(
  docker run \
  --rm \
  --network ollama_isolated \
  -v ./data/openviking:/app/.openviking:ro \
  registry.poppet.io/ghcr/volcengine/openviking:v0.3.16 \
  ov admin list-users ${OPENVIKING_HERMES_ACCOUNT} | awk -v "agent=$OPENVIKING_HERMES_AGENT" '$1 == agent {print $3}'
)

if [ -z "$CURRENT_KEY" ]; then
  CURRENT_KEY=$(
    docker run \
    --rm \
    --network ollama_isolated \
    -v ./data/openviking:/app/.openviking:ro \
    registry.poppet.io/ghcr/volcengine/openviking:v0.3.16 \
    ov admin register-user --account ${OPENVIKING_HERMES_ACCOUNT} \
                           --user ${OPENVIKING_HERMES_USER} \
                           --agent-id ${OPENVIKING_HERMES_AGENT} \
                           ${OPENVIKING_HERMES_ACCOUNT} \
                           ${OPENVIKING_HERMES_AGENT} | awk '/user_key/ {print $2}'
  )
fi

echo "OpenViking key for Hermes: $CURRENT_KEY"
