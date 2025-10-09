# Stage 1: Build the Flutter web app
# Use a specific Flutter version to ensure consistency
FROM cirrusci/flutter:3.10.0 AS build

WORKDIR /app

# Copy the project files into the container
COPY . .

# Get Flutter dependencies
RUN flutter pub get

# Build the web application for release
RUN flutter build web --release


# Stage 2: Serve the built files with Nginx
# Use a lightweight web server image
FROM nginx:stable-alpine

# Copy the built Flutter app from the 'build' stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80 (the default HTTP port)
EXPOSE 80

# The command to start the Nginx server
CMD ["nginx", "-g", "daemon off;"]