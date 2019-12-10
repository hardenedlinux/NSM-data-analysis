
#!/bin/sh
for pf in $(find ~/malware-traffic-dataset/malware-traffic-analysis.net -name "*.pcap")
do
    pcap_name=$(basename ${pf})
    echo "scan pcap ${pf}"
    #    sudo /usr/local/zeek/bin/zeek -C -r ${pf} ~/hardenedlinux-zeek-script/scripts/local.zeek
    sudo tcpreplay-edit -i enp1s0 -K -l1000 -M2000  --unique-ip -m3000 ${pf}
done

for pf in $(find ~/malware-traffic-dataset/smb -name "*.pcap")
do
    pcap_name=$(basename ${pf})
    echo "scan pcap ${pf}"
    #    sudo /usr/local/zeek/bin/zeek -C -r ${pf} ~/hardenedlinux-zeek-script/scripts/local.zeek
    sudo tcpreplay-edit -i enp1s0 -K -l1000 -M2000  --unique-ip -m3000 ${pf}
done

for pf in $(find ~/malware-traffic-dataset/IOT -name "*.pcap")
do
    pcap_name=$(basename ${pf})
    echo "scan pcap ${pf}"
    #    sudo /usr/local/zeek/bin/zeek -C -r ${pf} ~/hardenedlinux-zeek-script/scripts/local.zeek
    sudo tcpreplay-edit -i enp1s0 -K -l1000 -M2000  --unique-ip -m3000 ${pf}
done


for pf in $(find ~/malware-traffic-dataset/captures2/*/* -name "*.pcap")
do
    pcap_name=$(basename ${pf})
    echo "scan pcap ${pf}"
    #    sudo /usr/local/zeek/bin/zeek -C -r ${pf} ~/hardenedlinux-zeek-script/scripts/local.zeek
    sudo tcpreplay-edit -i enp1s0 -K -l1000 -M2000  --unique-ip -m3000 ${pf}
done

for pf in $(find ~/malware-traffic-dataset/smtp -name "*.pcap")
do
    pcap_name=$(basename ${pf})
    echo "scan pcap ${pf}"
    #    sudo /usr/local/zeek/bin/zeek -C -r ${pf} ~/hardenedlinux-zeek-script/scripts/local.zeek
    sudo tcpreplay-edit -i enp1s0 -K -l1000 -M2000  --unique-ip -m3000 ${pf}
done

for pf in $(find ~/malware-traffic-dataset/software/*/* -name "*.pcap")
do
    pcap_name=$(basename ${pf})
    echo "scan pcap ${pf}"
    #    sudo /usr/local/zeek/bin/zeek -C -r ${pf} ~/hardenedlinux-zeek-script/scripts/local.zeek
    sudo tcpreplay-edit -i enp1s0 -K -l1000 -M2000  --unique-ip -m3000 ${pf}
done


for pf in $(find ~/malware-traffic-dataset/analysis-exercise -name "*.pcap")
do
    pcap_name=$(basename ${pf})
    echo "scan pcap ${pf}"
    #    sudo /usr/local/zeek/bin/zeek -C -r ${pf} ~/hardenedlinux-zeek-script/scripts/local.zeek
    sudo tcpreplay-edit -i enp1s0 -K -l1000 -M2000  --unique-ip -m3000 ${pf}
done
