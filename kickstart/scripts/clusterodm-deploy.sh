#!/bin/bash

deploy_clusterodm_ubuntu() {
  docker pull opendronemap/clusterodm@${webodm_clusterodm_digest}

  expand etc/systemd/system/clusterodm.service.hbs /etc/systemd/system/clusterodm.service
  echo '[{"hostname":"localhost","port":"3001"}]' > /etc/clusterodm.json

  update-rc.d clusterodm defaults
  service clusterodm start
}

deploy clusterodm
