# Base PXE Boot Server
Base for PXE boot server based on iPXE network boot firmware. This project just automate the iPXE build process with embedded chain script to load and chain other iPXE script stored on a host on your LAN, according firmware of the PXE client (UEFI or BIOS).

### Building

After clone the project,  initialize git submodules:
```
$ git submodule init
$ git submodule update
```

And then, build with a command like this:
```
$ make all BASE_URL=http://pxe.boot.server EFI_TARGET=path/to/efi.ipxe BIOS_TARGET=path/to/bios.ipxe
```
Where, parameters are:
 - `BASE_URL`: Host URL to fetch iPXE chains scripts. The default value is `tftp://${next-server}`
 - `EFI_TARGET`: Path to iPXE chain script to EFI based hosts. The default value is `boot.ipxe`
 - `BIOS_TARGET`: Path to iPXE chain script to BIOS based hosts. The default value is `boot.ipxe`

> The iPXE supports `tftp://` and `http://` protocols. To more details see [iPXE official documentation](https://ipxe.org/start).

The output files are:
 - `out/ipxe.efi`: Result of iPXE build to EFI boot with `out/efi.ipxe` embedded chain script
 - `out/undionly.kpxe`: Result of iPXE build to BIOS boot with `out/bios.ipxe` embedded chain script

> These files must be placed on the TFTP PXE server and properly setted on your DHCP server.

> The `out/ipxe.efi` no is a signed bootloader, so disable the secure boot on client before boot. To more information see on [iPXE official documentation](https://ipxe.org/appnote/etoken).

### Docker image

For an out-of-the-box solution, check the [Dockerhub image page](https://hub.docker.com/r/edwinostein/pxe-boot-server).

#### Customizing the docker image

The docker image can customized passing the follow `--build-arg` parameters with the `docker build` command:

 - `base_url`: same as `BASE_URL` make paramater
 - `efi_target`: same as `EFI_TARGET` make paramater
 - `bios_target`: same as `BIOS_TARGET` make paramater
 
Example:
```
$ docker build -t pxe-boot-server-custom \
  --build-arg base_url=http://pxe.server.lan \
  --build-arg bios_target=boot/bios.ipxe \
  --build-arg efi_target=boot/efi.ipxe .
```
