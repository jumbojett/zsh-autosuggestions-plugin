# Contributing to ZSH Auto-Suggestions

First off, thank you for considering contributing to this project! 🎉

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior** vs **actual behavior**
- **Zsh version**: Run `zsh --version`
- **OS and version**: e.g., macOS 14.0, Ubuntu 22.04
- **Terminal emulator**: e.g., iTerm2, Terminal.app, GNOME Terminal
- **Other zsh plugins** you're using (Oh My Zsh, etc.)

### Suggesting Enhancements

Enhancement suggestions are welcome! Please provide:

- **Clear title and description**
- **Use case** - Why is this enhancement useful?
- **Proposed solution** - How should it work?
- **Alternatives considered** - What other approaches did you think about?

### Pull Requests

1. **Fork the repo** and create your branch from `main`
2. **Test your changes** thoroughly
3. **Update documentation** if needed
4. **Follow the existing code style**
5. **Write clear commit messages**

## Development Setup

```bash
# Clone your fork
git clone https://github.com/jumbojett/zsh-autosuggestions-plugin.git
cd zsh-autosuggestions-plugin

# Create a branch
git checkout -b feature/my-new-feature

# Make your changes
# ...

# Test your changes
source zsh-autosuggestions.zsh
# Try typing commands and using arrow keys

# Commit
git add .
git commit -m "Add some feature"

# Push
git push origin feature/my-new-feature
```

## Code Style

- Use **descriptive variable names**
- Add **comments** for complex logic
- Follow **existing formatting** (2-space indentation)
- Use **zsh best practices**:
  - `[[ ]]` instead of `[ ]` for conditionals
  - `(( ))` for arithmetic
  - `local` for function-scoped variables
  - Proper quoting of variables

## Testing

Manual testing checklist:

- [ ] Suggestions appear when typing
- [ ] Suggestions are gray/dimmed
- [ ] Tab accepts suggestion
- [ ] Right arrow accepts suggestion at end of line
- [ ] Up arrow cycles through suggestions
- [ ] Down arrow cycles back
- [ ] Cursor navigation works normally
- [ ] Works with Oh My Zsh (if applicable)
- [ ] No errors in terminal

## Commit Messages

Use clear, descriptive commit messages:

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding tests
- **chore**: Maintenance tasks

Examples:
```
feat: add support for Ctrl+Right to accept word-by-word
fix: prevent buffer modification during arrow key cycling
docs: update installation instructions for Oh My Zsh
```

## Questions?

Feel free to open an issue with the "question" label.

---

Thank you for contributing! 🙏
