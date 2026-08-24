# ==============================================================================
# CERBERUS DevSecOps — Hardened Dockerfile (Offline Network Fallback)
# ==============================================================================

FROM node:20-alpine AS runner

# 🛡️ SÉCURITÉ 1 : Création d'un utilisateur non-root dédié (UID 10001)
RUN addgroup -g 10001 appgroup && \
    adduser -u 10001 -G appgroup -s /bin/sh -D appuser

WORKDIR /app

# 🛡️ SÉCURITÉ 2 : Copie directe des fichiers et dépendances installées en local
COPY --chown=10001:10001 src/node_modules ./node_modules
COPY --chown=10001:10001 src/server.js ./server.js
COPY --chown=10001:10001 src/package.json ./package.json

# 🛡️ SÉCURITÉ 3 : Passage en utilisateur non-root
USER 10001:10001

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["node", "server.js"]
