#!/bin/bash

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Create systemd service file for Ollama
cat << EOF | sudo tee /etc/systemd/system/ollama.service
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/bin/ollama serve
User=$USER
Restart=always
RestartSec=3
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[Install]
WantedBy=default.target
EOF

# Enable and start Ollama service
sudo systemctl enable ollama
sudo systemctl start ollama

# Wait for Ollama service to fully start
sleep 5

# Pull the Phi model
ollama pull phi

# Create package.json
cat << EOF > package.json
{
  "name": "ollama-phi-test",
  "version": "1.0.0",
  "type": "module",
  "main": "test_phi.js",
  "dependencies": {
    "node-fetch": "^3.3.0"
  }
}
EOF

# Install dependencies
npm install

# Create a test script
cat << EOF > test_phi.js
import { exec } from 'child_process';
import { promisify } from 'util';
import { appendFile } from 'fs/promises';

const execAsync = promisify(exec);

async function queryPhi(prompt) {
    try {
        const { stdout } = await execAsync(\`ollama run phi "\${prompt}"\`);
        return stdout.trim();
    } catch (error) {
        console.error('Error querying Phi:', error);
        return null;
    }
}

async function main() {
    const prompt = "Write a hello world program in JavaScript";
    console.log(\`Sending prompt: \${prompt}\n\`);
    
    const response = await queryPhi(prompt);
    console.log("Response:");
    console.log(response);

    // Log the test
    const timestamp = new Date().toISOString();
    await appendFile('phi_test_log.txt', \`\n[\${timestamp}] Test completed successfully\`);
}

main().catch(console.error);
EOF

# Create a README
cat << EOF > README.md
# Ollama Phi Setup

This environment has been configured with Ollama and the Microsoft Phi model.

## Usage

1. The Ollama service should be running automatically
2. You can test the setup by running: \`node test_phi.js\`
3. To use Phi directly from command line: \`ollama run phi "your prompt here"\`

## Troubleshooting

If Ollama isn't responding:
1. Check service status: \`sudo systemctl status ollama\`
2. Restart service: \`sudo systemctl restart ollama\`
3. Check logs: \`journalctl -u ollama\`
EOF

echo "Setup complete! You can now use the Phi model through Ollama."
echo "Try running: node test_phi.js"