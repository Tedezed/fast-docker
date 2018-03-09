FROM docker:stable-dind
MAINTAINER Juan Manuel Torres <juanmanuel.torres@aventurabinaria.es>

ENV SONAR_SCANNER_VERSION 3.0.3.778-linux
ENV SONARDIR /var/opt/sonar-scanner-${SONAR_SCANNER_VERSION}
ENV SONARBIN ${SONARDIR}/bin/sonar-scanner

RUN cd / && apk update \
	&& apk add --update bash wget git ca-certificates openssl \
	&& apk add python python-dev py-pip zip curl make \
	&& pip install git-aggregator

RUN apk add openjdk8-jre

RUN cd /var/opt/ \
	&& wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz \
	&& tar zxf google-cloud-sdk.tar.gz \
	&& ./google-cloud-sdk/install.sh --usage-reporting=false \
	&& rm -rf google-cloud-sdk.tar.gz

RUN ln -s /var/opt/google-cloud-sdk/bin/gcloud /usr/local/bin/ \
	&& ln -s /var/opt/google-cloud-sdk/lib/ /usr/local/lib/ \
	&& gcloud --quiet components update

RUN cd /var/opt/ \
	&& wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
    && unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
    && rm sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip \
    && rm -rf ${SONARDIR}/jre \
    && sed -i -e 's/use_embedded_jre=true/use_embedded_jre=false/' ${SONARBIN} ${SONARBIN}-debug \
    && ln -s ${SONARBIN} /usr/bin/sonar-scanner \
    && apk del wget

ADD executables/* /usr/bin/