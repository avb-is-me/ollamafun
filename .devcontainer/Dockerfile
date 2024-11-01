# Install Ollama CLI
RUN curl -fsSL https://ollama.com/download | sh

# Set up a workspace directory
WORKDIR /workspace

# Copy any project files into the container (optional)
COPY . /workspace

# Install Python dependencies if required (comment out if unnecessary)
# RUN pip install -r requirements.txt

CMD ["bash"]
