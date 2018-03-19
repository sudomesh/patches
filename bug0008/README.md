Work in progress related to upgrading tunneldigger clients to allow for migrating to a newer tunneldigger broker.

Related to https://github.com/sudomesh/bugs/issues/8

Files:

 name | desc
 --- | ---
tunneldigger | copied from mynet n600 v0.2.3 (fledgling) install
tunneldigger-pre-patch | copied from a mynet n600 v0.2 (fledgling) install

# steps

## stop tunneldigger

```/etc/init.d/tunneldigger stop```

## patch tunneldigger binary
swap out the tunneldigger client:

```
(on node)
mkdir -p /var/patches/bug-0008
mv /usr/bin/tunneldigger /var/patches/bug-0008/tunneldigger-pre-patch
(on machine with tunneldigger binary)
scp tunneldigger root@somenode:/usr/bin/tunneldigger
```

## patch tunneldigger config
patch the /etc/config/tunneldigger on the home node to include 

```
64.71.176.94:8942
64.71.176.94:8943
```

## restart tunneldigger
then restart tunnel digger using

```
/etc/init.d/tunneldigger start
```

and check whether a tunnel can be created.


