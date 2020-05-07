FROM php:7.3-cli

RUN apt-get update && apt-get install -y cron supervisor

RUN mkdir /var/log/cron
RUN touch /var/log/cron/cron.log \
    && chown -R www-data:www-data /var/log/cron

ADD crontab /mycrontab
RUN /usr/bin/crontab -u www-data /mycrontab

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]