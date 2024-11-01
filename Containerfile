FROM quay.io/fedora/fedora-minimal:latest AS updated_base

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
    && true

# final container without development tools
FROM updated_base AS mdbook

COPY --from=builder /usr/local/bin/mdbook /usr/local/bin/mdbook

WORKDIR /build/book

ENTRYPOINT [ "/usr/local/bin/mdbook" ]
