#!/bin/bash

deploy_nodeodm_ubuntu() {
  docker pull opendronemap/nodeodm@${webodm_nodeodm_digest}

  expand etc/systemd/system/nodeodm.service.hbs /etc/systemd/system/nodeodm.service

  update-rc.d nodeodm defaults
  service nodeodm start
}

deploy nodeodm
