#!/usr/bin/env bash

json=$(cat <<EOF
{
    "user": {
        "login": "$USER_LOGIN",
        "name": "$USER_NAME",
        "code_path": "$CODE_PATH"
    }
}
EOF
)

echo "$json" | tee $HOME/.user.json
