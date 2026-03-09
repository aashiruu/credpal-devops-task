# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production

# Stage 2: Final Image
FROM node:18-alpine
WORKDIR /app
# Best Practice: Non-root user
RUN addgroup -S nodegroup && adduser -S nodeuser -G nodegroup
COPY --from=builder /app/node_modules ./node_modules
COPY . .
USER nodeuser
EXPOSE 3000
CMD ["node", "app.js"]
