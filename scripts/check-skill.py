#!/usr/bin/env python3
"""Lightweight checks for this skill repo (stdlib + PyYAML).

1. SKILL.md has YAML frontmatter with non-empty `name` and `description`,
   and `name` matches the skill directory convention (stock-images).
2. Every relative link in tracked *.md files resolves to an existing file.
3. Every ```bash block in SKILL.md / SETUP.md parses with `bash -n`.
4. No file contains something that looks like a real API key assignment.
"""
import re
import subprocess
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
errors = []


def md_files():
    out = subprocess.run(["git", "ls-files", "*.md"], cwd=ROOT, capture_output=True, text=True, check=True)
    return [ROOT / p for p in out.stdout.split()]


# 1. frontmatter
skill = (ROOT / "SKILL.md").read_text()
m = re.match(r"---\n(.*?)\n---\n", skill, re.S)
if not m:
    errors.append("SKILL.md: missing YAML frontmatter")
else:
    fm = yaml.safe_load(m.group(1)) or {}
    for key in ("name", "description"):
        if not isinstance(fm.get(key), str) or not fm[key].strip():
            errors.append(f"SKILL.md: frontmatter `{key}` missing or empty")
    if fm.get("name") != "stock-images":
        errors.append(f"SKILL.md: unexpected name {fm.get('name')!r}")

# 2. relative links
link_re = re.compile(r"(?<!!)\[[^\]]*\]\(([^)\s]+)\)")
for f in md_files():
    text = re.sub(r"`[^`\n]+`", "", re.sub(r"```.*?```", "", f.read_text(), flags=re.S))
    for target in link_re.findall(text):
        if re.match(r"^(https?:|mailto:|#)", target):
            continue
        path = target.split("#")[0]
        if path and not (f.parent / path).exists():
            errors.append(f"{f.relative_to(ROOT)}: broken link {target}")

# 3. bash blocks
for name in ("SKILL.md", "SETUP.md"):
    text = (ROOT / name).read_text()
    for i, block in enumerate(re.findall(r"```bash\n(.*?)```", text, re.S), 1):
        r = subprocess.run(["bash", "-n"], input=block, text=True, capture_output=True)
        if r.returncode:
            errors.append(f"{name}: bash block {i} fails bash -n: {r.stderr.strip()}")

# 4. secret-looking assignments
secret_re = re.compile(r"""["']?(pexels|unsplash|pixabay)["']?\s*[:=]\s*["']([A-Za-z0-9_\-]{20,})["']""", re.I)
tracked = subprocess.run(["git", "ls-files"], cwd=ROOT, capture_output=True, text=True, check=True).stdout.split()
for p in tracked:
    fp = ROOT / p
    if fp.suffix in {".png", ".jpg"} or not fp.is_file():
        continue
    for hit in secret_re.finditer(fp.read_text(errors="ignore")):
        if not hit.group(2).upper().startswith("YOUR_"):
            errors.append(f"{p}: possible committed API key for {hit.group(1)}")

if errors:
    print("\n".join(errors))
    sys.exit(1)
print("ok")
