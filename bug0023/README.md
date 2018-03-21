# Why this patch?

Home nodes (<= v0.2.3) currently rely on that a single exit node with mesh ip 100.64.0.42 exists on the mesh network. This is an issue, because we are in the process of gradually transitioning away from the "old" exit node, where old/new exit nodes are running in parallel.

See https://github.com/sudomesh/bugs/issues/23 .

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
mkdir -p /opt/patches/bug-0023/backup/etc/config
mkdir -p /opt/patches/bug-0023/backup/etc/sudomesh
cp /etc/config/network /opt/patches/bug-0023/backup/etc/config/
cp /etc/resolv.conf.dnsmasq /opt/patches/bug-0023/backup/etc/
cp /etc/sudomesh/home_node /opt/patches/bug-0023/backup/etc/sudomesh/
cp /etc/udhcpc.user /opt/patches/bug-0023/backup/etc/
```

After this, you should see the following output when running ```find /opt/patches/bug-0023``` :

```
/opt/patches/bug-0023/
/opt/patches/bug-0023/backup
/opt/patches/bug-0023/backup/etc
/opt/patches/bug-0023/backup/etc/udhcpc.user
/opt/patches/bug-0023/backup/etc/sudomesh
/opt/patches/bug-0023/backup/etc/config
/opt/patches/bug-0023/backup/etc/config/network
/opt/patches/bug-0023/backup/etc/resolv.conf.dnsmasq
```

## prepare your patch

### prepare patch staging area
Now, we're going to use the backup files, and copy then to the patch staging location.

```
cp -r /opt/patches/bug-0023/backup /opt/patches/bug-0023/patch
```

### download udhcpc.user file
Also, download the file [udhcpc.user](./udhcpc.user) file to your laptop, and copy it to your node by opening another terminal and executing:

```
scp [download folder]/udhcpc.user root@172.30.0.1:/opt/patches/bug-0023/patch/etc/
```

### edit staged files

Login to your node, and make the following edits using your favorite editor (vi perhaps?):

In ```/opt/patches/bug-0023/patch/etc/resolv.conf.dnsmasq``` remove the line that contains ```nameserver 100.64.0.42 # sudomesh exit server```.

In ```/opt/patches/bug-0023/patch/etc/config/network``` remove the lines that contain ```option dns '100.64.0.42'``` . 

In ```/opt/patches/bug-0023/patch/etc/sudomesh/home_node``` remove the following lines at the start of the file:

```
# TODO: We need to somehow detect this after the tunnel comes up
MESHEXITIP=100.64.0.42
INETEXITIP=45.34.140.42
```

## apply the patch 

Apply the patch by executing on your node:

```
cp -r /opt/patches/bug-0023/patch/* /
echo -e "$(date -Iseconds)\tbug-0023\tapplied" >> /opt/patches/patch.log
reboot now
```

## check 

After reboot, connect to the peoplesopen ssid and confirm that you can access the internet like before. 

## revert the patch

If your node doesn't like the patch, or if there's some other reason you'd like to revert the patch, run this on the home node:

```
cp -r /opt/patches/bug-0023/backup/* /
echo -e "$(date -Iseconds)\tbug-0023\treverted" >> /opt/patches/patch.log
reboot now
```

i## pat yourself of the back
If all goes well, pat yourself on the back, let folks know on https://peoplesopen.net/chat and . . . help others do the same, or perhaps consider writing an automated script to do this.
