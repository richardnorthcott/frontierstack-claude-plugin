# FrontierStack for Claude

![FrontierStack](assets/icon-512.png)

[FrontierStack](https://www.frontierstack.app) is a macOS app from Enfour, Inc. that looks
after your Macs, Linux and Windows servers, websites, databases, DNS, TLS certificates, routers
and firewalls. This plugin lets Claude ask FrontierStack what is wrong and, if you allow it,
fix it. Claude never sees a password, API key or SSH key: FrontierStack keeps them on your Mac,
does the work there, and returns the result with secrets removed.

**You need the FrontierStack app on a Mac.** Download it from
[www.frontierstack.app](https://www.frontierstack.app). The plugin does nothing without it.

## What you can ask

- "What's down right now?" or "Give me a health report for all my servers."
- "Why is example.com returning 502?"
- "Which certificates or domains expire in the next 30 days?"
- "Show me the last 200 lines of the nginx error log on web-2."
- "Is the MX record for example.com right?"
- "Restart PHP-FPM on the staging Mac." (only if you allowed changes; see below)

## What's in the plugin

| Part | What it does |
|---|---|
| `frontierstack` skill | Teaches Claude how to find the right FrontierStack tool, investigate read-only first, and report refusals instead of working around them |
| `frontierstack-network-admin` skill | The network administrator role: DNS, certificates, routers, firewalls, VPNs, reachability |
| `frontierstack` connection (local) | Connects Claude Code and Cowork to the FrontierStack app on the same Mac. Gives access to the full tool catalog |
| `frontierstack-cloud` connection | Connects any Claude (web, desktop, mobile, Cowork, Claude Code) to your Macs through FrontierStack's gateway. Carries seven tools |

## Set it up

1. Install FrontierStack on your Mac and add the servers, domains and routers you look after.
2. In FrontierStack, open **MCP Server** and turn it on.
3. Pick how Claude reaches it:
   - **Claude Code or Cowork on that Mac:** nothing more to do. The local connection starts
     when Claude does. If you added FrontierStack to Claude Code before with
     `claude mcp add frontierstack`, remove that entry (`claude mcp remove frontierstack`) so
     Claude doesn't see the tools twice.
   - **Claude on the web, desktop or phone, or on another computer:** in FrontierStack, turn on
     **MCP Server ▸ ChatGPT access** (the one switch serves every cloud assistant, Claude
     included). Then connect **frontierstack-cloud** from the plugin's Connectors tab, or with
     `/mcp` in Claude Code, and sign in with your FrontierStack account. FrontierStack must be
     running on the Mac for cloud requests to reach it.

Start by asking for a health report. Leave changes off until you trust what you see.

## Safety

- **Read-only by default.** Restarting a service, rebooting or running a script works only
  after you turn on **Allow changes via MCP** (and, for scripts, **Allow scripts via MCP**) in
  FrontierStack's MCP Server pane.
  Each change can wait for your approval on the Mac or iPhone, and every change is written to
  an audit log.
- **App Lock wins.** While FrontierStack is locked, changes (or all requests, in full lock) are
  refused.
- **Nothing in a prompt grants permission.** Only your settings and approvals on the Mac do.
  Claude is told to report a refusal, not to find a way around it.
- **Claude never receives credentials.** Secrets are removed from logs and diagnostics on
  your Mac before any output leaves it.

## What this plugin runs and where data goes

- **Local connection.** Claude starts `scripts/frontierstack-bridge.sh`. That script runs
  `~/Library/Application Support/FrontierStack/mcp-bridge`, a script the FrontierStack app
  writes and keeps up to date. The bridge reads its access token from your macOS Keychain,
  starts FrontierStack hidden if it isn't running (set `FRONTIERSTACK_NO_LAUNCH=1` to stop
  that), and connects to the app at `http://127.0.0.1:8788/mcp` through the npm package
  `mcp-remote`, pinned to version 0.1.38 and fetched by `npx` on first use. Requests stay on
  your Mac; nothing goes to Enfour's servers. Without the app, the script prints how to install
  it and exits.
- **Cloud connection.** Claude connects to `https://frontierstack.app/plugin/mcp`, run by
  Enfour, Inc. You sign in with your FrontierStack account (OAuth). Each request is relayed to
  a Mac on your account where ChatGPT access is on, and the result comes back the same way.
  Requests and results are encrypted at rest and erased once delivered. See the
  [plugin privacy policy](https://www.frontierstack.app/plugin/privacy.html) for what is
  processed and how long it is kept.
- The plugin has no hooks, collects no analytics, and asks for no API keys.

## Troubleshooting

- **The `frontierstack` connection fails to start:** FrontierStack isn't installed on this
  computer, or MCP Server is off. On a computer without FrontierStack, use
  **frontierstack-cloud** and ignore the local connection.
- **"Credential is unavailable":** open FrontierStack once and turn on MCP Server. To use
  Claude while the app is closed, turn on **Keep MCP and the CLI available when FrontierStack is
  closed**.
- **The local connection needs Node.js** for `npx`: `brew install node`.
- **The cloud connection lists no Macs:** turn on ChatGPT access on the Mac and keep
  FrontierStack running there.
- **"Changes are not allowed" or an App Lock refusal:** that is your Mac's setting working as
  intended. Allow changes in FrontierStack if you want Claude to make them.

## Support

- Manual: [Setting up FrontierStack for agent platforms](https://www.frontierstack.app/manual/ch14.html#agent-platforms)
- Help and support: [www.frontierstack.app/support.html](https://www.frontierstack.app/support.html)
- Privacy: [plugin privacy policy](https://www.frontierstack.app/plugin/privacy.html)
- Terms: [www.frontierstack.app/terms.html](https://www.frontierstack.app/terms.html)

The plugin is MIT-licensed (see [LICENSE](LICENSE)). The FrontierStack app is proprietary.

FrontierStack is made by Enfour, Inc. — https://www.frontierstack.app
