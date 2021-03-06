# dir declaration
LIB_MCUBOOT_DIR = $(LIBRARIES_ROOT)/mcuboot

LIB_MCUBOOT_ASMSRCDIR	= $(LIB_MCUBOOT_DIR) $(LIB_MCUBOOT_DIR)/bootutil/src
LIB_MCUBOOT_CSRCDIR		= $(LIB_MCUBOOT_DIR) $(LIB_MCUBOOT_DIR)/bootutil/src
LIB_MCUBOOT_INCDIR		= $(LIB_MCUBOOT_DIR)/bootutil/include $(LIB_MCUBOOT_DIR)/include


# the dir to generate objs
LIB_MCUBOOT_OBJDIR = $(OUT_DIR)/library/mcuboot

# find all the srcs in the target dirs
LIB_MCUBOOT_CSRCS = $(call get_csrcs, $(LIB_MCUBOOT_CSRCDIR))
LIB_MCUBOOT_ASMSRCS = $(call get_asmsrcs, $(LIB_MCUBOOT_ASMSRCDIR))

# get object files
LIB_MCUBOOT_COBJS = $(call get_relobjs, $(LIB_MCUBOOT_CSRCS))
LIB_MCUBOOT_ASMOBJS = $(call get_relobjs, $(LIB_MCUBOOT_ASMSRCS))
LIB_MCUBOOT_OBJS = $(LIB_MCUBOOT_COBJS) $(LIB_MCUBOOT_ASMOBJS)

# get dependency files
LIB_MCUBOOT_DEPS = $(call get_deps, $(LIB_MCUBOOT_OBJS))

# sign tools
LIB_MCUBOOT_SCRIPT_DIR = $(LIB_MCUBOOT_DIR)/scripts
MCUBOOT_SIGNED_IMAGE = $(OUT_DIR)/signed_$(APPL)
MCUBOOT_SIGNED_RSAKEY ?= $(LIB_MCUBOOT_DIR)/root-rsa-2048.pem
MCUBOOT_SIGN = $(LIB_MCUBOOT_SCRIPT_DIR)/imgtool.py
MCUBOOT_SIGN_OPT = sign --key $(MCUBOOT_SIGNED_RSAKEY) \
						--header-size $(IMAGE_HEADER_SIZE) \
						--align $(IMAGE_FLASH_ALIGN) \
						--version 1.2 \
						-S $(IMAGE_SLOT_SIZE) \
						$(APPL_FULL_NAME).bin $(MCUBOOT_SIGNED_IMAGE).bin

# compile options only valid in this library
LIB_MCUBOOT_DEFINES += -DLIB_MCUBOOT -DMCUBOOT_VALIDATE_SLOT0 -DMCUBOOT_USE_FLASH_AREA_GET_SECTORS \
						-DMCUBOOT_SIGN_RSA -DMBEDTLS_CONFIG_FILE=\"config-boot.h\"

# generate library
LIB_LIB_MCUBOOT = $(OUT_DIR)/libmcuboot.a

ifeq ($(USE_MCUBOOT), 1)
# specify in the bootloader
LIB_MCUBOOT_DEFINES += -DEMBARC_USE_MCUBOOT
endif

# library generation rule
$(LIB_LIB_MCUBOOT): $(LIB_MCUBOOT_OBJS)
	$(TRACE_ARCHIVE)
	$(Q)$(AR) $(AR_OPT) $@ $(LIB_MCUBOOT_OBJS)

# Library Definitions
LIB_INCDIR += $(LIB_MCUBOOT_INCDIR)
LIB_CSRCDIR += $(LIB_MCUBOOT_CSRCDIR)
LIB_ASMSRCDIR += $(LIB_MCUBOOT_ASMSRCDIR)

LIB_CSRCS += $(LIB_MCUBOOT_CSRCS)
LIB_CXXSRCS +=
LIB_ASMSRCS += $(LIB_MCUBOOT_ASMSRCS)
LIB_ALLSRCS += $(LIB_MCUBOOT_CSRCS) $(LIB_MCUBOOT_ASMSRCS)

LIB_COBJS += $(LIB_MCUBOOT_COBJS)
LIB_CXXOBJS +=
LIB_ASMOBJS += $(LIB_MCUBOOT_ASMOBJS)

LIB_DEFINES += $(LIB_MCUBOOT_DEFINES)
LIB_DEPS += $(LIB_MCUBOOT_DEPS)
LIB_LIBS += $(LIB_LIB_MCUBOOT)
