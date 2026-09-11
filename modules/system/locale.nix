{ config, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Build both US and GB locale archives to prevent Perl missing-locale warnings
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

    services.xserver.xkb = {
    layout = "us";
    extraLayouts.tei_sulyng = {
      description = "Tei Sulyng (Tai Le)";
      languages   = [ "tns" ];
      symbolsFile = builtins.toFile "tei_sulyng" ''
        default partial alphanumeric_keys
        xkb_symbols "basic" {
            include "us(basic)"
            name[Group1] = "Tei Sulyng (Tai Le)";

            // Consonants
            key <AD01> { [ U1956, U1957 ] }; // q -> t (ᥖ), th (ᥗ)
            key <AD02> { [ U1959, U195A ] }; // w -> p (ᥙ), ph (ᥚ)
            key <AD03> { [ U1950, U1951 ] }; // e -> k (ᥐ), kh (ᥑ)
            key <AD04> { [ U195B, U195C ] }; // r -> c (ᥛ), ch (ᥜ)
            key <AC01> { [ U1954, U195F ] }; // a -> s (ᥔ), ʔ (ᥟ)
            key <AC02> { [ U195B, U195C ] }; // s -> m (ᥛ), n (ᥢ)
            key <AC03> { [ U1952, U1958 ] }; // d -> ng (ᥒ), l (ᥘ)
            key <AB01> { [ U1961, U195D ] }; // z -> y (ᥡ), w (ᥝ)

            // Vowels
            key <AD07> { [ U1963, U1964 ] }; // u -> a (ᥣ), i (ᥤ)
            key <AD08> { [ U196B, U1967 ] }; // i -> e (ᥫ), ê (ᥧ)
            key <AD09> { [ U196A, U1969 ] }; // o -> ư (ᥪ), u (ᥩ)
            key <AD10> { [ U196C, U196D ] }; // p -> o (ᥬ), ô (ᥭ)

            // Tones 1-5 (Mapped to number row 1-5)
            key <AE01> { [ U1970 ] }; // 1 -> ᥰ
            key <AE02> { [ U1971 ] }; // 2 -> ᥱ
            key <AE03> { [ U1972 ] }; // 3 -> ᥲ
            key <AE04> { [ U1973 ] }; // 4 -> ᥳ
            key <AE05> { [ U1974 ] }; // 5 -> ᥴ
        };
      '';
    };
  };
}
