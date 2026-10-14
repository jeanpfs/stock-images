# Security

## Reporting a vulnerability

Report vulnerabilities privately through GitHub: **Security → Report a vulnerability** on this repository. Please do not open a public issue. I aim to acknowledge a report within 7 days and to follow up with a fix or an assessment within 30 days; this is a one-maintainer project, so these are targets, not guarantees.

## Supported versions

There are no tagged releases yet. Only the latest commit on `main` is supported; fixes land there.

## How API keys must be supplied

This skill uses personal API keys for Pexels, Unsplash and Pixabay.

- Keys are stored only in `~/.config/stock-images/keys.json`, created with `chmod 600` as described in [SETUP.md](SETUP.md).
- Keys must never be committed, pasted into issues or pull requests, added to `SKILL.md`/`README.md` examples, or printed in agent output. The skill instructs the agent never to display keys or full curl commands that contain them.
- `.gitignore` excludes `keys.json`, `.env` and `*.env`. Check `git status` before committing.
- Known limitation: Pixabay only accepts its key as a URL query parameter, so it can be visible in the process list (`ps`) while a request runs.
- If a key is exposed, revoke it at the provider and generate a new one immediately; removing it from git history is not enough.

## Scope worth reporting

- Instructions in `SKILL.md` that could make an agent leak a key, write the key file with loose permissions, or download from a domain outside the allowlist or over plain HTTP.
- Anything that causes keys to be committed or logged.
