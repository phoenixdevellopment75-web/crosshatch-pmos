import os
import sys

path = "arch/arm64/boot/dts/qcom/sdm845.dtsi"
if not os.path.exists(path):
    print(f"Error: {path} not found!")
    sys.exit(1)

content = open(path).read()

target = """		adreno_smmu: iommu@5040000 {
			compatible = "qcom,sdm845-smmu-v2", "qcom,smmu-v2";
			reg = <0 0x5040000 0 0x10000>;
			#iommu-cells = <1>;
			#global-interrupts = <2>;
			interrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>,
				     <GIC_SPI 231 IRQ_TYPE_LEVEL_HIGH>,
				     <GIC_SPI 364 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 365 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 366 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 367 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 368 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 369 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 370 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 371 IRQ_TYPE_EDGE_RISING>;
			clocks = <&gcc GCC_GPU_MEMNOC_GFX_CLK>,
			         <&gcc GCC_GPU_CFG_AHB_CLK>;
			clock-names = "bus", "iface";

			power-domains = <&gpucc GPU_CX_GDSC>;
		};"""

replacement = """		adreno_smmu: iommu@5040000 {
			compatible = "qcom,sdm845-smmu-v2", "qcom,smmu-v2";
			reg = <0 0x5040000 0 0x10000>;
			#iommu-cells = <1>;
			#global-interrupts = <2>;
			interrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>,
				     <GIC_SPI 231 IRQ_TYPE_LEVEL_HIGH>,
				     <GIC_SPI 364 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 365 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 366 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 367 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 368 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 369 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 370 IRQ_TYPE_EDGE_RISING>,
				     <GIC_SPI 371 IRQ_TYPE_EDGE_RISING>;
		};"""

def normalize(s):
    return "\n".join([line.strip() for line in s.strip().splitlines() if line.strip()])

norm_content = normalize(content)
norm_target = normalize(target)

if norm_target in norm_content:
    target_lines = [line.strip() for line in target.strip().splitlines() if line.strip()]
    replacement_lines = replacement.splitlines()
    
    lines = content.splitlines()
    new_lines = []
    i = 0
    replaced = False
    while i < len(lines):
        # Match slice of target_lines length (ignoring empty lines)
        slice_lines = []
        j = i
        while len(slice_lines) < len(target_lines) and j < len(lines):
            if lines[j].strip():
                slice_lines.append(lines[j].strip())
            j += 1
            
        if len(slice_lines) == len(target_lines) and slice_lines == target_lines:
            new_lines.extend(replacement_lines)
            i = j
            replaced = True
            print("Successfully replaced SMMU config block!")
        else:
            new_lines.append(lines[i])
            i += 1
            
    if replaced:
        open(path, "w").write("\n".join(new_lines) + "\n")
        sys.exit(0)
    else:
        print("Error: Target matching logic failed despite normalize matching!")
        sys.exit(1)
else:
    print("Error: Target SMMU config block not found in sdm845.dtsi!")
    sys.exit(1)
