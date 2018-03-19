Work in progress related to upgrading tunneldigger clients to allow for migrating to a newer tunneldigger broker.

Related to https://github.com/sudomesh/bugs/issues/8

Files:

tunneldigger 
    : copied from mynet n600 v0.2.3 (fledgling) install
tunneldigger-pre-patch
    : copied from a mynet n600 v0.2 (fledgling) install

after stopping tunneldigger

/etc/init.d/tunneldigger stop

swap out the tunneldigger client:

mkdir -p /var/patches/bug-0008
mv /usr/bin/tunneldigger /var/patches/bug-0008/tunneldigger-pre-patch
scp tunneldigger root@somenode:/usr/bin/tunneldigger

patch the /etc/config/tunneldigger to include 

64.71.176.94:8942
64.71.176.94:8943

then restart tunnel digger using

/etc/init.d/tunneldigger start

and check whether stuff is working.


