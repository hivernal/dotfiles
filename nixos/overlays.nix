self: super: {
  chromium = super.chromium.override {
    commandLineArgs = "--enable-features=VaapiVideoDecoder,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE --ozone-platform-hint=auto";
  };

#   xorg = super.xorg.overrideScope (xself: xsuper: {
#     xorgserver = xsuper.xorgserver.overrideAttrs (oldAttrs: {
#       # src = /home/nikita/downloads/browser/xorg-server;
#       src = super.fetchgit {
#         url = "https://gitlab.freedesktop.org/xorg/xserver.git";
#         rev = "c4481fc20fd4da1e89aa4f41a7dca1d563d00cee";
#         sha256 = "sha256-2prFWL5/ykIrGZn6Zb8JjU5U0IZsK3YXdRn0lp/eDeU=";
#       };
#       nativeBuildInputs = with super; [ pkg-config meson ninja ];
#       # buildInputs = with super; [ mesa ] ++ oldAttrs.buildInputs;
#       phases = "unpackPhase configurePhase buildPhase installPhase";
#       # dontPatch = true;
#     });
#   });
}
