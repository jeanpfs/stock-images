# Records the real Claude Code session behind assets/demo.gif (https://github.com/charmbracelet/vhs).
#
# Setup:
#   1. mkdir -p /tmp/demo-stock-images-proj/public/images && cd /tmp/demo-stock-images-proj
#      Add a small index.html (any landing page works), then:
#      npx skills@latest add jeanpfs/stock-images --skill stock-images -a claude-code -y
#   2. API keys at ~/.config/stock-images/keys.json (chmod 600, lowercase names as in SETUP.md:
#      {"pexels": "...", "unsplash": "...", "pixabay": "..."}). At least one provider is enough.
#      To keep your real HOME out of the recording, point HOME at a throwaway dir holding only that file:
#      export DEMO_HOME=/tmp/demo-stock-images-home   (mkdir -p $DEMO_HOME/.config/stock-images, copy keys.json)
#   3. A clean Claude Code config dir (no personal skills, hooks or status line) that has credentials and allows
#      what the skill runs: Skill, Bash(test:*), Bash(stat:*), Bash(python3:*), Bash(curl:*), Bash(ls:*),
#      Bash(mkdir:*), Bash(file:*), Read(//tmp/**). Point CLAUDE_CONFIG_DIR at it.
# Record from any directory:  vhs agent.tape   (writes session.mp4 in the current directory)
# Then:                       make-gif.sh      (needs hero.jpg copied from /tmp/demo-stock-images-proj/public/images/)
#
# The session is real and not deterministic: re-record until the agent loads the skill, searches, downloads a
# landscape image and reminds about the attribution, then set T_SHOW and the speed-ramp cuts in make-gif.sh.

Output "session.mp4"
Set Shell "bash"
Set FontSize 18
Set Width 940
Set Height 720
Set Padding 16
Set Theme "Catppuccin Mocha"
Set TypingSpeed 38ms

Hide
Type "cd /tmp/demo-stock-images-proj && export HOME=/tmp/demo-stock-images-home CLAUDE_CONFIG_DIR=/tmp/demo-stock-images-cc && PS1='$ ' && rm -f public/images/hero.jpg && clear" Enter
Show
Type "claude" Enter
Wait+Screen@30s /Try|\? for shortcuts|esc to interrupt|❯/
Sleep 2s
Type "Find a hero image of mountains at sunrise for the landing page, save the best one to public/images/hero.jpg and tell me the credit I need to add." Sleep 600ms Enter
Wait+Screen@240s /done at|done \d+:\d+/
Sleep 3s
