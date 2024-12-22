# Set the base image
FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy requirements.txt
COPY requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code, templates, and static folder into the container
COPY . /app/

# Expose the port the app runs on
EXPOSE 5000

# Specify the command to run the app
CMD ["python", "app.py"]
