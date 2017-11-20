FROM php:5.6-apache

RUN a2enmod rewrite

RUN set -xe && \
    apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev libxml2-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mbstring mysql mysqli pgsql soap \
    && rm -rf /var/lib/apt/lists/*

ENV MANTIS_VERSION 2.8.0
ENV MANTIS_MD5 39b6c79d7b6379b02103efd97ee43edc
ENV MANTIS_URL http://sourceforge.net/projects/mantisbt/files/mantis-stable/${MANTIS_VERSION}/mantisbt-${MANTIS_VERSION}.tar.gz/download
# http://jaist.dl.sourceforge.net/project/mantisbt/mantis-stable/${MANTIS_VERSION}/mantisbt-${MANTIS_VERSION}.tar.gz
ENV MANTIS_FILE mantisbt.tar.gz

RUN set -xe && curl -fSL ${MANTIS_URL} -o ${MANTIS_FILE} && \
    #echo "${MANTIS_MD5}  ${MANTIS_FILE}" | md5sum -c \
    tar -xz --strip-components=1 -f ${MANTIS_FILE} && \
    rm ${MANTIS_FILE} && \
    chown -R www-data:www-data .

RUN set -xe \
    && ln -sf /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime \
    && echo 'date.timezone = "Asia/Kuala_Lumpur"' > /usr/local/etc/php/php.ini
