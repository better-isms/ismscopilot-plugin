# ismscopilot-plugin

ISMS Copilot plugin package for the ChatGPT and Codex plugins directory ("With MCP"
submission type), Claude Code and Gemini CLI. Maintained by [Better ISMS](https://betterisms.co).

The package connects the [ISMS Copilot](https://ismscopilot.com) account MCP server
(`https://account.ismscopilot.com/v1/account/mcp`, Streamable HTTP, OAuth 2.1) so
compliance work can be delegated to the ISMS Copilot GRC specialist: framework
interpretation, policy drafting, control mapping, gap analysis, risk registers and
audit prep across ISO 27001/27701/42001, SOC 2, GDPR, NIS 2, DORA, EU AI Act, HIPAA
and PCI DSS.

## Install

The connection signs in to your ISMS Copilot account with OAuth 2.1 in your
browser. No API key or secret is stored in this repository or asked for.
More on the server: https://www.ismscopilot.com/mcp

### Gemini CLI

```bash
gemini extensions install https://github.com/better-isms/ismscopilot-plugin
```

Restart Gemini CLI, then run `/mcp auth ismscopilot` to sign in.
Gemini CLI extensions need a Gemini CLI install; Google moved unpaid and Google One
users to Antigravity CLI on 2026-06-18.
`gemini-extension.json` registers the `ismscopilot` MCP server (`httpUrl`,
Streamable HTTP) and loads `GEMINI.md` as context.

### Claude Code

```bash
claude plugin marketplace add better-isms/ismscopilot-plugin
claude plugin install ismscopilot@ismscopilot
```

Or from inside a session: `/plugin marketplace add better-isms/ismscopilot-plugin`,
then `/plugin install ismscopilot@ismscopilot`. Run `/mcp`, pick `ismscopilot`
and sign in. The plugin bundles the remote MCP server (`.mcp.json`, type `http`)
and the get started skill.

### What the connection sends

The MCP server is hosted by Better ISMS at
`https://account.ismscopilot.com/v1/account/mcp`. The package reads no local files
and runs no scripts or hooks. Whatever the agent puts into an ISMS Copilot tool
call (questions for the specialist, memories, company context, workspace and
document requests, including any excerpt it chooses to quote) is sent to the
server.

## Structure

- `plugin.json`: root Agent Plugins manifest, carries `extensions.com.openai`
  (listing text, review information, publication notes).
- `.claude-plugin/plugin.json`: Claude-compatible manifest, same OpenAI extension.
- `mcp.json`: the account MCP server entry (Agent Plugins format).
- `.mcp.json`: the same server for Claude Code (type `http`).
- `.claude-plugin/marketplace.json`: one-plugin Claude Code marketplace, so the
  repo installs with `claude plugin marketplace add`.
- `gemini-extension.json` and `GEMINI.md`: Gemini CLI extension manifest and its
  context file.
- `skills/get-started/SKILL.md`: onboarding skill.
- `assets/logo.png`: listing icon.

## Releases

Plugin repos in this org use merge-commit PRs to `main`. The directory ZIP is built
from merged `main` with `git archive`. Submission flow:
[`docs/runbooks/openai-plugins-directory-submission.md`](https://github.com/better-isms/founder-ops)
(founder-ops repo, internal).

## License

MIT. See [LICENSE](LICENSE).
