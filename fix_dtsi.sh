#!/bin/bash
set -e
echo "🔧 Modifying sdm845.dtsi via Perl..."
perl -0777 -pi -e 's/adreno_smmu: iommu\@5040000 \{.*?\};/adreno_smmu: iommu\@5040000 {\n\t\t\tcompatible = "qcom,sdm845-smmu-v2", "qcom,smmu-v2";\n\t\t\treg = <0 0x5040000 0 0x10000>;\n\t\t\t#iommu-cells = <1>;\n\t\t\t#global-interrupts = <2>;\n\t\t\tinterrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>,\n\t\t\t\t     <GIC_SPI 231 IRQ_TYPE_LEVEL_HIGH>,\n\t\t\t\t     <GIC_SPI 364 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 365 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 366 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 367 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 368 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 369 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 370 IRQ_TYPE_EDGE_RISING>,\n\t\t\t\t     <GIC_SPI 371 IRQ_TYPE_EDGE_RISING>;\n\t\t};/s' arch/arm64/boot/dts/qcom/sdm845.dtsi
echo "✅ sdm845.dtsi modified successfully!"
