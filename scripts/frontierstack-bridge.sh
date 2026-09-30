#!/bin/sh
# Starts FrontierStack's local MCP server for Claude Code and Cowork on a Mac.
#
# The FrontierStack app writes its MCP bridge to the path below when MCP Server is turned on, and
# keeps it up to date. The bridge reads its own credential from the macOS Keychain, starts
# FrontierStack hidden if it isn't running, and connects to the app on this Mac only
# (http://127.0.0.1:8788/mcp) through the pinned mcp-remote package. No token is stored in this
# plugin or in Claude's settings. This script only checks that the bridge exists and hands over.
set -eu

bridge="$HOME/Library/Application Support/FrontierStack/mcp-bridge"

if [ ! -x "$bridge" ]; then
  echo "FrontierStack's local MCP bridge isn't installed on this computer." >&2
  echo "Install FrontierStack on this Mac from https://www.frontierstack.app and turn on MCP Server," >&2
  echo "then restart Claude. Elsewhere, use the frontierstack-cloud connector instead." >&2
  exit 78
fi

exec "$bridge"
