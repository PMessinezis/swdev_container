FROM php:7.4-cli as swdev
ENV DEBIAN_FRONTEND=noninteractive

# Or your actual UID, GID on Linux if not the default 1000
ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG PHP_VER=7.4
ENV TZ=Europe/London
SHELL ["/bin/bash" , "-c"]
RUN echo A
RUN apt-get update
RUN apt-get -y install --no-install-recommends apt-utils dialog 2>&1 

RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
RUN php -v

RUN apt-get -y install curl git openssl iproute2 procps iproute2 lsb-release unzip zip  gettext sqlite3
RUN apt-get install -y zlib1g-dev libzip-dev libxml2-dev

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN docker-php-ext-configure zip 
RUN docker-php-ext-install zip pdo pdo_mysql gettext calendar mysqli 


RUN apt-get install -y gettext locales
RUN sed -i -e 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen
RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
RUN sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
RUN sed -i -e 's/# it_IT.UTF-8 UTF-8/it_IT.UTF-8 UTF-8/' /etc/locale.gen
RUN sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen


# SETUP WORKDIR
RUN mkdir /workspace
VOLUME /workspace
WORKDIR /workspace


# SETUP USER
RUN apt-get install -y sudo
RUN groupadd --gid $USER_GID $USERNAME 
RUN useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME 
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME 
RUN chmod 0440 /etc/sudoers.d/$USERNAME 

#install nodejs/npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

#prepare for vscode
RUN chmod -R 777 /root 
RUN chown -R $USERNAME /root


RUN composer global selfupdate
RUN su - $USERNAME -c "composer global require hirak/prestissimo"
RUN su - $USERNAME -c "composer global require laravel/installer"

#install vim
RUN apt-get -y install vim

#install php-mysql and mysql client
RUN apt-get -y install default-mysql-client-core


USER $USERNAME:$USERNAME

ENTRYPOINT ["bash" , "-c" , "while true; do sleep 5; done"] 
