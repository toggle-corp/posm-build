#!/bin/bash

deploy_wifi_ubuntu() {

  apt-get install --no-install-recommends -y \
    dnsmasq \
    dnsmasq-utils \
    hostapd \
    iw \
    rfkill \
    rng-tools \
    wireless-tools

  service systemd-resolved stop
  service dnsmasq restart
  service systemd-resolved start
}

deploy wifi
