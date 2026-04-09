# Switches between aws profiles
awsp() {
    local profile_arg="$1"
    local selected_profile

    # Logic: If an argument is provided, use it.
    # Otherwise (or if the argument is empty), use fzf.
    if [[ -n "$profile_arg" ]]; then
        selected_profile="$profile_arg"
    else
        selected_profile=$( (echo "none"; aws configure list-profiles) | fzf \
            --height ~100% \
            --layout reverse \
            --border \
            --prompt "Choose active AWS profile: ")
    fi

    # Handle the "none" case or valid profile selection
    if [[ -z "$selected_profile" ]]; then
        return 0 # User pressed ESC or canceled fzf
    elif [[ "$selected_profile" == "none" ]]; then
        unset AWS_PROFILE
        echo "AWS_PROFILE unset."
    else
        # Check if the profile actually exists in AWS config
        if aws configure list-profiles | grep -qx "$selected_profile"; then
            export AWS_PROFILE="$selected_profile"
            echo "AWS_PROFILE set to: $AWS_PROFILE"

            # Verify credentials are valid; attempt SSO login on any failure
            local cred_output cred_exit
            cred_output=$(aws sts get-caller-identity 2>&1)
            cred_exit=$?
            if [[ $cred_exit -ne 0 ]]; then
                echo "Credentials unavailable or expired. Running 'aws sso login'..."
                aws sso login --profile "$AWS_PROFILE"
            fi
        else
            echo "Error: Profile '$selected_profile' does not exist."
            return 1
        fi
    fi
}
