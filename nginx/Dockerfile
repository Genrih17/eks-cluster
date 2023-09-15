# Use the official nginx base image from Docker Hub
FROM nginx:latest

# Copy your custom nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html
# Expose ports
EXPOSE 80

# Start nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
