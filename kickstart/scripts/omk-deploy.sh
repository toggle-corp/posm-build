#!/bin/bash

dst=/opt/omk

deploy_omk_ubuntu() {
  # OMK user
  useradd -c 'OpenMapKit Server' -d /nonexistent -m -r -s /bin/false -U omk

  deploy_omk_server
}

deploy_omk_server() {
  cat <<EOF > /etc/omk-server.js
module.exports = {
  name: 'OpenMapKit Server',
  description: 'OpenMapKit Server',
  port: ${omk_server_port},
  dataDir: __dirname + '/data',
  pagesDir: __dirname + '/frontend/build',
  hostUrl: '${posm_base_url}',
  osmApi: {
      server: '${osm_base_url}',
      user: 'POSM',
      pass: ''
  }
};
EOF

  # create data directories if necessary
  mkdir -p /opt/data/omk/{forms,submissions}
  chown -R omk:omk /opt/data/omk/{forms,submissions}

  # create backup directory
  mkdir -p /opt/data/backups/omk
  chown omk:omk /opt/data/backups/omk
  chmod 755 /opt/data/backups/omk

  docker pull quay.io/americanredcross/openmapkitserver

  # start
  expand etc/systemd/system/omk-server.service.hbs /etc/systemd/system/omk-server.service
  update-rc.d omk-server defaults
  service omk-server start

  apps=$(jq .apps /opt/posm-www/config.json)
  new_apps=$(cat << EOF | jq -s '.[0] + .[1] | unique'
[
  {
    "name": "OpenMapKit",
    "icon": "mobile-phone",
    "url": "//${posm_fqdn}/omk/"
  }
]
$apps
EOF
)

  config=$(jq . /opt/posm-www/config.json)
  cat << EOF | jq -s '.[0] * .[1]' > /opt/posm-www/config.json
$config
{
  "apps": $new_apps
}
EOF

  true
}

deploy omk
