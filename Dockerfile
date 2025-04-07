# Build Stage
FROM docker.io/node:20.10.0 as build

# Arbeitsverzeichnis festlegen
WORKDIR /app

# Package-Dateien kopieren
COPY package.json yarn.lock ./

# Yarn installieren und Abhängigkeiten installieren
RUN corepack enable && yarn install --frozen-lockfile

# Projektdateien kopieren
COPY . .

# Angular App bauen
RUN yarn prod

# Deployment Stage
FROM docker.io/nginx:stable-alpine

# NGINX Konfiguration für Angular Single-Page Application
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Build-Ergebnis von der Build-Stage in das NGINX Webroot-Verzeichnis kopieren
COPY --from=build /app/dist/*/. /usr/share/nginx/html/

# Port 80 freigeben
EXPOSE 80

# NGINX starten
CMD ["nginx", "-g", "daemon off;"]
