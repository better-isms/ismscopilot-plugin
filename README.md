# ismscopilot-plugin

ISMS Copilot plugin package for the ChatGPT and Codex plugins directory, "With MCP"
submission type. Maintained by [Better ISMS](https://betterisms.co).

The package connects the [ISMS Copilot](https://ismscopilot.com) account MCP server
(`https://account.ismscopilot.com/v1/account/mcp`, Streamable HTTP, OAuth 2.1) so
compliance work can be delegated to the ISMS Copilot GRC specialist: framework
interpretation, policy drafting, control mapping, gap analysis, risk registers and
audit prep across ISO 27001/27701/42001, SOC 2, GDPR, NIS 2, DORA, EU AI Act, HIPAA
and PCI DSS.

## Structure

- `plugin.json`: root Agent Plugins manifest, carries `extensions.com.openai`
  (listing text, review information, publication notes).
- `.claude-plugin/plugin.json`: Claude-compatible manifest, same OpenAI extension.
- `mcp.json`: the account MCP server entry.
- `skills/get-started/SKILL.md`: onboarding skill.
- `assets/logo.png`: listing icon.

## Releases

Plugin repos in this org use merge-commit PRs to `main`. The directory ZIP is built
from merged `main` with `git archive`. Submission flow:
[`docs/runbooks/openai-plugins-directory-submission.md`](https://github.com/better-isms/founder-ops)
(founder-ops repo, internal).

## License

MIT. See [LICENSE](LICENSE).
