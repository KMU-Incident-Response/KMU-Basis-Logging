#!/bin/bash

echo "#####################################################
# Willkommen zum Wazuh KMU Installer                #
# Die Installation kann bis zu einer Stunde dauern  #
#####################################################

Drücken Sie Ctrl+C um den Prozess abzubrechen"

sleep 5

# Elasticsearch
apt-get install apt-transport-https zip unzip lsb-release curl gnupg -y
curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list
apt-get update
apt-get install elasticsearch=7.14.2
curl -so /etc/elasticsearch/elasticsearch.yml https://packages.wazuh.com/resources/4.2/elastic-stack/elasticsearch/7.x/elasticsearch_all_in_one.yml
curl -so /usr/share/elasticsearch/instances.yml https://packages.wazuh.com/resources/4.2/elastic-stack/instances_aio.yml
/usr/share/elasticsearch/bin/elasticsearch-certutil cert ca --pem --in instances.yml --keep-ca-key --out ~/certs.zip
unzip ~/certs.zip -d ~/certs
mkdir /etc/elasticsearch/certs/ca -p
cp -R ~/certs/ca/ ~/certs/elasticsearch/* /etc/elasticsearch/certs/
chown -R elasticsearch: /etc/elasticsearch/certs
chmod -R 500 /etc/elasticsearch/certs
chmod 400 /etc/elasticsearch/certs/ca/ca.* /etc/elasticsearch/certs/elasticsearch.*
rm -rf ~/certs/ ~/certs.zip
mkdir -p /etc/elasticsearch/jvm.options.d
echo '-Dlog4j2.formatMsgNoLookups=true' > /etc/elasticsearch/jvm.options.d/disabledlog4j.options
chmod 2750 /etc/elasticsearch/jvm.options.d/disabledlog4j.options
chown root:elasticsearch /etc/elasticsearch/jvm.options.d/disabledlog4j.options
systemctl daemon-reload
systemctl enable elasticsearch --now


output=$(/usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto <<< y)

while IFS= read -r line
do
  if [[ "$line" =~ .*"PASSWORD".* ]];then
    VARIABLENAME=$(echo "$line" | cut -d " " -f 2)
    VARIABLECONTENT=$(echo "$line" | cut -d " " -f 4)
    export "$VARIABLENAME"="$VARIABLECONTENT"
  fi
done < <(printf '%s\n' "$output")

# Wazuh Manager
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list
apt-get update
apt-get install wazuh-manager
systemctl daemon-reload
systemctl enable wazuh-manager --now

# Filebeat
apt-get install filebeat=7.14.2
curl -so /etc/filebeat/filebeat.yml https://packages.wazuh.com/resources/4.2/elastic-stack/filebeat/7.x/filebeat_all_in_one.yml
curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/4.2/extensions/elasticsearch/7.x/wazuh-template.json
chmod go+r /etc/filebeat/wazuh-template.json
curl -s https://packages.wazuh.com/4.x/filebeat/wazuh-filebeat-0.1.tar.gz | tar -xvz -C /usr/share/filebeat/module
echo "
output.elasticsearch.password: $elastic" >> /etc/filebeat/filebeat.yml
cp -r /etc/elasticsearch/certs/ca/ /etc/filebeat/certs/
cp /etc/elasticsearch/certs/elasticsearch.crt /etc/filebeat/certs/filebeat.crt
cp /etc/elasticsearch/certs/elasticsearch.key /etc/filebeat/certs/filebeat.key
systemctl daemon-reload
systemctl enable filebeat --now

# Kibana
apt-get install kibana=7.14.2
mkdir /etc/kibana/certs/ca -p
cp -R /etc/elasticsearch/certs/ca/ /etc/kibana/certs/
cp /etc/elasticsearch/certs/elasticsearch.key /etc/kibana/certs/kibana.key
cp /etc/elasticsearch/certs/elasticsearch.crt /etc/kibana/certs/kibana.crt
chown -R kibana:kibana /etc/kibana/
chmod -R 500 /etc/kibana/certs
chmod 440 /etc/kibana/certs/ca/ca.* /etc/kibana/certs/kibana.*
curl -so /etc/kibana/kibana.yml https://packages.wazuh.com/resources/4.2/elastic-stack/kibana/7.x/kibana_all_in_one.yml
sed -i "s/elasticsearch.password: <elasticsearch_password>/elasticsearch.password: $elastic/" /etc/kibana/kibana.yml
mkdir /usr/share/kibana/data
chown -R kibana:kibana /usr/share/kibana
cd /usr/share/kibana
sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/4.x/ui/kibana/wazuh_kibana-4.2.6_7.14.2-1.zip
setcap 'cap_net_bind_service=+ep' /usr/share/kibana/node/bin/node
systemctl daemon-reload
systemctl enable kibana --now

# Agent Registration
agent=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20)
sed -i "s/<use_password>no<\/use_password>/<use_password>yes<\/use_password>/" /var/ossec/etc/ossec.conf
echo $agent > /var/ossec/etc/authd.pass
chmod 644 /var/ossec/etc/authd.pass
chown root:wazuh /var/ossec/etc/authd.pass
systemctl restart wazuh-manager

webui=$(hostname -I | cut -d " " -f 1)

echo "Password for user apm_system: $apm_system"
echo "Password for user beats_system: $beats_system"
echo "Password for user elastic: $elastic"
echo "Password for user kibana_system: $kibana_system"
echo "Password for user kibana: $kibana"
echo "Password for Agent Registration: $agent"
echo ""
echo "Wazuh Instanz ist hier verfügbar https://$webui"