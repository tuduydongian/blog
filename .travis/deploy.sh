#!/bin/bash
# Decrypt the private key
openssl aes-256-cbc -K $encrypted_QAWfCvU8_key -iv $encrypted_QAWfCvU8_iv -in .travis/ssh_key.enc -out ~/.ssh/id_rsa -d
# Set the permission of the key
chmod 600 ~/.ssh/id_rsa
# Start SSH agent
eval $(ssh-agent)
# Add the private key to the system
ssh-add ~/.ssh/id_rsa
# Copy SSH config
cp .travis/ssh_config ~/.ssh/config
# Set Git config
git config --global user.name "TDDG Bot"
git config --global user.email bot@tuduydongian.com
# Copy prod config
cp _config.prod.yml _config.yml
# Clone the repository
git clone git@github.com:tuduydongian/tuduydongian.github.io.git .deploy_git
# Deploy to GitHub
npm run deploy