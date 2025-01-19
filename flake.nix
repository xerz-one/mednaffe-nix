{
  description = "Mednaffe with ALSA plugins";

  inputs = {
    sysrepo.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, sysrepo, ... }@inputs:
    let
      forAllSystems = with sysrepo.lib; genAttrs systems.doubles.linux;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = sysrepo.legacyPackages.${system};
        in
        rec {
          alsa-lib = pkgs.alsa-lib-with-plugins;

          mednafen = pkgs.mednafen.override {
            inherit alsa-lib;
          };

          mednaffe = pkgs.mednaffe.override {
            inherit mednafen;
          };

          default = mednaffe;
        }
      );
    };
}
