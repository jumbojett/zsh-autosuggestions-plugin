#!/usr/bin/env zsh

#==============================================================================
# ZSH Auto-Suggestions Plugin
#==============================================================================
# Fish-style auto-suggestions integrated with zsh line editor (zle)
# Features:
#   - Real-time suggestions as you type (dimmed gray text)
#   - Cycle through suggestions with ↑/↓ arrow keys (when line is not empty)
#   - Accept suggestions with Tab or → (when at end of line)
#   - Uses actual zsh history
#   - Works seamlessly with your existing zsh setup
#==============================================================================

# Configuration
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
typeset -g ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX=.autosuggest-orig-

# Global state
typeset -g _ZSH_AUTOSUGGEST_SUGGESTION=""
typeset -g _ZSH_AUTOSUGGEST_SUGGESTION_INDEX=0
typeset -ga _ZSH_AUTOSUGGEST_SUGGESTIONS_ARRAY
typeset -g _ZSH_AUTOSUGGEST_LAST_BUFFER=""

#==============================================================================
# SUGGESTION ENGINE
#==============================================================================

# Generate suggestions from filesystem and history based on current buffer
_zsh_autosuggest_fetch_suggestion() {
    local buffer="$1"
    
    # Clear suggestion if buffer is empty
    if [[ -z "$buffer" ]]; then
        _ZSH_AUTOSUGGEST_SUGGESTION=""
        return
    fi
    
    # Only reload suggestions if buffer changed
    if [[ "$buffer" != "$_ZSH_AUTOSUGGEST_LAST_BUFFER" ]]; then
        _ZSH_AUTOSUGGEST_LAST_BUFFER="$buffer"
        _ZSH_AUTOSUGGEST_SUGGESTIONS_ARRAY=()
        _ZSH_AUTOSUGGEST_SUGGESTION_INDEX=0
        
        local -a matches
        local cmd
        local seen_commands
        typeset -A seen_commands
        
        # PRIORITY 1: Search current directory files and folders first
        local -a fs_matches
        for file in "$PWD"/*; do
            if [[ -e "$file" ]]; then
                local basename="${file##*/}"
                # Check if filename contains buffer (case-insensitive) and hasn't been seen
                if [[ "${basename:l}" == *"${buffer:l}"* ]] && [[ -z "${seen_commands[$basename]}" ]]; then
                    fs_matches+=("$basename")
                    seen_commands[$basename]=1
                fi
            fi
        done
        
        # Add filesystem matches first (highest priority)
        matches=("${fs_matches[@]}")
        
        # PRIORITY 2: Add history matches (up to 10 total matches)
        if (( ${#matches[@]} < 10 )); then
            # Iterate through history in reverse (newest first)
            for cmd in "${(@)history[@]}"; do
                # Check if command contains buffer (case-insensitive) and hasn't been seen
                if [[ "${cmd:l}" == *"${buffer:l}"* ]] && [[ "$cmd" != "$buffer" ]] && [[ -z "${seen_commands[$cmd]}" ]]; then
                    matches+=("$cmd")
                    seen_commands[$cmd]=1
                    # Stop after 10 total matches
                    (( ${#matches[@]} >= 10 )) && break
                fi
            done
        fi
        
        _ZSH_AUTOSUGGEST_SUGGESTIONS_ARRAY=("${matches[@]}")
    fi
    
    # Get suggestion at current index
    local count=${#_ZSH_AUTOSUGGEST_SUGGESTIONS_ARRAY[@]}
    
    if (( count > 0 )); then
        # Bounds checking
        if (( _ZSH_AUTOSUGGEST_SUGGESTION_INDEX >= count )); then
            _ZSH_AUTOSUGGEST_SUGGESTION_INDEX=0
        elif (( _ZSH_AUTOSUGGEST_SUGGESTION_INDEX < 0 )); then
            _ZSH_AUTOSUGGEST_SUGGESTION_INDEX=$((count - 1))
        fi
        
        # Get the full suggestion (zsh arrays are 1-indexed)
        # Use the index directly - first match (index 0) is shown first
        local array_index=$((_ZSH_AUTOSUGGEST_SUGGESTION_INDEX + 1))
        local full_suggestion="${_ZSH_AUTOSUGGEST_SUGGESTIONS_ARRAY[$array_index]}"
        
        # If buffer is at the start of the command, show the completion
        # Otherwise, show the full command (for substring matches)
        if [[ "$full_suggestion" == "$buffer"* ]]; then
            # Buffer is a prefix - show the rest as completion
            _ZSH_AUTOSUGGEST_SUGGESTION="${full_suggestion#$buffer}"
        else
            # Buffer is a substring - show the full command
            _ZSH_AUTOSUGGEST_SUGGESTION=" → $full_suggestion"
        fi
    else
        _ZSH_AUTOSUGGEST_SUGGESTION=""
        _ZSH_AUTOSUGGEST_SUGGESTION_INDEX=0
    fi
}

# Render suggestion on screen
_zsh_autosuggest_render() {
    # Always clear first
    POSTDISPLAY=""
    region_highlight=()
    
    # Only show if cursor is at the end of buffer
    if (( CURSOR == ${#BUFFER} )) && [[ -n "$_ZSH_AUTOSUGGEST_SUGGESTION" ]]; then
        # Set POSTDISPLAY to show gray text
        POSTDISPLAY="$_ZSH_AUTOSUGGEST_SUGGESTION"
        
        # Calculate positions for highlighting
        local buffer_length=${#BUFFER}
        local suggestion_length=${#_ZSH_AUTOSUGGEST_SUGGESTION}
        local total_length=$((buffer_length + suggestion_length))
        
        # Set region_highlight - this persists across widget calls if we're careful
        region_highlight=("$buffer_length $total_length $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE")
    fi
}

# Hook that runs after EVERY widget to maintain suggestion display
_zsh_autosuggest_line_pre_redraw() {
    # Only show suggestions if cursor is at the end of the buffer
    if (( CURSOR == ${#BUFFER} )) && [[ -n "$_ZSH_AUTOSUGGEST_SUGGESTION" ]]; then
        # Re-apply the suggestion display after any widget that might clear it
        POSTDISPLAY="$_ZSH_AUTOSUGGEST_SUGGESTION"
        
        local buffer_length=${#BUFFER}
        local suggestion_length=${#_ZSH_AUTOSUGGEST_SUGGESTION}
        local total_length=$((buffer_length + suggestion_length))
        
        region_highlight=("$buffer_length $total_length $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE")
    else
        # Clear suggestions if cursor is not at end or no suggestion
        POSTDISPLAY=""
        region_highlight=()
    fi
}

# Clear suggestion
_zsh_autosuggest_clear() {
    _ZSH_AUTOSUGGEST_SUGGESTION=""
    _ZSH_AUTOSUGGEST_SUGGESTION_INDEX=0
    _ZSH_AUTOSUGGEST_SUGGESTIONS_ARRAY=()
    _ZSH_AUTOSUGGEST_LAST_BUFFER=""
    POSTDISPLAY=""
    region_highlight=()
}

# Cycle to next older suggestion (↑)
_zsh_autosuggest_cycle_up() {
    [[ -z "$BUFFER" ]] && return
    
    # Ensure suggestions are loaded (but don't reset index)
    local buffer="$BUFFER"
    if [[ "$buffer" != "$_ZSH_AUTOSUGGEST_LAST_BUFFER" ]]; then
        _zsh_autosuggest_fetch_suggestion "$buffer"
    fi
    
    local count=${#_ZSH_AUTOSUGGEST_SUGGESTIONS_ARRAY[@]}
    
    # Only cycle if we have suggestions
    if (( count > 0 )); then
        # Move to next suggestion
        _ZSH_AUTOSUGGEST_SUGGESTION_INDEX=$((_ZSH_AUTOSUGGEST_SUGGESTION_INDEX + 1))
        if (( _ZSH_AUTOSUGGEST_SUGGESTION_INDEX >= count )); then
            _ZSH_AUTOSUGGEST_SUGGESTION_INDEX=0
        fi
        
        # Get suggestion from array (zsh arrays are 1-indexed)
        local array_index=$((_ZSH_AUTOSUGGEST_SUGGESTION_INDEX + 1))
        local full_suggestion="${_ZSH_AUTOSUGGEST_SUGGESTIONS_ARRAY[$array_index]}"
        
        # If buffer is at the start of the command, show the completion
        # Otherwise, show the full command (for substring matches)
        if [[ "$full_suggestion" == "$buffer"* ]]; then
            _ZSH_AUTOSUGGEST_SUGGESTION="${full_suggestion#$buffer}"
        else
            _ZSH_AUTOSUGGEST_SUGGESTION=" → $full_suggestion"
        fi
        
        # Render with proper highlighting
        _zsh_autosuggest_render
    fi
}

# Cycle to next newer suggestion (↓)
_zsh_autosuggest_cycle_down() {
    [[ -z "$BUFFER" ]] && return
    
    local count=${#_ZSH_AUTOSUGGEST_SUGGESTIONS_ARRAY[@]}
    
    if (( count > 0 && _ZSH_AUTOSUGGEST_SUGGESTION_INDEX > 0 )); then
        # Move to previous suggestion
        _ZSH_AUTOSUGGEST_SUGGESTION_INDEX=$((_ZSH_AUTOSUGGEST_SUGGESTION_INDEX - 1))
        
        # Get suggestion from array (zsh arrays are 1-indexed)
        local buffer="$BUFFER"
        local array_index=$((_ZSH_AUTOSUGGEST_SUGGESTION_INDEX + 1))
        local full_suggestion="${_ZSH_AUTOSUGGEST_SUGGESTIONS_ARRAY[$array_index]}"
        
        # If buffer is at the start of the command, show the completion
        # Otherwise, show the full command (for substring matches)
        if [[ "$full_suggestion" == "$buffer"* ]]; then
            _ZSH_AUTOSUGGEST_SUGGESTION="${full_suggestion#$buffer}"
        else
            _ZSH_AUTOSUGGEST_SUGGESTION=" → $full_suggestion"
        fi
        
        # Render with proper highlighting
        _zsh_autosuggest_render
    fi
}

#==============================================================================
# WIDGET WRAPPERS
#==============================================================================

# Main modify function - update suggestions after buffer changes
_zsh_autosuggest_modify() {
    # Only show suggestions if cursor is at end of buffer
    if (( CURSOR == ${#BUFFER} )); then
        # Fetch new suggestion for current buffer
        _zsh_autosuggest_fetch_suggestion "$BUFFER"
        
        # Render it
        _zsh_autosuggest_render
    else
        # Clear suggestions if cursor is not at end
        POSTDISPLAY=""
        region_highlight=()
    fi
}

# Accept the full suggestion
_zsh_autosuggest_accept() {
    if [[ -n "$_ZSH_AUTOSUGGEST_SUGGESTION" ]]; then
        # Check if this is a substring match (starts with " → ")
        if [[ "$_ZSH_AUTOSUGGEST_SUGGESTION" == " → "* ]]; then
            # Replace the entire buffer with the suggested command
            BUFFER="${_ZSH_AUTOSUGGEST_SUGGESTION#" → "}"
        else
            # Append the suggestion (normal prefix completion)
            BUFFER="$BUFFER$_ZSH_AUTOSUGGEST_SUGGESTION"
        fi
        CURSOR=${#BUFFER}
        _zsh_autosuggest_clear
    fi
}

# Widget: self-insert (regular typing)
_zsh_autosuggest_widget_modify() {
    zle $ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX${WIDGET#autosuggest-} "$@"
    _zsh_autosuggest_modify
}

# Widget: clear
_zsh_autosuggest_widget_clear() {
    _zsh_autosuggest_clear
    zle $ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX${WIDGET#autosuggest-} "$@"
}

# Widget: accept
_zsh_autosuggest_widget_accept() {
    _zsh_autosuggest_accept
}

# Widget: forward-char (right arrow) 
_zsh_autosuggest_widget_forward_char() {
    # If at end of buffer and there's a suggestion, accept it
    if (( CURSOR == ${#BUFFER} )) && [[ -n "$_ZSH_AUTOSUGGEST_SUGGESTION" ]]; then
        _zsh_autosuggest_accept
    else
        zle $ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX${WIDGET#autosuggest-} "$@"
    fi
}

# Widget: end-of-line
_zsh_autosuggest_widget_end_of_line() {
    # If there's a suggestion, accept it
    if [[ -n "$_ZSH_AUTOSUGGEST_SUGGESTION" ]]; then
        _zsh_autosuggest_accept
    else
        zle $ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX${WIDGET#autosuggest-} "$@"
    fi
}

# Widget: up-line-or-history with cycling
_zsh_autosuggest_widget_up_line_or_history() {
    # If buffer is not empty and cursor is at end, DON'T use history navigation
    # Instead, cycle through suggestions only
    if [[ -n "$BUFFER" ]] && (( CURSOR == ${#BUFFER} )); then
        # Make sure we have suggestions loaded
        if (( ${#_ZSH_AUTOSUGGEST_SUGGESTIONS_ARRAY[@]} == 0 )); then
            _zsh_autosuggest_fetch_suggestion "$BUFFER"
        fi
        
        # If we have suggestions, cycle through them (don't touch BUFFER)
        if (( ${#_ZSH_AUTOSUGGEST_SUGGESTIONS_ARRAY[@]} > 0 )); then
            _zsh_autosuggest_cycle_up
            # Return early - DON'T call the original widget
            return 0
        fi
    fi
    
    # Only if cursor is NOT at end, use normal history navigation
    zle $ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX${WIDGET#autosuggest-} "$@"
    _zsh_autosuggest_modify
}

# Widget: down-line-or-history with cycling  
_zsh_autosuggest_widget_down_line_or_history() {
    # If buffer is not empty, cursor at end, and we can cycle down
    if [[ -n "$BUFFER" ]] && (( CURSOR == ${#BUFFER} )) && (( _ZSH_AUTOSUGGEST_SUGGESTION_INDEX > 0 )); then
        _zsh_autosuggest_cycle_down
        # Return early - DON'T call the original widget
        return 0
    fi
    
    # Only if we can't cycle, use normal history navigation
    zle $ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX${WIDGET#autosuggest-} "$@"
    _zsh_autosuggest_modify
}

#==============================================================================
# WIDGET BINDING
#==============================================================================

# Bind a single widget
_zsh_autosuggest_bind_widget() {
    local widget=$1
    local autosuggest_action=$2
    local prefix=$ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX
    
    # Save the original widget
    case $widgets[$widget] in
        # Already bound
        user:_zsh_autosuggest_widget_*)
            return
            ;;
        
        # User defined widget
        user:*)
            zle -N $prefix$widget ${widgets[$widget]#user:}
            ;;
        
        # Built-in widget
        builtin)
            eval "_zsh_autosuggest_orig_${widget}() { zle .$widget }"
            zle -N $prefix$widget _zsh_autosuggest_orig_${widget}
            ;;
        
        # Completion widget
        completion:*)
            eval "zle -C $prefix$widget ${${widgets[$widget]#completion:}/:/ }"
            ;;
    esac
    
    # Bind the autosuggest widget
    zle -N $widget _zsh_autosuggest_widget_$autosuggest_action
}

# Bind all widgets
_zsh_autosuggest_bind_widgets() {
    # Find every widget that modifies the buffer and bind it
    local widget
    local -a widgets_to_bind
    
    widgets_to_bind=(
        self-insert
        delete-char
        backward-delete-char
        backward-kill-word
        kill-word
        up-line-or-history
        up-line-or-beginning-search
        down-line-or-history
        down-line-or-beginning-search
        forward-char
        end-of-line
        accept-line
    )
    
    # Bind widgets that should update suggestions
    for widget in self-insert delete-char backward-delete-char backward-kill-word kill-word; do
        _zsh_autosuggest_bind_widget $widget modify
    done
    
    # Bind history widgets (both variants)
    _zsh_autosuggest_bind_widget up-line-or-history up_line_or_history
    _zsh_autosuggest_bind_widget up-line-or-beginning-search up_line_or_history
    _zsh_autosuggest_bind_widget down-line-or-history down_line_or_history
    _zsh_autosuggest_bind_widget down-line-or-beginning-search down_line_or_history
    
    # Bind accept widgets
    _zsh_autosuggest_bind_widget forward-char forward_char
    _zsh_autosuggest_bind_widget end-of-line end_of_line
    
    # Bind clear widget
    _zsh_autosuggest_bind_widget accept-line clear
    
    # Create custom accept widget for Tab key
    zle -N autosuggest-accept _zsh_autosuggest_widget_accept
    bindkey '^I' autosuggest-accept  # Tab key
}

#==============================================================================
# INITIALIZATION
#==============================================================================

# Hook into precmd to reset state between commands
_zsh_autosuggest_precmd() {
    _zsh_autosuggest_clear
}

# Start the plugin
_zsh_autosuggest_start() {
    # Bind all widgets
    _zsh_autosuggest_bind_widgets
    
    # Add precmd hook to reset between commands
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _zsh_autosuggest_precmd
    
    # Add line-pre-redraw hook to maintain highlighting
    # This hook runs before every line redraw, ensuring our suggestion stays visible
    autoload -Uz add-zle-hook-widget
    add-zle-hook-widget line-pre-redraw _zsh_autosuggest_line_pre_redraw
    
    # echo "✓ ZSH Auto-Suggestions loaded"
    # echo "  • Type to see suggestions (in gray)"
    # echo "  • Tab or → to accept suggestion (at end of line)"
    # echo "  • ↑/↓ to cycle through suggestions (at end of line)"
}

# Initialize
_zsh_autosuggest_start
