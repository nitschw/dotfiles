# Raycast Script Commands

These scripts integrate with Raycast to provide quick actions from the launcher.

## Setup

1. Open Raycast preferences (`Cmd+,` in Raycast)
2. Go to Extensions → Script Commands
3. Click "Add Script Directory"
4. Select `~/.config/raycast/scripts`
5. The scripts will automatically appear in Raycast

## Available Scripts

| Script | Description | Usage |
|--------|-------------|-------|
| Kill Process | Kill process by name | Type name, kills all matches |
| Copy PID | Copy PID to clipboard | Type name, copies first match |
| List Processes | Show top processes | Optional filter |
| Force Kill App | Force quit macOS app | Type app name |
| IP Addresses | Show local/public IP | No args |
| Flush DNS | Flush DNS cache | Needs sudo |
| Port Check | What's on a port | Optional port number |
| Docker Cleanup | Prune Docker resources | Confirmation required |
| Git Status All | Status of all repos | Optional parent dir |

## Writing Your Own Scripts

Raycast scripts use special comments to configure behavior:

```bash
#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title My Script
# @raycast.mode compact          # compact (one line), fullOutput, or silent
# @raycast.packageName Category

# @raycast.icon 🔧
# @raycast.argument1 { "type": "text", "placeholder": "arg name", "optional": true }
# @raycast.needsConfirmation true  # Ask before running

# Your script here
echo "Hello from Raycast!"
```

### Modes

- `compact` - Shows one line of output
- `fullOutput` - Shows all output in a panel
- `silent` - No output (just runs)

### Tips

- Use `pbcopy` to copy to clipboard
- Use `open` to open apps/URLs
- Scripts can be bash, python, ruby, node, etc.
- Use `osascript` for AppleScript integration

## Quick Add

To create a new script:

```bash
cd ~/.config/raycast/scripts
cat > my-script.sh << 'EOF'
#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title My Script
# @raycast.mode compact
# @raycast.icon ⚡

echo "It works!"
EOF
chmod +x my-script.sh
```

Then refresh Script Commands in Raycast.
