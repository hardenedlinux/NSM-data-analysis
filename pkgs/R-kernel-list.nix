{ pkgs }:

(with pkgs.rWrapper.override; (p: with p;  [     summarytools
                                                 doBy
                                                 tidyverse
                                                 devtools
                                                 ggplot2
                                                 xts
                                                 uuid
                                                 htmlwidgets
                                                 IRdisplay
                                                 purrr cmaes cubature
                                                 (let
                                                   llr = buildRPackage {      name = "llr";
                                                                              src = pkgs.fetchFromGitHub {
                                                                                owner = "dirkschumacher";
                                                                                repo = "llr";
                                                                                rev = "0a654d469af231e9017e1100f00df47bae212b2c";
                                                                                sha256 = "0ks96m35z73nf2sb1cb8d7dv8hq8dcmxxhc61dnllrwxqq9m36lr";
                                                                              };
                                                                              propagatedBuildInputs = [ rlang  knitr];
                                                                              nativeBuildInputs = [ rlang knitr ];
                                                                       };
                                                 in
                                                   [llr]
                                                 )

                                           ]))
