FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y sudo
RUN apt-get install -y vim 
RUN apt-get install -y curl
RUN apt-get update 
RUN apt-get install -y apache2
RUN apt-get install -y apache2-utils
RUN apt-get clean 

RUN a2enmod userdir
RUN a2enmod autoindex
RUN a2enmod rewrite
RUN  a2enmod ssl

WORKDIR /var/www/html
RUN mkdir -p /var/www/html/site1.internal/public_html
RUN chown -R $USER:$USER /var/www/html/site1.internal/public_html
RUN sudo chmod -R 755 /var/www/html
WORKDIR /var/www/html/site1.internal/public_html
COPY index.html .


WORKDIR /etc/ssl/certs
COPY site1.internal.crt .
COPY site1.internal.csr .
WORKDIR /etc/ssl/private
COPY site1.internal.key .

WORKDIR /etc/apache2/sites-enabled
COPY site1.conf .

RUN sudo a2dissite 000-default.conf

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

LABEL Maintainer: "jennifer.glover.974@my.csun.edu"
