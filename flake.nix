{
  description = "Mednaffe with ALSA plugins";

  inputs = {
    sysrepo.url = "nixpkgs";
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
          alsa-lib =
            with pkgs;
            alsa-lib-with-plugins.override {
              plugins = [ alsa-plugins ];
            };

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