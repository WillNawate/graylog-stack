#!/bin/bash
#
while [[ ! $index =~ ^[[:digit:]]+$ ]]; do 
    echo "##"
    read -p 'Número do indice para fazer dump [graylog_XXX]: ' index
	if ! [[ $index =~ ^[[:digit:]]+$ ]]
		then
			echo "Insira apenas números!\n"
	fi
done
#
echo -e "####\n# Reabrindo indice ...\n####"
#
curl -u admin:testegraylog -H 'Accept: application/json' -H 'X-Requested-by:CLI' -X POST "http://<ip>:9000/api/system/indexer/indices/graylog_$index/reopen"
#
sleep 100
#
curl admin:testegraylog -H 'Accept: application/json' -H 'X-Requested-by:CLI' -X POST "http://<ip>:9000/api/system/indices/ranges/graylog_$index/rebuild"
#
sleep 40
#
echo -e "####\n# Dump de graylog_$index ...\n####"
#
 elasticdump \
  --input=http://localhost:9200/graylog_$index/ \
  --output=/data/log_dump/graylog_$index.json \
  --type=data \
  --limit=10000
#
sleep 200
#
if [[ -f /data/log_dump/graylog_$index.json ]]
then
	echo -e "####\n# Compactando graylog_$index ...\n####"
#
	tar -jcvf /data/log_dump/graylog_1463.tgz /data/log_dump/graylog_$index.json
else
	echo -e "####\n# Dump imcompleto!\n####"
	exit
fi
#
sleep 200
#
if [[ -f /data/log_dump/graylog_$index.tgz ]]
then
	echo -e "####\n# Removendo json de graylog_$index ...\n####"
#
	rm /data/log_dump/graylog_$index.json
else
	echo -e "####\n# Compactação imcompleta!\n####"
	exit
fi
#
echo -e "####\n# Fechando indices ...\n####"
#
curl admin:testegraylog -H 'Accept: application/json' -H 'X-Requested-by:CLI' -X POST "http://<ip>:9000/api/system/indexer/indices/graylog_$index/close" & \
#
echo -e "####\n# Fim!\n####"
##
