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
| `frontierstack-cloud` connection | Connects any Claude (web, desktop, mobile, Cowork, Claude Code) to your Macs through FrontierStack's gateway. Carries eight tools |

Claude Code and Cowork on the Mac that runs FrontierStack can also reach the app directly, with its
full tool catalog: use **Add to Claude Code** in FrontierStack's MCP Server pane. That connection
stays on your Mac and is set up by the app, not by this plugin.

## Set it up

1. Install FrontierStack on your Mac and add the servers, domains and routers you look after.
2. In FrontierStack, open **MCP Server**, turn it on, and turn on **ChatGPT access** (the one
   switch serves every cloud assistant, Claude included).
3. Connect **frontierstack-cloud** from the plugin's Connectors tab, or with `/mcp` in Claude
   Code, and sign in with your FrontierStack account. FrontierStack must be running on the Mac
   for requests to reach it.
4. Optional, for Claude Code or Cowork on that same Mac: **Add to Claude Code** in the MCP Server
   pane gives Claude the app's full tool catalog over a connection that never leaves the Mac.

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

- **The plugin runs nothing on your computer.** It contains the two skills and one remote
  connection; no scripts, programs or local servers.
- **Cloud connection.** Claude connects to `https://frontierstack.app/plugin/mcp`, run by
  Enfour, Inc. You sign in with your FrontierStack account (OAuth). Each request is relayed to
  a Mac on your account where ChatGPT access is on, and the result comes back the same way.
  Requests and results are encrypted at rest and erased once delivered. See the
  [plugin privacy policy](https://www.frontierstack.app/plugin/privacy.html) for what is
  processed and how long it is kept.
- The plugin has no hooks, collects no analytics, and asks for no API keys.

## Troubleshooting

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
