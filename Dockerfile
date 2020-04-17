FROM bitnami/magento:2.3.4-debian-10-r65

RUN apt update
RUN apt install -y git
RUN mkdir /root/.ssh/
RUN echo "StrictHostKeyChecking no" >> /root/.ssh/config
RUN composer config --global http-basic.repo.magento.com PUBLIC-ACCESS-KEY PRIVATE-ACCESS-KEY
RUN composer config --global github-oauth.github.com GITHUB-SECRET
WORKDIR /opt/bitnami/magento/htdocs
RUN composer config repositories.m2-custom-product-builder git "git@github.com:Buildateam/m2-custom-product-builder.git"
RUN php -d memory_limit=-1 -f /opt/bitnami/php/bin/composer require buildateam/m2-custom-product-builder:dev-master
