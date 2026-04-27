# Stock Images — Setup Guide

## Get API Keys

You need at least one API key. All three are free:

1. **Pexels**: Go to https://www.pexels.com/api/ → Sign up → Copy your API key
2. **Unsplash**: Go to https://unsplash.com/developers → Register app → Copy Access Key
3. **Pixabay**: Go to https://pixabay.com/api/docs/ → Sign up → Copy your API key

## Save Your Keys

Run this command to create the secure config file:

```bash
mkdir -p ~/.config/stock-images && cat > ~/.config/stock-images/keys.json << 'KEYS'
{
  "pexels": "YOUR_PEXELS_KEY",
  "unsplash": "YOUR_UNSPLASH_KEY",
  "pixabay": "YOUR_PIXABAY_KEY"
}
KEYS
chmod 600 ~/.config/stock-images/keys.json
```

Replace the placeholder values with your actual keys. Remove any providers you don't have.

## Verify Setup

```bash
test -f ~/.config/stock-images/keys.json && ls -la ~/.config/stock-images/keys.json
```

The file permissions should be `-rw-------` (owner read/write only). To verify the JSON is valid without printing your keys:

```bash
python3 -m json.tool ~/.config/stock-images/keys.json > /dev/null && echo "Config JSON is valid"
```
