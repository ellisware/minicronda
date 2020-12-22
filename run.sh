#!/bin/sh

# Start the run once job.
echo "Docker container has been started"
# Setup a cron schedule
# * * * * * = Every Minute
# */2 * * * * = Every Two Minutes
echo "*/2 * * * * export USERNAME=$USERNAME; export PASSWORD=$PASSWORD; export DOMAIN=$DOMAIN;  /usr/local/bin/cron.sh >> /var/log/cron.log 2>&1
# This extra line makes it a valid cron" > scheduler.txt
crontab scheduler.txt
cron -f
