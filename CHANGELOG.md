# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-16

### Added
- Initial release
- Fish-style auto-suggestions for Zsh
- Real-time suggestions from command history
- Cycle through suggestions with ↑/↓ arrow keys
- Accept suggestions with →, Tab, or End key
- Gray highlighting for suggestions
- Support for `up-line-or-beginning-search` widget
- Support for `down-line-or-beginning-search` widget
- Line-pre-redraw hook for persistent highlighting
- Customizable suggestion color
- Compatible with Oh My Zsh and other frameworks
- MIT License

### Technical Details
- Uses zsh's native `$history` array for fast searching
- Integrates with ZLE (Zsh Line Editor)
- Uses `POSTDISPLAY` for non-intrusive suggestions
- Uses `region_highlight` for gray coloring
- Wraps standard zsh widgets for seamless integration

[1.0.0]: https://github.com/jumbojett/zsh-autosuggestions-plugin/releases/tag/v1.0.0
