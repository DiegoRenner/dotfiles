#!/bin/bash

# Configuration
SOUND_FILE="/usr/share/sounds/freedesktop/stereo/complete.oga"
CHECK_INTERVAL=0.5

# Piper Configuration
PIPER_BIN="/opt/piper-tts/piper"
VOICE_MODEL="/home/diego/downloads/en_US-lessac-high.onnx"
VOICE_CONFIG="/home/diego/downloads/en_US-lessac-high.onnx.json"

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
    local title="$1"
    local prefix="$2"
    
    # Clean up title for speech:
    # 1. Replace parentheses with spaces so project tags are read clearly
    # 2. Remove "Working" and "..."
    # 3. Use perl to strip all remaining non-ASCII characters (emojis, ✦, 🤖, etc.)
    local clean_title=$(echo "$title" | sed 's/(/ /g; s/)/ /g; s/Working//g; s/…//g' | perl -pe 's/[^\x00-\x7F]+//g')
    
    # Play notification sound
    paplay "$SOUND_FILE" 2>/dev/null
    
    # Speak using Piper and mpv
    (echo "$prefix $clean_title" | "$PIPER_BIN" -m "$VOICE_MODEL" -c "$VOICE_CONFIG" --output-file - | mpv - &>/dev/null) &
}

while true; do
    mapfile -t windows < <(hyprctl clients -j | jq -c ".[] | select(.class == \"Alacritty\" and .title != null)")

    for win in "${windows[@]}"; do
        address=$(echo "$win" | jq -r ".address")
        current_title=$(echo "$win" | jq -r ".title")
        last_title="${last_titles[$address]}"
        
        if [ "$current_title" != "$last_title" ]; then
            if [ -n "$last_title" ]; then
                # --- Gemini Logic ---
                if [[ "$last_title" == *"$G_WORKING"* ]] && [[ "$current_title" != *"$G_WORKING"* ]]; then
                    echo "[Gemini] Task finished: $current_title"
                    speak_title "$current_title" "Gemini finished"
                
                elif [[ "$current_title" == *"$G_ACTION"* ]] && [[ "$last_title" != *"$G_ACTION"* ]]; then
                    echo "[Gemini] Action required: $current_title"
                    speak_title "$current_title" "Gemini needs action"
                
                elif [[ "$current_title" == *"$G_READY"* ]] && [[ "$last_title" != *"$G_READY"* ]]; then
                    echo "[Gemini] Ready: $current_title"
                    speak_title "$current_title" "Gemini is ready"

                # --- Copilot Logic ---
                elif [[ "$current_title" == *"$C_ROBOT"* ]] && [[ "$last_title" != *"$C_ROBOT"* ]]; then
                    echo "[Copilot] Started: $current_title"
                    speak_title "$current_title" "Copilot started"
                
                elif [[ "$last_title" == *"$C_ROBOT"* ]] && [[ "$current_title" != *"$C_ROBOT"* ]]; then
                    echo "[Copilot] Finished: $current_title"
                    speak_title "$current_title" "Copilot finished"
                
                elif [[ "$current_title" == *"$C_ROBOT"* ]] && [[ "$last_title" == *"$C_ROBOT"* ]]; then
                    is_prompt=false
                    for kw in "${PROMPT_KEYWORDS[@]}"; do
                        if [[ "${current_title,,}" == *"$kw"* ]]; then is_prompt=true; break; fi
                    done

                    if [ "$is_prompt" = true ]; then
                        echo "[Copilot] PROMPT: $current_title"
                        speak_title "$current_title" "Copilot prompt"
                    else
                        echo "[Copilot] Update: $current_title"
                        speak_title "$current_title" "Copilot update"
                    fi
                fi
            fi
            last_titles["$address"]="$current_title"
        fi
    done
    sleep "$CHECK_INTERVAL"
done
