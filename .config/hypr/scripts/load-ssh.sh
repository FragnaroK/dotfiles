eval "$(ssh-agent -s)"

# Add all private keys in ~/.ssh to the agent if not already added
if ssh-add -l | grep -q "no identities"; then
    for key in ~/.ssh/id_*; do
        # Only add if it's a private key file (skip .pub files)
        if [[ -f "$key" && ! "$key" =~ \.pub$ ]]; then
            ssh-add "$key"
        fi
    done
fi

if [ "$?" -ne 0 ]; then
    echo "Error: ssh setup failed"
    notify-send -u critical "SSH Setup" "Failed to add ssh keys to agent"
    exit 1
fi