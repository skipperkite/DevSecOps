# -------- Build Stage --------
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# -------- Production Stage --------
FROM node:20-alpine

WORKDIR /app

# Install serve to run static site
RUN npm install -g serve

# Copy only the built static files
COPY --from=builder /app/build ./build

EXPOSE 3000

# Serve the production build
CMD ["serve", "-s", "build", "-l", "3000"]
