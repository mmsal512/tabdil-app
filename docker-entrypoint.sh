#!/bin/bash
# =============================================================================
# Tabdil Flutter Web - Docker Entrypoint Script
# Generates config.json from Docker secrets at container startup
# =============================================================================

set -e

CONFIG_OUTPUT="/usr/share/nginx/html/assets/config.json"
SECRET_FILE="/run/secrets/app_secrets"

echo "🚀 Tabdil Web Container Starting..."

# -----------------------------------------------------------------------------
# Read secrets from Docker secret file (YAML format)
# -----------------------------------------------------------------------------
if [ -f "$SECRET_FILE" ]; then
    echo "📦 Reading secrets from Docker secrets..."
    
    # Parse YAML using grep/sed (lightweight, no extra dependencies)
    SUPABASE_URL=$(grep -E "^SUPABASE_URL:" "$SECRET_FILE" | sed 's/SUPABASE_URL: *//' | tr -d '"' | tr -d "'")
    SUPABASE_ANON_KEY=$(grep -E "^SUPABASE_ANON_KEY:" "$SECRET_FILE" | sed 's/SUPABASE_ANON_KEY: *//' | tr -d '"' | tr -d "'")
    OPEN_EXCHANGE_API_KEY=$(grep -E "^OPEN_EXCHANGE_API_KEY:" "$SECRET_FILE" | sed 's/OPEN_EXCHANGE_API_KEY: *//' | tr -d '"' | tr -d "'")
    
else
    echo "⚠️  No secret file found, using environment variables..."
    
    # Fallback to environment variables
    SUPABASE_URL="${SUPABASE_URL:-}"
    SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}"
    OPEN_EXCHANGE_API_KEY="${OPEN_EXCHANGE_API_KEY:-}"
fi

# Get APP_ENV from environment (set in docker-compose)
APP_ENV="${APP_ENV:-production}"

# -----------------------------------------------------------------------------
# Use defaults if secrets not provided (for demo/testing)
# -----------------------------------------------------------------------------
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
    echo "⚠️  No secrets provided, using built-in defaults..."
    SUPABASE_URL="${SUPABASE_URL:-https://hwhmrgplcbhyzfjnxymi.supabase.co}"
    SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3aG1yZ3BsY2JoeXpmam54eW1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ4NDA2MDksImV4cCI6MjA4MDQxNjYwOX0.K9GFrpKEP9FVM_7h5VenXRABGQVNi90s4wB_LKSpfF0}"
    OPEN_EXCHANGE_API_KEY="${OPEN_EXCHANGE_API_KEY:-d81f75e2194e486da9e3cc870c183f9b}"
fi

if [ -z "$OPEN_EXCHANGE_API_KEY" ]; then
    echo "⚠️  WARNING: OPEN_EXCHANGE_API_KEY is not set. API rates may not work."
fi

# -----------------------------------------------------------------------------
# Generate config.json
# -----------------------------------------------------------------------------
echo "📝 Generating config.json..."

cat > "$CONFIG_OUTPUT" << EOF
{
  "SUPABASE_URL": "${SUPABASE_URL}",
  "SUPABASE_ANON_KEY": "${SUPABASE_ANON_KEY}",
  "OPEN_EXCHANGE_API_KEY": "${OPEN_EXCHANGE_API_KEY}",
  "APP_ENV": "${APP_ENV}",
  "BUILD_TIME": "$(date -Iseconds)"
}
EOF

# Set proper permissions
chmod 644 "$CONFIG_OUTPUT"

echo "✅ config.json generated successfully!"
echo "   Environment: ${APP_ENV}"
echo "   Supabase URL: ${SUPABASE_URL}"

# -----------------------------------------------------------------------------
# Start nginx
# -----------------------------------------------------------------------------
echo "🌐 Starting nginx..."
exec "$@"
