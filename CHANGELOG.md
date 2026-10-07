# Changelog

## 0.1.2

Pre-submission audit against the OpenAI plugin guidelines (2026-10-07):

- Subtitle "Compliance and GRC specialist" (states the purpose for the
  Security category; drops "your agent", which could read as a
  reference to another AI assistant).
- Long description: restricted-data line (no health records, card data
  or government IDs), not-legal-advice line, credit-purchase wording
  removed from the listing (commerce stays declared false).
- Support URL points to the public contact-support page.
- composerIcon added (required in the Codex-format manifest the portal
  derives).
- Review case P1 now reads the company profile (get_company_context)
  instead of the plan, so no plan, upgrade link or account identifier
  appears in review output. P2 and P3 name get_reply as conditional.
- Onboarding skill: writes only on user request; sensitive data and
  not-legal-advice guidance.

## 0.1.1

Category corrected to Security (the ChatGPT plugins directory category list
confirmed from the live directory: Security is the category for information
security compliance work; Productivity could not be confirmed by the portal
check). Version bump to 0.1.1. No other listing text change.

## 0.1.0

Initial plugin package for the ChatGPT and Codex plugins directory,
"With MCP" type. Connects the ISMS Copilot account MCP server
(https://account.ismscopilot.com/v1/account/mcp, Streamable HTTP, OAuth
2.1). Listing metadata under extensions.com.openai in both the root
Agent Plugins manifest and .claude-plugin/plugin.json: displayName and
subtitle within the 30-character limits, no pricing in the description,
no references to other AI assistants, four listing URLs, starter
prompts, five positive and three negative review cases, and the get
started onboarding skill. API key and credit purchases are not part of
the connected tool set, and commerce is declared false.
