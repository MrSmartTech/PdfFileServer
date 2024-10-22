# Verwende das Nginx-Image
FROM nginx:latest

# Kopiere den Inhalt des 'www'-Ordners in das Standardverzeichnis von Nginx
COPY www /usr/share/nginx/html/

# Exponiere den Port 80
EXPOSE 80
