# ZSH Auto-Suggestions# ZSH Auto-Suggestions Installation Guide



🐟 Fish-style auto-suggestions for Zsh with history cycling support!This guide will help you integrate the fish-style auto-suggestions into your actual zsh shell.



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)## Quick Start



## Features### Option 1: Load Temporarily (Test First)



✨ **Real-time suggestions** - See command suggestions in gray text as you type  Test the plugin without making permanent changes:

🔄 **Cycle through options** - Use ↑/↓ arrows to browse through matching commands  

⚡ **Fast and native** - Built with pure zsh, no external dependencies  ```bash

🎨 **Customizable** - Easy to configure colors and behavior

🔍 **Smart history search** - Searches through your entire command history  ```



## Quick StartThis will load the plugin for your current session only. Try typing some commands and you should see gray suggestions appear!



### Installation### Option 2: Permanent Installation



**Option 1: Clone the repository**Add to your `~/.zshrc` file:



```bash```bash

git clone https://github.com/jumbojett/zsh-autosuggestions-plugin.git ~/.zsh/zsh-autosuggestions
```

Then add to your `~/.zshrc`:

```bash
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
```

Then add to your `~/.zshrc`:

Then reload your shell:

```bash

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh```bash

```source ~/.zshrc

```

**Option 2: Direct download**

### Option 3: Install to Standard Plugin Location

```bash

# Download the pluginFor a cleaner setup, move the plugin to your zsh plugins directory:

curl -o ~/.zsh/zsh-autosuggestions.zsh https://raw.githubusercontent.com/jumbojett/zsh-autosuggestions-plugin/main/zsh-autosuggestions.zsh

```bash

# Add to your ~/.zshrc# Create plugins directory if it doesn't exist

echo 'source ~/.zsh/zsh-autosuggestions.zsh' >> ~/.zshrcmkdir -p ~/.zsh/plugins

```

# Copy the plugin
cp ./zsh-autosuggestions.zsh ~/.zsh/plugins/

# Add to ~/.zshrc
echo 'source ~/.zsh/plugins/zsh-autosuggestions.zsh' >> ~/.zshrc

```

# Reload shell

## Usagesource ~/.zshrc

```

### Auto-Suggestions

- **As you type**: Suggestions appear in gray text automatically## Features

- **From history**: Searches your zsh command history

- **Smart matching**: Only shows commands starting with your input### Auto-Suggestions

- **As you type**: See suggestions in gray text automatically

### Accepting Suggestions- **From history**: Suggestions come from your zsh command history

- **→ (Right Arrow)** or **End**: Accept entire suggestion when cursor is at end- **Smart matching**: Only shows commands that start with what you've typed

- **Tab**: Accept suggestion (at end of line)

- Press any other key to ignore the suggestion### Accepting Suggestions

- **→ (Right Arrow)**: Accept entire suggestion when cursor is at end of line

### Cycling Through Suggestions- **End Key**: Accept entire suggestion

- **↑ (Up Arrow)**: Cycle to previous (older) suggestion- **Ctrl+→**: Accept one word at a time

- **↓ (Down Arrow)**: Cycle to next (newer) suggestion- **Tab**: Normal tab completion (unchanged)

- Works when cursor is at the end of line with matching commands

### Cycling Through Suggestions

### Examples- **↑ (Up Arrow)**: When cursor is at end of line with text, cycle to older suggestions

- **↓ (Down Arrow)**: Cycle to newer suggestions

Type `git` and see suggestions:- **↑↓ with empty line**: Normal history navigation (unchanged)

```bash

$ git█              # Shows: git status (in gray)## Usage Examples

```

1. **Type a common command:**

Press ↑ to cycle:   ```

```bash   $ gi█

$ git█              # Shows: git push (in gray)   ```

$ git█              # Shows: git pull (in gray)   You might see: `git status` in gray

$ git█              # Shows: git commit -m "..." (in gray)   

```2. **Press → to accept:**

   ```

Press → or Tab to accept:   $ git status█

```bash   ```

$ git status█

```3. **Or press ↑ to see other suggestions:**

   ```

## Configuration   $ git push█  (or git pull, git commit, etc.)

   ```

Edit these settings in `zsh-autosuggestions.zsh`:

4. **Accept word-by-word with Ctrl+→:**

### Change Suggestion Color   ```

   $ git█  →  $ git status█  →  $ git status --short█

```bash   ```

# Default gray

typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'## Customization



# Other options:Edit the configuration section in `zsh-autosuggestions.zsh`:

# fg=240  - Darker gray

