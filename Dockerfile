FROM ubuntu AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates build-essential liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /pxe-boot-files
COPY . .
RUN git submodule init \
    && git submodule update --force \
    && make bios efi -j4

ARG base_url="http://\$\${next-server}"
ARG efi_target=efi.ipxe
ARG bios_target=bios.ipxe
RUN make clean bios efi BASE_URL=$base_url BIOS_TARGET=$bios_target EFI_TARGET=$efi_target

FROM alpine:3.12.0 AS server

RUN apk add --no-cache tftp-hpa

WORKDIR /var/tftpboot
COPY --from=builder [ "/pxe-boot-files/out/ipxe.efi", "/pxe-boot-files/out/undionly.kpxe", "./" ]

EXPOSE 69/udp
ENTRYPOINT [ "/usr/sbin/in.tftpd" ]
CMD [ "--verbose", "--foreground", "--address", "0.0.0.0:69", "--secure", "/var/tftpboot" ]
