FROM php:7.3-cli

LABEL "com.github.actions.name"="PHP Lint"
LABEL "com.github.actions.description"="Run Lint Against Pull Request"
LABEL "com.github.actions.icon"="eye"
LABEL "com.github.actions.color"="gray-dark"

LABEL version="1.0.0"
LABEL repository="http://github.com/michaelw90/php-lint"
LABEL homepage="http://github.com/michaelw90/php-lint"
LABEL maintainer="Michael Wright <php-lint@wserver.co.uk>"

RUN apt-get update && apt-get -y install zip unzip

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '8a6138e2a05a8c28539c9f0fb361159823655d7ad2deecb371b04a83966c61223adc522b0189079e3e9e277cd72b8897') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"

RUN mv composer.phar /usr/local/bin/composer

RUN mkdir /phplint && cd /phplint && composer require overtrue/phplint && ln -s /phplint/vendor/bin/phplint /usr/local/bin/phplint

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
