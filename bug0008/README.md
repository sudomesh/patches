# Why this patch?
In an effort to resolve intermittent failures of home nodes connecting to the internet (see https://github.com/sudomesh/bugs/issues/8) via an exit node, we have created a new exit node with a newer version of tunneldigger broker (i.e., https://github.com/wlanslovenija/tunneldigger/commits/210037aabf8538a0a272661e08ea142784b42b2c). For home nodes to talk to the "new" exit node, a new version of the tunneldigger client needs to be installed. In addition, the tunneldigger client configuration needs to be updated so that the node talks to the new exit node. This procedure describes how to patch/upgrade your node to make this happen.

Please note that this procedure has been tested on a mynet n600 running v0.2 (fledgling) of our software. 

Also note that if you'd rather not patch your node, you can re-flash it using release v0.2.3 or higher. See https://github.com/sudomesh/sudowrt-firmware/releases .

# WARNING
This patch procedure is being tested.

# Prerequisites

It is suggested to have physical access to the home node. If this precedure is done remotely and fails, it may be tricky to revert the patch remotely. If this patch is applied remotely, please work with the node owner to make sure that they know what is happening.

Also, please apply patch for [bug0023](./bug0023) if you haven't done so already.

Files:

 name | desc
 --- | ---
[tunneldigger](./tunneldigger) | copied from mynet n600 v0.2.3 (fledgling) install

# manual steps

## check-in

If this stuff freaks you out, please contact folks at https://peoplesopen.net/chat and ask for help on patching/upgrading your node. You can also do this if you get stuck in subsequent steps.

## check your home node model

Confirm that your model is a mynet n600/ n750. If not, you can proceed, but you may have to revert your patch.

## check access to home node

First, connect to your peoplesopen node by connected to private network. Then, run ```ssh root@172.30.0.1``` and enter your password. If you can stuck here, please let everyone know via https://peopleopen.net/chat and we can figure something out. 
After logging in using ssh, you should see something like:

```
BusyBox v1.23.2 (2017-04-17 08:25:42 UTC) built-in shell (ash)


  ._______.___    ._______.______  ._____  .___    .___ .______  ._____  
  :_ ____/|   |   : .____/:_ _   \ :_ ___\ |   |   : __|:      \ :_ ___\ 
  |   _/  |   |   | : _/\ |   |   ||   |___|   |   | : ||       ||   |___
  |   |   |   |/\ |   /  \| . |   ||   /  ||   |/\ |   ||   |   ||   /  |
  |_. |   |   /  \|_.: __/|. ____/ |. __  ||   /  \|   ||___|   ||. __  |
    :/    |______/   :/    :/       :/ |. ||______/|___|    |___| :/ |. |
    :                      :        :   :/                        :   :/ 
                                        :                             : 
 -------------------------------------------------------------------------
 sudo mesh v0.2 (fledgling)
                              based on OpenWRT 15.05 (Chaos Calmer)
 -------------------------------------------------------------------------
 “When your rage is choking you, it is best to say nothing.” 
                                            - Octavia E. Butler, Fledgling
 -------------------------------------------------------------------------
root@goat:~# 
```

## create patch directory and make backup

First, make a backup of the files you are about to change. To do this run the following after you logged into your home node:

```
mkdir -p /opt/patches/bug0008/backup/usr/bin
mkdir -p /opt/patches/bug0008/backup/etc/config
mkdir -p /opt/patches/bug0008/patch/etc/config
mkdir -p /opt/patches/bug0008/patch/usr/bin

cp /usr/bin/tunneldigger /opt/patches/bug0008/backup/usr/bin/tunneldigger
cp /etc/config/tunneldigger /opt/patches/bug0008/backup/etc/config/tunneldigger
cp /etc/config/tunneldigger /opt/patches/bug0008/patch/etc/config/tunneldigger
```

Following edit the tunnel digger configuration:

```
vi /opt/patches/bug0008/patch/etc/config/tunneldigger
```

now type "i", and append these lines on the line after ```config broker 'main'``` (most likely the second line in the file):

```
 list address '64.71.176.94:8942'
 list address '64.71.176.94:443'
```

save by hitting escape "esc", typing ":w" and typing ":q"


## download binary

Now, download the "new" tunneldigger client library at https://github.com/sudomesh/patches/raw/master/bug0008/tunneldigger . 

## copy the binary to the home node
Open a new terminal, and keep the old one open.

Copy the new binary to your home node using on your computer

```
scp [download dir]/tunneldigger root@172.30.0.1:/opt/patches/bug0008/patch/usr/bin/
```

Now, to make sure that tunneldigger patch has permission to be executed on your home node, run:

```
chmod +x /opt/patches/bug0008/patch/usr/bin/tunneldigger
```

## apply the patch

On the home node, run the following to apply the patch.

```
cp -r /opt/patches/bug0008/patch/* /
echo -e "$(date -Iseconds)\tbug0008\tapplied" >> /opt/patches/patch.log
reboot now
```

## check 
Now, check that the patch has been applied by attempting to connect to the "big" internet using your public peoplesopen ssid. 

Also, if you go to https://whatsmyip.com, you should *not* see an ip address located in LA.

## revert the patch

If your node doesn't like the patch, or if there's some other reason you'd like to revert the patch, run this on the home node:

```
cp -r /opt/patches/bug0008/backup/* /
echo -e "$(date -Iseconds)\tbugs-0008\treverted" >> /opt/patches/patch.log
reboot now
```

## pat yourself of the back
If all goes well, pat yourself on the back, let folks know on https://peoplesopen.net/chat and . . . help others do the same, or perhaps consider writing an automated script to do this.