# fg=244  - Medium gray```bash

# fg=248  - Lighter gray# Change suggestion color (currently gray)

# fg=cyan,dim - Dimmed cyanZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'     # Try: fg=240, fg=244, etc.

```

# Maximum number of suggestions to cache

### Maximum Suggestions to Cache# (currently set to 10, increase for more cycling options)

head -n 10  # Change this number in the _zsh_autosuggest_fetch_suggestion function

Find this line in `_zsh_autosuggest_fetch_suggestion` function:```



```bash### Available Colors

(( ${#matches[@]} >= 10 )) && break  # Change 10 to your preferred number

```Try different gray shades by changing `fg=8`:

- `fg=8` - Default gray

## Compatibility- `fg=240` - Darker gray

- `fg=244` - Medium gray  

- **Zsh**: 5.0 or higher- `fg=248` - Lighter gray

- **macOS**: ✅ Fully tested- `fg=cyan,dim` - Dimmed cyan

- **Linux**: ✅ Should work- `fg=blue,dim` - Dimmed blue

- **Windows (WSL)**: ✅ Should work

## Troubleshooting

Works with:

- Oh My Zsh### Suggestions not appearing?

- Prezto1. Make sure you have command history: `history | head`

- Plain zsh2. Try typing a command you've used before

3. Check that the plugin loaded: should see "✓ ZSH Auto-Suggestions loaded" message

## Troubleshooting

### Conflicts with other plugins?

### Suggestions not appearing?If you use other zsh plugins (like oh-my-zsh), load this plugin AFTER them:



1. Check your history exists:```bash

   ```bash# ~/.zshrc order:

   history | headsource ~/.oh-my-zsh/oh-my-zsh.sh  # Or other plugin managers

   ```# ... other plugins ...

source ~/.zsh/plugins/zsh-autosuggestions.zsh  # Load this last

2. Try typing a command you've used before```



3. Look for the success message when loading:### Arrow keys not working?

   ```The plugin preserves normal arrow key behavior:

   ✓ ZSH Auto-Suggestions loaded- ↑↓ with empty line = history navigation (normal)

   ```- ↑↓ with text at end of line = cycle suggestions (new feature)

- ←→ = cursor movement (normal) + accept suggestion when at end (new)

### Conflicts with other plugins?

## Uninstalling

Load this plugin **after** other plugins in your `~/.zshrc`:

Remove the source line from your `~/.zshrc`:

```bash

source ~/.oh-my-zsh/oh-my-zsh.sh  # Load framework first```bash

# ... other plugins ...# Comment out or delete this line:

source ~/.zsh/zsh-autosuggestions.zsh  # Load this last# source ~/.zsh/plugins/zsh-autosuggestions.zsh

``````



### Arrow keys not working?Then reload:

```bash

The plugin preserves normal behavior:source ~/.zshrc

- ↑↓ with **empty line** = normal history navigation```

- ↑↓ with **text at end** = cycle through suggestions

- ←→ = normal cursor movement## Comparison with suggest.sh



## Uninstalling| Feature | suggest.sh (Proof of Concept) | zsh-autosuggestions.zsh (Real Integration) |

|---------|-------------------------------|-------------------------------------------|

Remove the source line from your `~/.zshrc`:| Shell Integration | Separate pseudo-shell | Native zsh integration |

| History | Reads history files | Uses zsh's built-in history |

```bash| Performance | Good | Excellent (native zle) |

# Remove or comment out:| Compatibility | Works in any shell | zsh only |

# source ~/.zsh/zsh-autosuggestions.zsh| Key Bindings | Custom handlers | Native zsh bindings |

```| Use Case | Testing/demo | Daily use |



Then reload:## Next Steps

```bash

source ~/.zshrc1. **Test it**: `source zsh-autosuggestions.zsh` in your terminal

```2. **Try it out**: Type some commands and experiment with the keys

3. **Customize**: Adjust the color and behavior to your liking

## How It Works4. **Make it permanent**: Add to your `~/.zshrc` when satisfied



This plugin integrates with zsh's line editor (ZLE) by:Enjoy your fish-style auto-suggestions in zsh! 🐟➡️🔧


1. **Wrapping widgets** - Intercepts keyboard input via ZLE widgets
2. **Searching history** - Uses zsh's built-in `$history` array
3. **Display via POSTDISPLAY** - Shows suggestions using zsh's `POSTDISPLAY` variable
4. **Highlighting** - Applies gray color using `region_highlight`
5. **Hook system** - Uses `line-pre-redraw` to maintain display across redraws

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
