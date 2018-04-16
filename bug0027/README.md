# Why this patch?

Home nodes (<= v0.2.3) currently rely on that a single exit node with mesh ip 100.64.0.42 exists on the mesh network. The patch to [bug 23](https://github.com/sudomesh/bugs/issues/27) attempted to address this issue; however, it resulted in a bug that prevented mesh links, bridged by extender nodes, from resolving domain names. We are still determining the root cause of this bug, but the following patch reverts and improves some of the changes made by the patch to bug 23.

See https://github.com/sudomesh/bugs/issues/27 .

# WARNING 

This patch is being tested. Please contact folks on https://peoplesopen.net/chat before proceeding.

# Requirements

This patch has not been fully automated, so manual steps are involved. Advised to only patch nodes that are physically accessible so that you can troubleshoot issues in the event that the node gets separated from the mesh network.

If you don't want to patch, you can also re-flash your node with v0.2.3+ firmware (see https://github.com/sudomesh/sudowrt-firmware/releases) and run makenode.

If all this makes you nervous, but you do want to apply the patch, please holler on https://peoplesopen.net/chat .

# Steps

## make a backup

Ssh into your node after connecting to you private network using ```ssh root@172.30.0.1``` and make a backup using the commands below:

```
mkdir -p /opt/patches/bug0027/backup/etc/config

cp /etc/config/network /opt/patches/bug0027/backup/etc/config/
cp /etc/resolv.conf.dnsmasq /opt/patches/bug0027/backup/etc/
```

After this, you should see the following output when running ```find /opt/patches/bug0027``` :

```
/opt/patches/bug0027
/opt/patches/bug0027/backup
/opt/patches/bug0027/backup/etc
/opt/patches/bug0027/backup/etc/config
/opt/patches/bug0027/backup/etc/config/network
/opt/patches/bug0027/backup/etc/resolv.conf.dnsmasq

```

## prepare your patch

### prepare patch staging area
Now, we're going to use the backup files, and copy then to the patch staging location.

```
cp -r /opt/patches/bug0027/backup /opt/patches/bug0027/patch
```

### edit staged files

Login to your node, and make the following edits using your favorite editor (vi perhaps?):

In ```/opt/patches/bug0027/patch/etc/resolv.conf.dnsmasq``` add the following two lines to the top of the file 
```
nameserver 100.64.0.43 # sudomesh exit server
nameserver 100.64.0.42 # sudomesh exit server
```

In ```/opt/patches/bug0027/patch/etc/config/network``` add the following two lines to the interfaces, `ext1mesh`, `ext2mesh`, `mesh2`, `mesh5`, `open` 
```
list dns '100.64.0.42'
list dns '100.64.0.43'
``` 

## apply the patch 

Apply the patch by executing on your node:

```
cp -r /opt/patches/bug0027/patch/* /
echo -e "$(date -Iseconds)\tbug0027\tapplied" >> /opt/patches/patch.log
reboot now
```

## check 

After reboot, connect to the peoplesopen ssid and confirm that you can access the internet like before. 

## revert the patch

If your node doesn't like the patch, or if there's some other reason you'd like to revert the patch, run this on the home node:

```
cp -r /opt/patches/bug0027/backup/* /
echo -e "$(date -Iseconds)\tbug0027\treverted" >> /opt/patches/patch.log
reboot now
```

## pat yourself of the back
If all goes well, pat yourself on the back, let folks know on https://peoplesopen.net/chat and . . . help others do the same, or perhaps consider writing an automated script to do this.
