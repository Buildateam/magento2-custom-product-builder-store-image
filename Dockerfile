FROM bitnami/magento:2.3.5-debian-10-r82

RUN apt update
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
WORKDIR /opt/bitnami/magento/htdocs
RUN composer config --global http-basic.repo.magento.com PUBLIC-ACCESS-KEY PRIVATE-ACCESS-KEY
RUN composer config --global github-oauth.github.com GITHUB-SECRET
RUN composer config repositories.Buildateam-m2-custom-product-builder vcs https://github.com/Buildateam/m2-custom-product-builder.git
RUN COMPOSER_MEMORY_LIMIT=-1 composer require buildateam/m2-custom-product-builder:dev-master
