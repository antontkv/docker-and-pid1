FROM python:3.11.1-bullseye

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends tini; \
	rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
