FROM bitsler/wallet-base:focal

ENV HOME /dashcoin

ENV USER_ID 1000
ENV GROUP_ID 1000

RUN groupadd -g ${GROUP_ID} dashcoin \
  && useradd -u ${USER_ID} -g dashcoin -s /bin/bash -m -d /dashcoin dashcoin \
  && set -x \
  && apt-get update -y \
  && apt-get install -y curl gosu \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG version=0.14.0.3
ENV DASH_VERSION=$version

RUN curl -sL https://github.com/dashpay/dash/releases/download/v${DASH_VERSION}/dashcore-${DASH_VERSION}-x86_64-linux-gnu.tar.gz | tar xz --strip=2 -C /usr/local/bin

ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/dash_oneshot

VOLUME ["/dashcoin"]

EXPOSE 9998 9999

WORKDIR /dashcoin

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["dash_oneshot"]
