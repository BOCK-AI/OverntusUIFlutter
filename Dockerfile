# Stage 1: Build the Flutter web app using the OFFICIAL Google Dart image
FROM dart:stable AS build

# Install Flutter and other necessary tools
RUN apt-get update && apt-get install -y curl git unzip
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:${PATH}"
RUN flutter precache --web

# Set up the application directory
WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the application code
COPY . .

# IMPORTANT: Define the build argument for the API URL
ARG API_BASE_URL
RUN flutter build web --release --dart-define=API_BASE_URL=${API_BASE_URL}


# Stage 2: Serve the built files with Nginx
FROM nginx:stable-alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]