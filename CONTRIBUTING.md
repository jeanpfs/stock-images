# Contributing

This repository is an Agent Skill: [`SKILL.md`](SKILL.md) holds the instructions the agent follows, [`SETUP.md`](SETUP.md) the user-facing key setup, and `scripts/check-skill.py` the checks CI runs. There is no build step.

## Before you open a pull request

1. Keep the change focused; one behavior or fix per PR.
2. Run the checks locally (needs Python 3 and PyYAML):

   ```bash
   python3 scripts/check-skill.py
   ```

   They verify that the `SKILL.md` frontmatter parses (`name`, `description`), that relative links in Markdown files resolve, that the `bash` code blocks in `SKILL.md` and `SETUP.md` pass `bash -n`, and that no real-looking API key is committed.
3. Use [Conventional Commits](https://www.conventionalcommits.org/) (`docs:`, `fix:`, `feat:`, `ci:`, `chore:`).
4. Update `CHANGELOG.md` under `Unreleased` if the change is user-visible.

## Rules for changes to the skill

- Never weaken the security rules in `SKILL.md` (no printing keys, HTTPS only, allowed provider domains only, size check on downloads).
- Keep attribution handling intact: the Unsplash and Pixabay terms require it, and Unsplash downloads must use `links.download`.
- Keep `SKILL.md` and `README.md` consistent when you change install commands, providers or behavior.
- Examples must use placeholders such as `YOUR_PEXELS_KEY`, never real keys.

## Never commit secrets

API keys live in `~/.config/stock-images/keys.json` (mode `600`), outside any repository. `.gitignore` already excludes `keys.json` and `.env` files. Do not paste keys, full curl commands containing keys, or screenshots that show them into issues, PRs or commits. See [SECURITY.md](SECURITY.md).

## Conduct

Participation is governed by the [Code of Conduct](CODE_OF_CONDUCT.md).
