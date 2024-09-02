setenforce 0
sed -i 's/SELINUX=.*/SELINUX=permissive/' /etc/selinux/config

PREFIX={{ dnsmasq_cidr.split('/')[1] }}
NIC={{ dnsmasq_nic }}
{% if ':' in dnsmasq_cidr %}
nmcli con mod "System $NIC" ipv6.addresses {{ installer_ip|default(dnsmasq_cidr|network_ip(2)) }}/$PREFIX ipv6.method manual
{% else %}
nmcli con mod "System $NIC" ipv4.addresses {{ installer_ip|default(dnsmasq_cidr|network_ip(2)) }}/$PREFIX ipv4.method manual
{% endif %}
nmcli conn up "System $NIC"

dnf -y install dnsmasq bind-utils {{ 'radvd' if ':' in dnsmasq_cidr else '' }}
cp /root/dnsmasq.conf /etc/dnsmasq.d/custom.conf
cp /root/hosts /opt
chmod 755 /opt/hosts
cp /etc/resolv.conf /opt
chmod 755 /opt/resolv.conf
echo nameserver {{ dnsmasq_cidr|network_ip(2) }} > /etc/resolv.conf
echo search {{ plan }}.{{ domain }} >> /etc/resolv.conf
chattr +i /etc/resolv.conf
systemctl enable --now dnsmasq

sysctl -w net.ipv4.conf.all.forwarding=1
{% if ':' in dnsmasq_cidr %}
cp /root/radvd.conf /etc
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.ipv6.conf.all.accept_ra=2
systemctl enable --now radvd
{% endif %}
