FROM httpd:2.4
LABEL maintainer="Juan Pablo Roca <rocajp@gmail.com>"

COPY ./hello-world-app/index.html /usr/local/apache2/htdocs/
