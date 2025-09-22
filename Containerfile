FROM quay.io/fedora/fedora-minimal:42 AS updated_base

RUN true \
    && microdnf -y update \
    && microdnf -y clean all \
    && true

# temporary container with development tools
FROM updated_base AS builder

RUN true \
    && microdnf -y install rust cargo \
    && true

# build mdbook
RUN true \
    && cargo install --git https://github.com/rust-lang/mdBook.git --root /usr/local mdbook \
    && cargo install --git https://github.com/john-cd/mdbook-utils --root /usr/local mdbook-utils \
    && true

# final container without development tools
FROM updated_base AS mdbook

COPY --from=builder /usr/local/bin/mdbook* /usr/local/bin/

WORKDIR /build/book

ENTRYPOINT [ "/usr/local/bin/mdbook" ]
