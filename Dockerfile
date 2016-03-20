FROM ubuntu:14.04

# File Author / Maintainer
MAINTAINER akashjain132 <akashjain132@gmail.com>

# Set Apache User and Group.
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV DEBIAN_FRONTEND=noninteractive

# Add Source for libapache2-mod-fastcgi.
RUN echo deb http://mirrors.digitalocean.com/ubuntu trusty main multiverse >> /etc/apt/sources.list
RUN echo deb http://mirrors.digitalocean.com/ubuntu  trusty-updates main multiverse >> /etc/apt/sources.list
RUN echo deb http://security.ubuntu.com/ubuntu  trusty-security main multiverse >> /etc/apt/sources.list

# Install apache and fpm.
RUN apt-get update
RUN apt-get -y install apache2-mpm-worker
RUN apt-get -y install libapache2-mod-fastcgi php5-fpm php5
RUN a2enmod actions fastcgi alias rewrite
RUN apt-get -y install php5-gd

# Install mysql-server and mysql-client
RUN apt-get -y install mysql-server
RUN apt-get -y install mysql-client


# Install php5-mysql to connect php with mysql
RUN apt-get -y install php5-mysql

# Configure apache.
COPY php-fpm.conf /root
RUN cat /root/php-fpm.conf >> /etc/apache2/conf-available/php-fpm.conf
RUN rm /root/php-fpm.conf
RUN ln -s /etc/apache2/conf-available/php-fpm.conf /etc/apache2/conf-enabled

COPY www.conf /root
RUN cat /root/www.conf >> /etc/php5/fpm/pool.d/www.conf
RUN rm /root/www.conf
RUN service php5-fpm start	

# Copy index.php to test php is working or not.
COPY index.php /var/www/html

# Install php curl
RUN apt-get -y install curl libcurl3 libcurl3-dev php5-curl

# Copy shell file to start apache and php services
COPY start-service.sh /root

CMD ["sh", "/root/start-service.sh"]
