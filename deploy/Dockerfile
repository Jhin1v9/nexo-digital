FROM node:20-alpine

WORKDIR /app

ARG JWT_SECRET

# Copiar package.json raiz para que luna-config detecte o monorepo
COPY package.json ./

# Instalar dependências do sistema necessárias para bcrypt, pg-native e playwright
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    postgresql-client \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont

# Copiar backend e instalar dependências
COPY dashboard/backend/package.json ./dashboard/backend/
RUN cd dashboard/backend && npm install && \
    ln -sf /app/dashboard/backend/node_modules /app/node_modules

# Copiar frontend buildado para pasta public do backend
COPY dashboard/frontend/dist ./dashboard/backend/public

# Copiar luna-web buildado
COPY luna-kernel/luna-web/dist ./luna-kernel/luna-web/dist

# Copiar código fonte do backend
COPY dashboard/backend/server.js ./dashboard/backend/
COPY dashboard/backend/luna-server.js ./dashboard/backend/
COPY dashboard/backend/data ./dashboard/backend/data
COPY dashboard/backend/routes ./dashboard/backend/routes
COPY dashboard/backend/services ./dashboard/backend/services
COPY dashboard/backend/scripts ./dashboard/backend/scripts
COPY dashboard/backend/migrations ./dashboard/backend/migrations
COPY dashboard/backend/*.cjs ./dashboard/backend/
COPY dashboard/backend/*.js ./dashboard/backend/
COPY dashboard/backend/tsconfig.json ./dashboard/backend/

# Copiar agentes usados pelo backend (require '../agents/...')
COPY dashboard/agents ./dashboard/agents

# Copiar configuração do Luna Kernel (tudo, pois extensões/routes podem depender)
COPY luna-kernel ./luna-kernel

# Garantir .env do luna-kernel (evita erro se arquivo não existir localmente)
RUN if [ ! -f /app/luna-kernel/.env ]; then \
      cp /app/luna-kernel/.env.example /app/luna-kernel/.env 2>/dev/null || \
      echo "JWT_SECRET=${JWT_SECRET}" > /app/luna-kernel/.env; \
    fi

# Garantir users.json para autenticação do Luna Web
RUN mkdir -p /app/dashboard/backend/data && \
    echo '{"users":{"abner":{"name":"Abner","role":"Admin","color":"#3742fa","passwordHash":"$2b$10$KnJlQTb9opcUu2EVPkw56ez410v9.LNBFLNGV200EiXskvMjjnUla"},"nonoke":{"name":"Nonoke","role":"Admin","color":"#3742fa","passwordHash":"$2b$10$KnJlQTb9opcUu2EVPkw56ez410v9.LNBFLNGV200EiXskvMjjnUla"},"elias":{"name":"Elias","role":"Admin","color":"#3742fa","passwordHash":"$2b$10$KnJlQTb9opcUu2EVPkw56ez410v9.LNBFLNGV200EiXskvMjjnUla"}}}' \
    > /app/dashboard/backend/data/users.json

# Copiar supervisord config
COPY deploy/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Instalar supervisor e garantir diretório de logs
RUN apk add --no-cache supervisor && mkdir -p /var/log/supervisor /app/logs

EXPOSE 3501 3601

ENV NODE_ENV=production
ENV PORT=3501
ENV LUNA_PORT=3601
ENV BIND_IP=0.0.0.0

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
