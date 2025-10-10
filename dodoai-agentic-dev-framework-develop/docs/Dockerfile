# Use the Node.js 18 image as a parent image
FROM node:20

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages
RUN npm install --legacy-peer-deps
RUN npm run build
# Make port 3000 available to the world outside this container
EXPOSE 3000

# Run Docusaurus
CMD ["npm", "run", "serve"]
