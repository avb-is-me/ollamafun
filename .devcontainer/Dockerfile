# Use a base image with Python if required by your project
FROM python:3.9-slim

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama CLI
RUN curl -fsSL https://ollama.com/download | sh

# Set up a workspace directory
WORKDIR /workspace

# Copy any project files into the container (optional)
COPY . /workspace

# Install Python dependencies if required (comment out if unnecessary)
# RUN pip install -r requirements.txt

CMD ["bash"]
