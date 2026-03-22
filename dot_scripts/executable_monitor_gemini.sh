#!/bin/bash

# Configuration
SOUND_FILE="/usr/share/sounds/freedesktop/stereo/complete.oga"
CHECK_INTERVAL=0.5

# Piper Configuration
PIPER_BIN="/opt/piper-tts/piper"
VOICE_MODEL="/home/diego/.scripts/piper-voices/en_US-lessac-high.onnx"
VOICE_CONFIG="/home/diego/.scripts/piper-voices/en_US-lessac-high.onnx.json"

# Gemini Strings
G_WORKING="Working…"
G_READY="Ready"
G_ACTION="Action Required"

# Copilot Strings
C_ROBOT="🤖"
# Keywords that suggest a prompt
PROMPT_KEYWORDS=("ask_user" "confirm" "select" "question" "choice" "input" "approval" "prompt")

echo "Monitoring ALL Alacritty windows for Gemini/Copilot CLI changes with Piper T2S (Cleaned Emojis)..."

# Associative array to track state
declare -A last_titles

# Function to play sound and speak the title using Piper
speak_title() {
    local last_title="$1"
    local current_title="$2"
    local prefix="$3"
    local desktop="$4"
    
    # Extract project name from last_title (e.g., "bps")
    local project=$(echo "$last_title" | grep -oP "\\(\K[^\\)]+" || echo "$current_title" | grep -oP "\\(\K[^\\)]+" || echo "")
    
    # Construct the message
    local message="$prefix"
    if [ -n "$project" ]; then
        message="$message $project"
    fi
    if [ -n "$desktop" ]; then
        message="$message on desktop $desktop"
    fi
    
    # Play notification sound
    paplay "$SOUND_FILE" 2>/dev/null
    
    # Speak using Piper and mpv
    (echo "$message" | "$PIPER_BIN" -m "$VOICE_MODEL" -c "$VOICE_CONFIG" --output-file - | mpv - &>/dev/null) &
}

while true; do
    # Get all Alacritty windows with titles and workspace IDs
    mapfile -t windows < <(hyprctl clients -j | jq -c ".[] | select(.class == \"Alacritty\" and .title != null) | {address: .address, title: .title, workspace_id: .workspace.id}")

    for win in "${windows[@]}"; do
        address=$(echo "$win" | jq -r ".address")
        current_title=$(echo "$win" | jq -r ".title")
        workspace_id=$(echo "$win" | jq -r ".workspace_id")
        last_title="${last_titles[$address]}"
        
        if [ "$current_title" != "$last_title" ]; then
            if [ -n "$last_title" ]; then
                # --- Gemini Logic ---
                if [[ "$last_title" == *"$G_WORKING"* ]] && [[ "$current_title" != *"$G_WORKING"* ]]; then
                    echo "[Gemini] Task finished: $current_title (Desktop $workspace_id)"
                    speak_title "$last_title" "$current_title" "Gemini finished" "$workspace_id"
                
                elif [[ "$current_title" == *"$G_ACTION"* ]] && [[ "$last_title" != *"$G_ACTION"* ]]; then
                    echo "[Gemini] Action required: $current_title (Desktop $workspace_id)"
                    speak_title "$last_title" "$current_title" "Gemini needs action" "$workspace_id"
                
                elif [[ "$current_title" == *"$G_READY"* ]] && [[ "$last_title" != *"$G_READY"* ]]; then
                    echo "[Gemini] Ready: $current_title (Desktop $workspace_id)"
                    speak_title "$last_title" "$current_title" "Gemini is ready" "$workspace_id"

                # --- Copilot Logic ---
                elif [[ "$current_title" == *"$C_ROBOT"* ]] && [[ "$last_title" != *"$C_ROBOT"* ]]; then
                    echo "[Copilot] Started: $current_title (Desktop $workspace_id)"
                    speak_title "$last_title" "$current_title" "Copilot started" "$workspace_id"
                
                elif [[ "$last_title" == *"$C_ROBOT"* ]] && [[ "$current_title" != *"$C_ROBOT"* ]]; then
                    echo "[Copilot] Finished: $current_title (Desktop $workspace_id)"
                    speak_title "$last_title" "$current_title" "Copilot finished" "$workspace_id"
                
                elif [[ "$current_title" == *"$C_ROBOT"* ]] && [[ "$last_title" == *"$C_ROBOT"* ]]; then
                    is_prompt=false
                    for kw in "${PROMPT_KEYWORDS[@]}"; do
                        if [[ "${current_title,,}" == *"$kw"* ]]; then is_prompt=true; break; fi
                    done

                    if [ "$is_prompt" = true ]; then
                        echo "[Copilot] PROMPT: $current_title (Desktop $workspace_id)"
                        speak_title "$last_title" "$current_title" "Copilot prompt" "$workspace_id"
                    else
                        echo "[Copilot] Update: $current_title (Desktop $workspace_id)"
                        speak_title "$last_title" "$current_title" "Copilot update" "$workspace_id"
                    fi
                fi
            fi
            last_titles["$address"]="$current_title"
        fi
    done
    sleep "$CHECK_INTERVAL"
done
done
