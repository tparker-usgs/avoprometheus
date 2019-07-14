FROM prom/prometheus


WORKDIR /app/prometheus
COPY requirements.txt .

RUN apt-get update && apt-get install -y \
  python3-pip 

RUN pip install --no-cache-dir -r requirements.txt
RUN pip freeze > requirements.install

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.8/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=be43e64c45acd6ec4fce5831e03759c89676a0ea

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

ENV CONFIGUPDATER_CONFIG=/tmp/configupdater.yaml
ADD cron-prometheus .
COPY supervisord.conf /etc/supervisor/supervisord.conf

CMD ["supervisord"]
