# base will be UBUNTU
# we will add ( or install ??? )  PHP and COMPOSER
# we will also need nodejs/npm
# we will also need git 
# and will link ~/workspace with /workspace
# what else ???

# we will also need a mysql/mariadb and phpmyadmin - in a separate container ?


FROM ubuntu as swdev
ENV DEBIAN_FRONTEND=noninteractive

# Or your actual UID, GID on Linux if not the default 1000
ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG PHP_VER=7.2
ENV TZ=Europe/London
SHELL ["/bin/bash" , "-c"]
RUN apt-get update
RUN apt-get -y install --no-install-recommends apt-utils dialog 2>&1 

#install PHP
RUN apt-get install -y php${PHP_VER}-cli 
RUN php -v
RUN apt-get install -y php${PHP_VER}-mbstring 
RUN apt-get install -y php${PHP_VER}-zip 
RUN apt-get install -y php${PHP_VER}-xml
RUN apt-get install -y php${PHP_VER}-curl

#install git
RUN apt-get -y install curl git openssl unzip zip 

#install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && chmod +x /usr/bin/composer 

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

#install laravel
RUN su - $USERNAME -c "composer global selfupdate"
RUN su - $USERNAME -c "composer global require hirak/prestissimo"
RUN su - $USERNAME -c "composer global require laravel/installer"

#install nodejs/npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

USER $USERNAME:$USERNAME

ENTRYPOINT ["bash" , "-c" , "while true; do sleep 5; done"] 