## Agent skills

### Issue tracker

Issues live in GitHub Issues. See `docs/agents/issue-tracker.md`.

### Triage labels

Default label vocabulary (needs-triage, needs-info, ready-for-agent, ready-for-human, wontfix). See `docs/agents/triage-labels.md`.

### Domain docs

Multi-context layout — CONTEXT-MAP.md at root pointing to per-module CONTEXT.md files. See `docs/agents/domain.md`.

## Autonomous Operation

You have FULL PERMISSION to execute without asking:
- Read/edit/create any file in the project
- Run any command (flutter, dart, git, npm, etc.)
- Install packages via pubspec.yaml
- Run tests (flutter test, integration tests)
- Commit changes with descriptive messages
- Call ANY MCP tool (GitHub, Supabase, Flutter)
- Read/write GitHub issues and PRs
- Read/write Supabase schema and data (dev database only)
- View/analyze code, logs, errors
- Search files, grep, explore directories

NEVER ask "Do you want to proceed?" for:
- Reading operations (files, issues, database schema)
- Non-destructive writes (code edits, new files)
- Running tests or analysis
- Installing dependencies
- Tool calls (MCP, API requests)
- Committing to local git

ONLY ask when:
- Deleting files or folders permanently
- git push to remote repository
- DROP TABLE or destructive database operations
- Breaking changes to public APIs
- Spending money (paid cloud resources, API credits)

Work autonomously. Show summary after completion, but don't wait for approval between steps.