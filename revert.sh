#!/bin/sh

BUG_NUMBER=$1
NODE_IP=$2

ssh root@$NODE_IP 'ash -s' < bug$BUG_NUMBER/revert-bug$BUG_NUMBER.sh
