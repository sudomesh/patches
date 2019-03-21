#!/bin/sh

BUG_NUMBER=$1
NODE_IP=$2

ssh root@$NODE_IP 'mkdir -p /opt/patches'
scp -r bug$BUG_NUMBER root@$NODE_IP:/opt/patches
ssh root@$NODE_IP 'ash -s' < bug$BUG_NUMBER/bug$BUG_NUMBER.sh
