FROM tozd/runit

EXPOSE 5432/tcp

RUN apt-get update -q -q && \
 apt-get --yes --force-yes install wget ca-certificates && \
 echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
 wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
 apt-get update -q -q && \
 echo locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8 | debconf-set-selections && \
 echo locales locales/default_environment_locale select en_US.UTF-8 | debconf-set-selections && \
 apt-get --no-install-recommends --yes --force-yes install postgresql-9.4 postgresql-9.4-postgis-2.1 && \
 mkdir -m 700 /var/lib/postgresql.orig && \
 mv /var/lib/postgresql/* /var/lib/postgresql.orig/ && \
 echo 'mappostgres postgres postgres' >> /etc/postgresql/9.4/main/pg_ident.conf && \
 echo 'mappostgres root postgres' >> /etc/postgresql/9.4/main/pg_ident.conf && \
 echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.4/main/pg_hba.conf && \
 echo 'hostssl all all 0.0.0.0/0 md5' >> /etc/postgresql/9.4/main/pg_hba.conf && \
 sed -r -i 's/local\s+all\s+postgres\s+peer/local all postgres peer map=mappostgres/' /etc/postgresql/9.4/main/pg_hba.conf && \
 echo "include_dir = 'conf.d'" >> /etc/postgresql/9.4/main/postgresql.conf && \
 mkdir -p /var/run/postgresql/9.4-main.pg_stat_tmp && \
 chown postgres:postgres /var/run/postgresql/9.4-main.pg_stat_tmp

COPY ./etc /etc
