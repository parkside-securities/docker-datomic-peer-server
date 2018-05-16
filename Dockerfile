FROM clojure:lein-alpine

MAINTAINER Kenji Nakamura "knakamura@parksidesecurities.com"

ENV DATOMIC_VERSION 0.9.5697
ENV DATOMIC_HOME /opt/datomic-pro-$DATOMIC_VERSION

RUN apk add --no-cache unzip curl

# Datomic Pro Starter as easy as 1-2-3
# 1. Create a .credentials file containing user:pass
# for downloading from my.datomic.com
ONBUILD ADD .credentials /tmp/.credentials

# 2. Make sure to have a config/ folder in the same folder as your
# Dockerfile containing the transactor property file you wish to use
ONBUILD RUN curl -u $(cat /tmp/.credentials) -SL https://my.datomic.com/repo/com/datomic/datomic-pro/$DATOMIC_VERSION/datomic-pro-$DATOMIC_VERSION.zip -o /tmp/datomic.zip \
  && unzip /tmp/datomic.zip -d /opt \
  && rm -f /tmp/datomic.zip

WORKDIR $DATOMIC_HOME

# 3. Provide a CMD with value for option -a and for option -d as many as required
# e.g. CMD ["-a", "ak,ys", "-d", "mbrainz,datomic:dev://datomicdb:4334/mbrainz-1968-1973"]
ENTRYPOINT ["bin/run", "-m", "datomic.peer-server", "-h", "0.0.0.0", "-p", "8998"]

EXPOSE 8998
