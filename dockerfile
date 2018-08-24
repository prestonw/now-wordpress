FROM zeit/wait-for:0.2 as wait

FROM php:7-fpm-alpine
COPY --from=wait /bin/wait-for /bin/wait-for
RUN apk add --no-cache curl nginx bash
RUN curl -s --fail https://wordpress.org/latest.zip -o /var/www/latest.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/sqlite-integration.1.8.1.zip -o /var/www/sqlite-integration.zip && \
  curl -s --fail https://downloads.wordpress.org/theme/hestia.1.1.86.zip -o /var/www/hestia.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/classic-editor.0.4.zip -o /var/www/classic-editor.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/elementor.2.1.8.zip -o /var/www/elementor.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/pirate-forms.zip -o /var/www/pirate-forms.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/wp-mail-smtp.zip -o /var/www/wp-mail-smtp.zip && \
  cd /var/www && \
  unzip -q latest.zip && \
  unzip -q sqlite-integration.zip && \
  unzip -q classic-editor.zip && \
  unzip -q hestia.zip && \
  unzip -q elementor.zip && \
  unzip -q pirate-forms.zip && \
  unzip -q wp-mail-smtp.zip && \
  rm -rf *.zip && \
  mv sqlite-integration wordpress/wp-content/plugins && \
  mv classic-editor wordpress/wp-content/plugins && \
  mv elementor wordpress/wp-content/plugins && \
  mv pirate-forms wordpress/wp-content/plugins && \
  mv wp-mail-smtp wordpress/wp-content/plugins && \
  mv hestia wordpress/wp-content/themes && \
  cp wordpress/wp-content/plugins/sqlite-integration/db.php wordpress/wp-content/

COPY src/php-fpm.conf /usr/local/etc
COPY src/nginx.conf /etc/nginx
COPY src/run.sh .
COPY src/wp-config.php /var/www/wordpress/

# copy in the sqlite database
COPY data /data

CMD ["./run.sh"]
