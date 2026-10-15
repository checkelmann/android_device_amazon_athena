#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/amazon/athena

BUILD_BROKEN_DUP_RULES := true

# Architecture — 64-bit ARM kernel with 32-bit userspace (CONFIG_COMPAT=y).
# The MT8183 kernel source (amazon-mt8183-devs) only supports arch/arm64/.
# Stock athena runs a 32-bit kernel but Amazon's GPL release is 64-bit only.
# The bootopt=64S3,32S1,32S1 cmdline in athena's stock boot image tells LK
# to try 64-bit first, so a 64-bit Image.gz-dtb is the correct target.
# athena_defconfig will set CONFIG_COMPAT=y so 32-bit userspace works.
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a73

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a53

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := athena
TARGET_NO_BOOTLOADER := true

# Boot Image — values from TWRP athena BoardConfig
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x14f88000
BOARD_SECOND_OFFSET := 0x00e88000
BOARD_KERNEL_TAGS_OFFSET := 0x13f88000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_BOOTIMG_HEADER_VERSION := 1

# Stock athena cmdline (from dumped boot.img): 64S3,32S1,32S1
# Tries 64-bit first, then 32-bit, then 32-bit
BOARD_KERNEL_CMDLINE := bootopt=64S3,32S1,32S1
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

BOARD_MKBOOTIMG_ARGS := --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --second_offset $(BOARD_SECOND_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOTIMG_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --board ""

# Display — Echo Show 8 is a landscape 8" display, 1280x800 panel,
# 270° physical rotation puts the long edge along the top.
# Per ikconfig: LCM_HEIGHT=1280, LCM_WIDTH=800, MTK_LCM_PHYSICAL_ROTATION=270
TARGET_SCREEN_WIDTH := 800
TARGET_SCREEN_HEIGHT := 1280
TARGET_SCREEN_DENSITY := 160

# HIDL
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml

# Kernel — 64-bit ARM, Clang (matches maverick build flags)
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/amazon/mt8183
TARGET_KERNEL_CONFIG := athena_defconfig
TARGET_KERNEL_CLANG_COMPILE := true
TARGET_KERNEL_CLANG_VERSION := r450784d
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb

# Partitions — sizes from /proc/partitions on the live device
# mmcblk1p20 = 16384 blocks = 16MB boot
# mmcblk1p7  = 40960 blocks = 40MB recovery
# mmcblk1p21 = 3178496 blocks ≈ 3.0GB system
# mmcblk1p22 = 262144 blocks = 256MB cache
# mmcblk1p23 = 3671855 blocks ≈ 3.5GB userdata
# mmcblk1p12 = 292864 blocks ≈ 286MB vendor
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 41943040
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3255787520
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_PARTITION_SIZE := 3760359520
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 299892736
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_FLASH_BLOCK_SIZE := 131072

# Platform
TARGET_BOARD_PLATFORM := mt8183

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt8183

# SPL
VENDOR_SECURITY_PATCH := 2022-01-01

# Verified Boot
BOARD_AVB_ENABLE := false

# VNDK
BOARD_VNDK_VERSION := current

# Inherit the proprietary files
include vendor/amazon/athena/BoardConfigVendor.mk
