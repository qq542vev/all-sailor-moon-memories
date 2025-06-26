### File: Dockerfile
##
## Dockerイメージを作成する。
##
## Usage:
##
## ------ Text ------
## docker image build -f Dockerfile
## ------------------
##
## Metadata:
##
##   id - 4b6774fa-550f-46ca-ad8b-8b8499070fb6
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.0
##   created - 2025-06-25
##   modified - 2025-06-26
##   copyright - Copyright (C) 2025-2025 qq542vev. All rights reserved.
##   license - <GNU GPLv3 at https://www.gnu.org/licenses/gpl-3.0.txt>
##   conforms-to - <https://docs.docker.com/reference/dockerfile/>
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/all-sailor-moon-memories>
##   * <Bag report at https://github.com/qq542vev/all-sailor-moon-memories/issues>

ARG BASE="ghcr.io/mikenye/docker-youtube-dl:latest"

FROM ${BASE}

ARG BASE
ARG TITLE="All Sailor Moon Memories"
ARG VERSION="1.0.0"
ARG WORKDIR="/work"

LABEL org.opencontainers.image.title="${TITLE}"
LABEL org.opencontainers.image.description="${TITLE}のビルド・テスト用のイメージ。"
LABEL org.opencontainers.image.authors="qq542vev <https://purl.org/meta/me/>"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.url="https://github.com/qq542vev/all-sailor-moon-memories"
LABEL org.opencontainers.image.license="GPL-3.0-only"
LABEL org.opencontainers.image.base.name="${BASE}"

ENV LANG="C"
ENV LC_ALL="C"
ENV TZ="UTC0"

WORKDIR ${WORKDIR}

RUN \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		make mediainfo && \
	apt-get clean && \
	rm -rf /var/lib/apt-get/lists/*

ENTRYPOINT []
CMD ["bash"]
