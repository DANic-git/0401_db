ARG DBNAME=db
ARG DBUSER=app
ARG DBPASS=pass

FROM postgres:14 as init

ARG DBNAME
ARG DBUSER
ARG DBPASS

ENV POSTGRES_DB $DBNAME
ENV POSTGRES_USER $DBUSER
ENV POSTGRES_PASSWORD $DBPASS

COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
RUN ["sed", "-i", "s/exec \"$@\"/echo \"skipping...\"/", "/usr/local/bin/docker-entrypoint.sh"]

RUN /usr/local/bin/docker-entrypoint.sh postgres



FROM postgres:14 as final

ARG DBNAME
ARG DBUSER
ARG DBPASS

ENV POSTGRES_DB $DBNAME
ENV POSTGRES_USER $DBUSER
ENV POSTGRES_PASSWORD $DBPASS

COPY --from=init $PGDATA $PGDATA

EXPOSE 5432
CMD ["postgres"]