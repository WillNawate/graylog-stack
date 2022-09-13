# graylog-stack
Stack do Graylog para docker-compose

Para pode rodar o stack é necessário instalar o docker e docker-compose

```bash
curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
apt -qq install -y curl git docker docker-compose nodejs
npm install elasticdump -g
```

Para alterar a senha do MongoDB alterar o arquivo: ./secrets/.dbpass

Para alterar a senha do graylog gerar a senha com o comando abaixo em um sistema linux e substituilo no campo GRAYLOG_ROOT_PASSWORD dentro do arquivo: ./env/.env_graylog

```bash
echo -n "Enter Password: " && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1
```

No mesmo arquivo também pode ser alterado o nome e e-mail do usuário administrador do sistema.
Para devido funcinamento do web interface é necessário substituir a tag <ip> pelo endereço IP da máquina host nos campos GRAYLOG_HTTP_PUBLISH_URI e GRAYLOG_HTTP_EXTERNAL_URI.

Para fazer o dump basta substituir a tag <ip> dentro do arquivo logdump.sh e executá-lo com o comando abaixo incluindo o número do indice quando solicitado.

```bash
bash logdump.sh
~# bash logdump.sh
##
Número do indice para fazer dump [graylog_XXX]: 10
####
# Reabrindo indice ...
####
...
...
...
...
```