#!/bin/bash
# ============================================================
# fix_dtsi.sh — Kernel patch helper for Google Pixel 3 XL
# ============================================================
#
# This script is called during the pmbootstrap APKBUILD prepare()
# phase and applies two fixes required to compile mainline
# Linux 5.3-rc5 for the SDM845 (Snapdragon 845) platform.
#
# Fix 1: SDM845 SMMU DTSI deadlock
#   The upstream sdm845.dtsi has an incomplete Adreno SMMU
#   node. Without this fix, the kernel deadlocks during IOMMU
#   initialization at boot time.
#
# Fix 2: Samsung S6E3HA8 panel compile error
#   The panel driver references connector->display_info.name
#   which doesn't exist in v5.3-rc5 kernel headers. This line
#   is removed so the driver compiles cleanly.
#
# ============================================================
set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Applying SDM845 kernel patches for Pixel 3 XL..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── Fix 1: SDM845 SMMU (Adreno GPU IOMMU) deadlock ──────────
echo ""
echo "🔧 [1/2] Patching sdm845.dtsi — fixing SMMU IOMMU node..."
perl -0777 -pi -e \
  's/adreno_smmu: iommu\@5040000 \{.*?\};/adreno_smmu: iommu\@5040000 {\n\t\t\tcompatible = "qcom,sdm845-smmu-v2", "qcom,smmu-v2";\n\t\t\treg = <0 0x5040000 0 0x10000>;\n\t\t\t#iommu-cells = <1>;\n\t\t\t#global-interrupts = <2>;\n\t\t\tinterrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>,\n\t\t\t\t     <GIC_SPI 231 IRQ_TYPE_LEVEL_HIGH>,\n\t\t\t\t     <GIC_SPI 364 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 365 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 366 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 367 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 368 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 369 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 370 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 371 IRQ_TYPE_EDGE_RISING>;\n\t\t};/s' \
  arch/arm64/boot/dts/qcom/sdm845.dtsi
echo "✅ sdm845.dtsi patched successfully!"

# ── Fix 2: Samsung S6E3HA8 panel compile error ───────────────
echo ""
echo "🔧 [2/2] Patching panel-samsung-s6e3ha8.c — removing bad strncpy call..."
perl -0777 -pi -e \
  's/strncpy\(connector->display_info\.name, "Samsung S6D16D0\\0",\s*DRM_DISPLAY_INFO_LEN\);//s' \
  drivers/gpu/drm/panel/panel-samsung-s6e3ha8.c
echo "✅ panel-samsung-s6e3ha8.c patched successfully!"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  All patches applied. Proceeding with kernel build..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
