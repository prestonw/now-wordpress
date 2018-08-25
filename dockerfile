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
  curl -s --fail https://downloads.wordpress.org/plugin/w3-total-cache.0.9.7.zip -o /var/www/w3-total-cache.zip && \
  curl -s --fail https://downloads.wordpress.org/plugin/shortpixel-image-optimiser.4.11.2.zip -o /var/www/shortpixel.zip && \
  curl -s --fail https://dha4w82d62smt.cloudfront.net/items/0N412D053B1F3r1M0L1o/cafe.jpg?X-CloudApp-Visitor-Id=3135154 -o /var/www/day.jpg && \
  curl -s --fail https://dha4w82d62smt.cloudfront.net/items/1N0Z2U0H1y2g0W0V1Y3i/night.jpg?X-CloudApp-Visitor-Id=3135154 -o /var/www/night.jpg && \
  curl -s --fail https://dha4w82d62smt.cloudfront.net/items/0J021s3V3B3t0f3e1m2M/day.jpg?X-CloudApp-Visitor-Id=3135154 -o /var/www/cafe.jpg && \
  
  cd /var/www && \
  unzip -q latest.zip && \
  unzip -q sqlite-integration.zip && \
  unzip -q classic-editor.zip && \
  unzip -q hestia.zip && \
  unzip -q elementor.zip && \
  unzip -q shortpixel.zip && \
  unzip -q pirate-forms.zip && \
  unzip -q wp-mail-smtp.zip && \
  unzip -q w3-total-cache.zip && \
  
  rm -rf *.zip && \

mv sqlite-integration wordpress/wp-content/plugins && \
  mv classic-editor wordpress/wp-content/plugins && \
  mv elementor wordpress/wp-content/plugins && \
  mv pirate-forms wordpress/wp-content/plugins && \
  mv wp-mail-smtp wordpress/wp-content/plugins && \
  mv w3-total-cache wordpress/wp-content/plugins && \
  mv hestia wordpress/wp-content/themes && \
  mv day.jpg wordpress/wp-content/uploads/2018/08/day.jpg && \
  mv night.jpg wordpress/wp-content/uploads/2018/08/night.jpg && \
  mv cafe.jpg wordpress/wp-content/uploads/2018/08/cafe.jpg && \

  cp wordpress/wp-content/plugins/sqlite-integration/db.php wordpress/wp-content/

COPY src/php-fpm.conf /usr/local/etc
COPY src/nginx.conf /etc/nginx
COPY src/run.sh .
COPY src/wp-config.php /var/www/wordpress/

# copy in the sqlite database
COPY data /data

CMD ["./run.sh"]
