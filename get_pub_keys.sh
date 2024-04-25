#!/bin/bash

# 设置GitHub用户名
USERNAME="wengych"

# 指定API URL
API_URL="https://api.github.com/users/$USERNAME/keys"

# 使用curl从GitHub API获取公钥，并使用jq解析公钥数据
curl -s "$API_URL" | jq -r '.[].key' > /tmp/github_keys

# 检查/tmp/github_keys是否为空
if [ -s /tmp/github_keys ]; then
    echo "Adding keys to ~/.ssh/authorized_keys..."
    # 将公钥添加到authorized_keys，同时检查避免重复添加相同的公钥
    while read -r key; do
        # 检查公钥是否已经存在于authorized_keys中
        grep -qxF "$key" ~/.ssh/authorized_keys || echo "$key" >> ~/.ssh/authorized_keys
    done < /tmp/github_keys
    echo "Keys added successfully."
else
    echo "No keys fetched from GitHub or user does not exist."
fi

# 清理临时文件
rm /tmp/github_keys
