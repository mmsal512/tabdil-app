# =============================================================================
# Tabdil Flutter Web - Production Dockerfile
# Multi-stage build: Flutter SDK -> nginx
# =============================================================================

# -----------------------------------------------------------------------------
# Stage 1: Build Flutter Web Application
# -----------------------------------------------------------------------------
FROM ghcr.io/cirruslabs/flutter:stable AS builder

# Set working directory
WORKDIR /app

# Copy pubspec files first for better caching
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the source code
COPY . .

# Build Flutter Web (production, release mode)
# Note: We do NOT embed secrets here - config.json is generated at runtime
RUN flutter build web --release

# -----------------------------------------------------------------------------
# Stage 2: Production nginx Server
# -----------------------------------------------------------------------------
FROM nginx:alpine AS production

# Install envsubst for template processing (comes with gettext)
RUN apk add --no-cache gettext bash

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy built Flutter web app from builder stage
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copy entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Make entrypoint executable
RUN chmod +x /docker-entrypoint.sh

# Create directory for config file
RUN mkdir -p /usr/share/nginx/html/assets

# Expose port 80
EXPOSE 80

# Health check - use simple file check or curl
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD wget -q --spider http://127.0.0.1:80/ || exit 1

# Use custom entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]

# Default command
CMD ["nginx", "-g", "daemon off;"]
