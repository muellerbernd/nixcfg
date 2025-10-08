{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  services.printing.drivers = [
    (pkgs.writeTextDir "share/cups/model/mfp_m880.ppd" (
      builtins.readFile ./HP_Color_LaserJet_flow_MFP_M880.ppd
    ))
  ];
  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP_Color_LaserJet_flow_MFP_M880";
        location = "Work";
        deviceUri = "http://10.87.13.17:631/ipp";
        model = "mfp_m880.ppd";
        ppdOptions = {
          PageSize = "A4";
          Duplex = "DuplexNoTumble";
        };
      }
    ];
    ensureDefaultPrinter = "HP_Color_LaserJet_flow_MFP_M880";
  };
}
