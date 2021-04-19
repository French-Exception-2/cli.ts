#!/usr/bin/env pwsh

json=$(cat <<EOF
{
    user: {
        login: $USER_LOGIN,
        name: $USER_NAME,
        code_path: "$code_PATH
    }
}
EOF
)

echo $json | tee $HOME/.user.json