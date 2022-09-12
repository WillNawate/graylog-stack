#!/bin/bash
#
echo -e "####\n# Reabrindo indices ...\n####"
#
curl -u admin:testegraylog -H 'Accept: application/json' -H 'X-Requested-by:CLI' -X POST 'http://<ip>:9000/api/system/indexer/indices/graylog_xxx/reopen' & \
#
sleep 100
#
curl admin:testegraylog -H 'Accept: application/json' -H 'X-Requested-by:CLI' -X POST 'http://<ip>:9000/api/system/indices/ranges/graylog_xxx/rebuild' & \
#
sleep 40
#
echo -e "####\n# Dump de graylog_xxx  ...\n####"
#
 elasticdump \
  --input=http://localhost:9200/graylog_xxx/ \
  --output=/data/log_dump/graylog_xxx.json \
  --type=data \
  --limit=10000
#
sleep 200
#
if [[ -f /data/log_dump/graylog_xxx.json ]]
then
	echo -e "####\n# Compactando graylog_xxx ...\n####"
#
	tar -jcvf /data/log_dump/graylog_1463.tgz /data/log_dump/graylog_xxx.json
else
	echo -e "####\n# Dump imcompleto!\n####"
	exit
fi
#
sleep 200
#
if [[ -f /data/log_dump/graylog_xxx.tgz ]]
then
	echo -e "####\n# Removendo json de graylog_xxx ...\n####"
#
	rm /data/log_dump/graylog_xxx.json
else
	echo -e "####\n# Compactação imcompleta!\n####"
	exit
fi
#
echo -e "####\n# Fechando indices ...\n####"
#
curl admin:testegraylog -H 'Accept: application/json' -H 'X-Requested-by:CLI' -X POST 'http://<ip>:9000/api/system/indexer/indices/graylog_xxx/close' & \
#
echo -e "####\n# Fim!\n####"
##
