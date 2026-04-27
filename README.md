# stock-images

An Agent Skill for searching and downloading stock images from Pexels, Unsplash, and Pixabay.

Works with Claude Code, Codex, and other agents supported by the `npx skills` CLI.

## Features

- Search stock images across multiple providers simultaneously
- Download images directly to your project
- Smart orientation detection (hero → landscape, avatar → portrait)
- Secure API key storage (`~/.config/stock-images/keys.json` with `chmod 600`)
- Attribution reminders for TOS compliance

## Installation

```bash
npx skills@latest add jeanpfs/stock-images --all -y -g
```

Install for Claude Code only:

```bash
npx skills@latest add jeanpfs/stock-images --skill stock-images -a claude-code -g -y
```

Install for Codex only:

```bash
npx skills@latest add jeanpfs/stock-images --skill stock-images -a codex -g -y
```

## Setup

After installing, you need API keys from at least one provider (all free):

- **Pexels**: https://www.pexels.com/api/
- **Unsplash**: https://unsplash.com/developers
- **Pixabay**: https://pixabay.com/api/docs/

See [SETUP.md](SETUP.md) for detailed instructions.

## Usage Examples

- "Find stock photos of mountains for the hero section"
- "I need a professional headshot placeholder for this profile card"
- "Search for food photography on Unsplash"
- "Download image #3 to ./public/images"

## Security

- API keys stored with `chmod 600` (owner-only access)
- Keys never displayed in Claude's output
- Downloads restricted to known stock image provider domains
- HTTPS enforced on all connections
- File size validation on downloads

## License

MIT
