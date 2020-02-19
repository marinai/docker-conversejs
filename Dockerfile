FROM node:13-buster AS builder

ARG CONVERSEJS_VERSION=v6.0.1

RUN git clone https://github.com/conversejs/converse.js.git /tmp/converse.js && \
    cd /tmp/converse.js/ && \
    git checkout $CONVERSEJS_VERSION && \
    make dist

FROM nginx:1.17

COPY --from=builder /tmp/converse.js/dist/ /var/www/
COPY --from=builder /tmp/converse.js/sounds/ /var/www/sounds/
# workaround for release 6.0.1
COPY --from=builder /tmp/converse.js/sass/webfonts/ /var/www/webfonts/
COPY index.default.html /var/www/

RUN rm /etc/nginx/conf.d/*.conf
COPY site.conf /etc/nginx/conf.d/
EXPOSE 8080

COPY entrypoint.sh /usr/local/sbin/entrypoint.sh
ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
