{ config, pkgs, lib, ... }:

{
  # Hybrid AMD iGPU + NVIDIA dGPU laptop with eGPU support — entirely
  # specific to this machine, no equivalent needed on the desktop.
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Default Mode: PRIME Offload (great for battery/iGPU use)
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      allowExternalGpu = true;
      amdgpuBusId = "PCI:102:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Specialisation: eGPU "fuss-free" gaming mode
  specialisation."eGPU".configuration = {
    system.nixos.tags = [ "eGPU-Mode" ];

    # Force the Nvidia card to drive the desktop (Sync Mode)
    hardware.nvidia.prime = {
      sync.enable = lib.mkForce true;
      offload.enable = lib.mkForce false;
      offload.enableOffloadCmd = lib.mkForce false;
    };

    # Treat the Nvidia card as the primary GPU on Wayland
    environment.sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __NV_PRIME_RENDER_OFFLOAD = "1";
      NV_PRIME_RENDER_OFFLOAD_REVERSE = "1";
      __VK_LAYER_NV_optimus = "NVIDIA_only";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
      KWIN_DRM_DEVICES = "/dev/dri/by-path/pci-0000:01:00.0-card";
      __GL_SYNC_TO_VBLANK = "0";
    };
  };
}
