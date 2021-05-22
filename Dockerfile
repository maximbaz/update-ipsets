FROM alpine

RUN apk add --no-cache bash ipset iproute2 curl unzip grep gawk lsof

ENV IPRANGE_VERSION 1.0.4
ENV FIREHOL_VERSION 3.1.7

# Installing iprange
RUN apk add --no-cache --virtual .iprange_builddep autoconf automake make gcc musl-dev && \
    curl -L https://github.com/firehol/iprange/releases/download/v$IPRANGE_VERSION/iprange-$IPRANGE_VERSION.tar.gz | tar zvx -C /tmp && \
    cd /tmp/iprange-$IPRANGE_VERSION && \
    ./configure --prefix= --disable-man && \
    make && \
    make install && \
    cd && \
    rm -rf /tmp/iprange-$IPRANGE_VERSION && \
    apk del .iprange_builddep

# Installing firehol
RUN apk add --no-cache --virtual .firehol_builddep autoconf automake make && \
    curl -L https://github.com/firehol/firehol/releases/download/v$FIREHOL_VERSION/firehol-$FIREHOL_VERSION.tar.gz | tar zvx -C /tmp && \
    cd /tmp/firehol-$FIREHOL_VERSION && \
    ./autogen.sh && \
    ./configure --prefix= --disable-doc --disable-man && \
    make && \
    make install && \
    cp contrib/ipset-apply.sh /bin/ipset-apply && \
    cd && \
    rm -rf /tmp/firehol-$FIREHOL_VERSION && \
    apk del .firehol_builddep

ADD ipset-enable /bin/ipset-enable
ADD entrypoint /bin/entrypoint

VOLUME ["/etc/firehol/ipsets"]

ENTRYPOINT ["/bin/entrypoint"]
