{ fetchFromGitHub, writeScript, version, confdir, PostgresqlPlugin, KafkaPlugin, zeekctl, Http2Plugin, SpicyPlugin, llvmPackages_9}:

rec {
  install_plugin = writeScript "install_plugin" (import ./install_plugin.nix { inherit llvmPackages_9; });
  zeek-postgresql = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./zeek-plugin.json)).zeek-postgresql;
  metron-bro-plugin-kafka = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./zeek-plugin.json)).metron-bro-plugin-kafka;
  bro-http2 = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./zeek-plugin.json)).bro-http2;
  Spicy = fetchFromGitHub (builtins.fromJSON (builtins.readFile ./zeek-plugin.json)).spicy;
  postFixup =  (if zeekctl then ''
         substituteInPlace $out/etc/zeekctl.cfg \
         --replace "CfgDir = $out/etc" "CfgDir = ${confdir}/etc" \
         --replace "SpoolDir = $out/spool" "SpoolDir = ${confdir}/spool" \
         --replace "LogDir = $out/logs" "LogDir = ${confdir}/logs"


         echo "scriptsdir = ${confdir}/scripts" >> $out/etc/zeekctl.cfg
         echo "helperdir = ${confdir}/scripts/helpers" >> $out/etc/zeekctl.cfg
         echo "postprocdir = ${confdir}/scripts/postprocessors" >> $out/etc/zeekctl.cfg
         echo "sitepolicypath = ${confdir}/policy" >> $out/etc/zeekctl.cfg
         ## default disable sendmail
         echo "sendmail=" >> $out/etc/zeekctl.cfg
         '' else "") +
  (if KafkaPlugin then ''
         ##INSTALL ZEEK Plugins
       bash ${install_plugin} metron-bro-plugin-kafka ${metron-bro-plugin-kafka} ${version}
         '' else "") +
  (if Http2Plugin then ''
         ##INSTALL ZEEK Plugins
       bash ${install_plugin} bro-http2 ${bro-http2} ${version}
         '' else "") +
  (if SpicyPlugin then ''
    mkdir -p /build/spicy
    cp -r ${Spicy}/* /build/spicy
    chmod 755  /build/spicy/*
    patchShebangs /build/spicy/scripts/autogen-type-erased
    patchShebangs /build/spicy/scripts/autogen-dispatchers
    bash ${install_plugin} spicy ${Spicy} ${version}
            '' else "") +
  (if PostgresqlPlugin then ''
             bash ${install_plugin} zeek-postgresql ${zeek-postgresql} ${version}
    '' else "");
}
