# Use the official Nginx base image from Docker Hub
FROM nginx:latest

# Copy your custom Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
