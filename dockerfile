FROM zeit/wait-for:0.2 as wait

FROM php:7-fpm-alpine
COPY --from=wait /bin/wait-for /bin/wait-for
RUN apk add --no-cache curl nginx bash
RUN curl -s --fail https://wordpress.org/latest.zip -o /var/www/latest.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/sqlite-integration.1.8.1.zip -o /var/www/sqlite-integration.zip && \
  curl -s --fail https://downloads.wordpress.org/theme/hestia.1.1.86.zip -o /var/www/hestia.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/classic-editor.0.4.zip -o /var/www/classic-editor.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/elementor.2.1.8.zip -o /var/www/elementor.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/shortpixel-image-optimiser.4.11.2.zip -o /var/www/shortpixel-image-optimiser.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/pirate-forms.zip -o /var/www/pirate-forms.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/wp-mail-smtp.zip -o /var/www/wp-mail-smtp.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/w3-total-cache.0.9.7.zip -o /var/www/w3-total-cache.zip && \
  curl -s --fail http://host.preston.ie/images.zip -o /var/www/images.zip && \
  curl -s --fail https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
  cd /var/www && \
  unzip -q latest.zip && \
  unzip -q sqlite-integration.zip && \
  unzip -q classic-editor.zip && \
  unzip -q hestia.zip && \
  unzip -q elementor.zip && \
  unzip -q shortpixel-image-optimiser.zip && \
  unzip -q pirate-forms.zip && \
  unzip -q wp-mail-smtp.zip && \
  unzip -q w3-total-cache.zip && \
  unzip -q images.zip && \
  rm -rf *.zip && \
  mv sqlite-integration wordpress/wp-content/plugins && \
  mv classic-editor wordpress/wp-content/plugins && \
  mv elementor wordpress/wp-content/plugins && \
  mv shortpixel-image-optimiser wordpress/wp-content/plugins && \
  mv pirate-forms wordpress/wp-content/plugins && \
  mv wp-mail-smtp wordpress/wp-content/plugins && \
  mv w3-total-cache wordpress/wp-content/plugins && \
  mv hestia wordpress/wp-content/themes && \
  rm wordpress/wp-content/plugins/hello.php && \
  cp wordpress/wp-content/plugins/sqlite-integration/db.php wordpress/wp-content/ && \
  mkdir -p wordpress/wp-content/uploads/2018/08 && \
  mkdir -p /var/ssl && \
  mv *.jpg wordpress/wp-content/uploads/2018/08
  
COPY src/php-fpm.conf /usr/local/etc
COPY src/nginx.conf /etc/nginx
COPY src/run.sh .
COPY src/wp-config.php /var/www/wordpress/
COPY ssl/server.crt /var/ssl/server.crt
COPY ssl/server.key /var/ssl/server.key

# copy in the sqlite database
COPY data /data

# run updates with WP-CLI
RUN chmod +x /usr/local/bin/wp && \
  cd /var/www/wordpress && \
  wp plugin update --all --allow-root && \
  wp core language update --allow-root && \
  wp transient delete --all --allow-root

CMD ["./run.sh"]