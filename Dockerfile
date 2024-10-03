# Step 1: Build the Angular app in a Node.js container
FROM node:18-alpine AS build

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the Angular app
RUN ls -al && \ 
    npm run build --prod && \
    pwd && \
    ls -al dist

# Step 2: Serve the app using Nginx
FROM nginx:alpine

# Copy the build output from the previous step to Nginx's HTML directory
COPY --from=build /usr/src/app/dist/saegiscontainers/* /usr/share/nginx/html
RUN ls -al /usr/share/nginx/html

# Expose port 80 to the host
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]

