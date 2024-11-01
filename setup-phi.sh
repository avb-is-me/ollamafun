#!/bin/bash

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Pull the Phi model first
ollama pull phi

# Create a script to start the Ollama server
cat << EOF > start-ollama-server.sh
#!/bin/bash

# Kill any existing Ollama processes
pkill ollama

# Start the Ollama server
ollama serve
EOF

# Create a script to run the model
cat << EOF > start-model.sh
#!/bin/bash

# Function to check if Ollama server is running
check_server() {
    for i in {1..30}; do
        if pgrep ollama > /dev/null; then
            return 0
        fi
        echo "Waiting for Ollama server to start... ($i/30)"
        sleep 1
    done
    return 1
}

# Check if server is running
if ! check_server; then
    echo "Error: Ollama server did not start within 30 seconds"
    exit 1
fi

echo "Ollama server is running. Starting Phi model..."

# Start the model
exec ollama run phi
EOF

# Create a combined startup script
cat << EOF > start-all.sh
#!/bin/bash

# Start the Ollama server in the background
./start-ollama-server.sh &

# Wait a moment for the server to initialize
sleep 5

# Start the model in a new terminal if running in a GUI environment
if [ -n "\$DISPLAY" ]; then
    x-terminal-emulator -e "./start-model.sh" &
else
    # For non-GUI environments, provide instructions
    echo "Ollama server is running in the background."
    echo "To start using the model, open a new terminal and run:"
    echo "./start-model.sh"
fi
EOF

# Create a README
cat << EOF > README.md
# Ollama Phi Setup

This environment has been configured with Ollama and the Phi model.

## Usage

You have three options to start the system:

1. Start everything at once:
   \`\`\`bash
   ./start-all.sh
   \`\`\`

2. Start components separately:
   
   In first terminal:
   \`\`\`bash
   ./start-ollama-server.sh
   \`\`\`
   
   In second terminal:
   \`\`\`bash
   ./start-model.sh
   \`\`\`

3. Run commands directly:
   
   In first terminal:
   \`\`\`bash
   ollama serve
   \`\`\`
   
   In second terminal:
   \`\`\`bash
   ollama run phi
   \`\`\`

## Troubleshooting

If you encounter issues:
1. Check if Ollama is running: \`pgrep ollama\`
2. Kill existing Ollama processes: \`pkill ollama\`
3. Restart the server: \`./start-ollama-server.sh\`
4. Try running the model again: \`./start-model.sh\`
EOF

# Make all scripts executable
chmod +x start-ollama-server.sh start-model.sh start-all.sh

echo "Setup complete! You can now start Ollama and the Phi model."
echo "To start everything at once, run: ./start-all.sh"
echo "Or start components separately:"
echo "1. In one terminal: ./start-ollama-server.sh"
echo "2. In another terminal: ./start-model.sh"
