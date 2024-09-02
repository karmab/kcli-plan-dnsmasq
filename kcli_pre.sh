{% if dnsmasq_network == None %}
echo dnsmasq_network is mandatory && exit 1
{% endif %}
