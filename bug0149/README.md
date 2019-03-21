## Patch 0149: Robustifying your connection to the exitnodes
This patch fixes [issue 149](https://github.com/sudomesh/sudowrt-firmware/issues/149), and makes your node more robust to exitnode failures by replacing hardcoded IP addresses with hostnames like exit.sudomesh.org, exit1.sudomesh.org, etc.

This patch edits /etc/config/tunneldigger and /etc/config/dhcp on your node, just like in these two commits:

1) https://github.com/sudomesh/sudowrt-firmware/commit/18c5e698817a7dcb6da2ff3915d7510b360e4dfb
2) https://github.com/sudomesh/sudowrt-firmware/commit/73fce5865f5d79a86c95353b0ce4424133155ed5

**Important:** This patch will delete any custom exitnode entries you've added to your /etc/config/tunneldigger file. If you don't remember ever modifying this file, then you don't need to worry about it.

## Apply
To apply the patch at home, connect to your private SSID, and from the patches repo on your home computer run:
```
./patch.sh 0149 172.30.0.1
```

If your node does not know your ssh key, you'll need to enter a password three times.

## Test 
If the patch was successful, you should be able to `ping sudomesh.org` from your node, and your `/etc/config/tunneldigger` should have these addresses listed:

```
  list address 'exit.sudomesh.org:8942'
  list address 'exit.sudomesh.org:443'
  list address 'exit1.sudomesh.org:8942'
  list address 'exit1.sudomesh.org:443'
  list address 'exit2.sudomesh.org:8942'
  list address 'exit2.sudomesh.org:443'
  list address '107.170.219.5:8942'
  list address '107.170.219.5:443'
```

## Revert
If you need to revert:
```
./revert.sh 0149 172.30.0.1
```
