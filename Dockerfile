# Use an official Node.js runtime as a parent image
FROM node:10 # Set the working directory to /app
WORKDIR /app # Copy the package.json and package-lock.json files to the container
COPY package*.json ./ # Install dependencies
RUN npm install # Copy the rest of the application files to the container
COPY . . # Set environment variables
ENV PORT=3000 # Expose port 3000 for the app to listen on
EXPOSE 3000 # Start the application
CMD [ "npm", "start" ]
