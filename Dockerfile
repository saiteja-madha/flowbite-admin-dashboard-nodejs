# Use the official Node.js image as the base image for building
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies including dev dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application using Webpack
RUN npm run build

# Use the official Node.js image as the base image for running
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=builder /app/content ./content
COPY --from=builder /app/data ./data
COPY --from=builder /app/layouts ./layouts
COPY --from=builder /app/static ./static
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/app.js ./

# Install only production dependencies
RUN npm install --only=production

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
