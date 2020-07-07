################################### SETTINGS ###################################

# Directories
OUT_DIR = out
IPXE_SRC_DIR = ipxe/src

# EFI IPXE boot paths
IPXE_EFI_TARGET = bin-x86_64-efi/ipxe.efi
IPXE_EFI := $(OUT_DIR)/$(notdir $(IPXE_EFI_TARGET))

# BIOS IPXE boot paths
IPXE_BIOS_TARGET = bin/undionly.kpxe
IPXE_BIOS := $(OUT_DIR)/$(notdir $(IPXE_BIOS_TARGET))

##################################### UTIL #####################################

.PHONY: all clean efi bios

################################## BUILD RULES #################################

all: efi bios
efi: $(IPXE_EFI)
bios: $(IPXE_BIOS)

# Copy EFI IPXE boot file
$(IPXE_EFI): $(IPXE_SRC_DIR)/$(IPXE_EFI_TARGET)
	@mkdir -p $(@D)
	cp $< $@

# Copy BIOS IPXE boot file
$(IPXE_BIOS): $(IPXE_SRC_DIR)/$(IPXE_BIOS_TARGET)
	@mkdir -p $(@D)
	cp $< $@

# Build EFI IPXE boot file
$(IPXE_SRC_DIR)/$(IPXE_EFI_TARGET):
	cd $(IPXE_SRC_DIR) && $(MAKE) $(IPXE_EFI_TARGET)

# Build BIOS IPXE boot file
$(IPXE_SRC_DIR)/$(IPXE_BIOS_TARGET):
	cd $(IPXE_SRC_DIR) && $(MAKE) $(IPXE_BIOS_TARGET)

# Clean
clean:
	rm -rf $(OUT_DIR)

# Clean everything
clean-all: clean
	rm -rf $(IPXE_SRC_DIR)/$(dir $(IPXE_EFI_TARGET))
	rm -rf $(IPXE_SRC_DIR)/$(dir $(IPXE_BIOS_TARGET)) && mkdir $(IPXE_SRC_DIR)/$(dir $(IPXE_BIOS_TARGET)) && echo '*' > $(IPXE_SRC_DIR)/$(dir $(IPXE_BIOS_TARGET)).gitignore
