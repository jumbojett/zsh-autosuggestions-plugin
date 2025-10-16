# ZSH Auto-Suggestions

🐟 Fish-style auto-suggestions for Zsh with history cycling support!

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

✨ **Real-time suggestions** - See command suggestions in gray text as you type  
🔄 **Cycle through options** - Use ↑/↓ arrows to browse through matching commands  
⚡ **Fast and native** - Built with pure zsh, no external dependencies  
🎨 **Customizable** - Easy to configure colors and behavior  
🔍 **Smart history search** - Searches through your entire command history  

## Quick Start

### Option 1: Load Temporarily (Test First)

Test the plugin without making permanent changes:

```bash
source ./zsh-autosuggestions.zsh
```

This will load the plugin for your current session only. Try typing some commands and you should see gray suggestions appear!

## Installation

### Option 1: Clone the repository

```bash
git clone https://github.com/jumbojett/zsh-autosuggestions-plugin.git ~/.zsh/zsh-autosuggestions
```

Then add to your `~/.zshrc`:

```bash
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
```

Then reload your shell:

```bash
source ~/.zshrc
```

### Option 2: Direct download

```bash
# Download the plugin
curl -o ~/.zsh/zsh-autosuggestions.zsh https://raw.githubusercontent.com/jumbojett/zsh-autosuggestions-plugin/main/zsh-autosuggestions.zsh

# Add to your ~/.zshrc
echo 'source ~/.zsh/zsh-autosuggestions.zsh' >> ~/.zshrc

# Reload shell
source ~/.zshrc
```

### Option 3: Install to Standard Plugin Location

For a cleaner setup, move the plugin to your zsh plugins directory:

```bash
# Create plugins directory if it doesn't exist
mkdir -p ~/.zsh/plugins

# Copy the plugin
cp ./zsh-autosuggestions.zsh ~/.zsh/plugins/

# Add to ~/.zshrc
echo 'source ~/.zsh/plugins/zsh-autosuggestions.zsh' >> ~/.zshrc

# Reload shell
source ~/.zshrc
```

## Usage

### Auto-Suggestions

- **As you type**: See suggestions in gray text automatically
- **From history**: Suggestions come from your zsh command history
- **Smart matching**: Only shows commands that start with what you've typed

### Accepting Suggestions

- **→ (Right Arrow)**: Accept entire suggestion when cursor is at end of line
- **End Key**: Accept entire suggestion
- **Ctrl+→**: Accept one word at a time
- **Tab**: Normal tab completion (unchanged)

### Cycling Through Suggestions

- **↑ (Up Arrow)**: When cursor is at end of line with text, cycle to older suggestions
- **↓ (Down Arrow)**: Cycle to newer suggestions
- **↑↓ with empty line**: Normal history navigation (unchanged)

## Usage Examples

1. **Type a common command:**
   ```
   $ gi█
   ```
   You might see: `git status` in gray

2. **Press → to accept:**
   ```
   $ git status█
   ```

3. **Or press ↑ to see other suggestions:**
   ```
   $ git push█  (or git pull, git commit, etc.)
   ```

4. **Accept word-by-word with Ctrl+→:**
   ```
   $ git█  →  $ git status█  →  $ git status --short█
   ```

## Customization

Edit the configuration section in `zsh-autosuggestions.zsh`:

```bash
# Change suggestion color (currently gray)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'     # Try: fg=240, fg=244, etc.

# Maximum number of suggestions to cache
# (currently set to 10, increase for more cycling options)
# Change this number in the _zsh_autosuggest_fetch_suggestion function
```

### Available Colors

Try different gray shades by changing `fg=8`:

- `fg=8` - Default gray
- `fg=240` - Darker gray
- `fg=244` - Medium gray  
- `fg=248` - Lighter gray
- `fg=cyan,dim` - Dimmed cyan
- `fg=blue,dim` - Dimmed blue

## Compatibility

- **Zsh**: 5.0 or higher
- **macOS**: ✅ Fully tested
- **Linux**: ✅ Should work
- **Windows (WSL)**: ✅ Should work

Works with:
- Oh My Zsh
- Prezto
- Plain zsh

## Troubleshooting

### Suggestions not appearing?

1. Check your history exists:
   ```bash
   history | head
   ```

2. Try typing a command you've used before

3. Look for the success message when loading:
   ```
   ✓ ZSH Auto-Suggestions loaded
   ```

### Conflicts with other plugins?

Load this plugin **after** other plugins in your `~/.zshrc`:

```bash
source ~/.oh-my-zsh/oh-my-zsh.sh  # Load framework first
# ... other plugins ...
source ~/.zsh/zsh-autosuggestions.zsh  # Load this last
```

### Arrow keys not working?

The plugin preserves normal arrow key behavior:
- ↑↓ with **empty line** = normal history navigation
- ↑↓ with **text at end** = cycle through suggestions
- ←→ = normal cursor movement + accept suggestion when at end (new)

## Uninstalling

Remove the source line from your `~/.zshrc`:

```bash
# Comment out or delete this line:
# source ~/.zsh/plugins/zsh-autosuggestions.zsh
```

Then reload:

```bash
source ~/.zshrc
```

## Comparison with suggest.sh

| Feature | suggest.sh (Proof of Concept) | zsh-autosuggestions.zsh (Real Integration) |
|---------|-------------------------------|-------------------------------------------|
| Shell Integration | Separate pseudo-shell | Native zsh integration |
| History | Reads history files | Uses zsh's built-in history |
| Performance | Good | Excellent (native zle) |
| Compatibility | Works in any shell | zsh only |
| Key Bindings | Custom handlers | Native zsh bindings |
| Use Case | Testing/demo | Daily use |

## How It Works

This plugin integrates with zsh's line editor (ZLE) by:

1. **Wrapping widgets** - Intercepts keyboard input via ZLE widgets
2. **Searching history** - Uses zsh's built-in `$history` array
3. **Display via POSTDISPLAY** - Shows suggestions using zsh's `POSTDISPLAY` variable
4. **Highlighting** - Applies gray color using `region_highlight`
5. **Hook system** - Uses `line-pre-redraw` to maintain display across redraws

## Next Steps

1. **Test it**: `source zsh-autosuggestions.zsh` in your terminal
2. **Try it out**: Type some commands and experiment with the keys
3. **Customize**: Adjust the color and behavior to your liking
4. **Make it permanent**: Add to your `~/.zshrc` when satisfied

Enjoy your fish-style auto-suggestions in zsh! 🐟➡️🔧

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by [Fish shell](https://fishshell.com/)'s auto-suggestions
- Thanks to the [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) project for inspiration

## Related Projects

- [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) - Another excellent zsh auto-suggestions plugin
- [Fish shell](https://fishshell.com/) - The original inspiration

---

Made with ❤️ for the zsh community
