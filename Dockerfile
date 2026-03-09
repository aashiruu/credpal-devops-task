# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production

# Stage 2: Final Image
FROM node:18-alpine
WORKDIR /app

# Install curl AND create user in ONE clean layer
RUN apk add --no-cache curl && \
    addgroup -S nodegroup && adduser -S nodeuser -G nodegroup

COPY --from=builder /app/node_modules ./node_modules
COPY . .

USER nodeuser

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3000/health || exit 1

EXPOSE 3000
CMD ["node", "app.js"]
