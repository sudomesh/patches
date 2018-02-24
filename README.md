# Patches

find and deploy patches related to sudomesh bugs

To perform a patch of <bug_number> on node of <node_IP>   

```
./patch.sh <bug_number> <node_IP>
```
where <bug_number> corresponds to the bug being patched in [sudomesh/bugs](https://github.com/sudomesh/bugs) formatted with four digits, padded with leading zeroes, e.g. `bug #17` would be `0017`.  
and <node_IP> is the IP address of the node to which you want push the update.    

# Guidelines for creating/submitting/deploying patches

1. select a bug in state "node patch pending" from [sudomesh/bugs](https://github.com/sudomesh/bugs/issues) 
2. create a patch by using diff (or git diff) or writing a little script to make the changes along with instructions on how to apply the patch
3. apply the patch in a controlled environment using your own home node, at least one remote test node, and your own (test) exit node
4. review and share results with at least on other person
5. convince a node whisperer with proper access to run the patch on active nodes
6. communicate via mesh mailing list and notify of remote patch

# Build you own patch

Patches can vary greatly in scope, application, and execution, though the standards used in this repo should be followed as closely as possible if you would like your patch to be pushed to active nodes. Existing patches and instructions for executing them can be found in the directory corresponding to their bug number from the [sudomesh/bugs issues](https://github.com/sudomesh/bugs/issues). To create the most simple patch of altering a single file on a home node, use the following instructions,

1. create two copies of the files you would like to patch (one before, one after), either from a test node or modified from this repo (note: it is inadvisable to use `git diff`, since changes are made to the files before they are packed by makenode)

2. Delete any lines from these copies that are user/node specifc (e.g. IP address, hostname, hashed passwords)

3. send the ouput of `diff -Naur` to a patchfile, for example,
```
diff -Naur tunneldigger_before tunneldigger_after > bug0017.patch 
```

4. edit the patch so the file path is global and the file replaces itself (assuming that is the desired behavior), for example,
```
--- tunneldigger_before    2018-02-23 05:49:40.677861696 -0800
+++ tunneldigger_after    2018-02-23 05:49:55.302282993 -0800
```
would become,
```
--- /etc/config/tunneldigger    2018-02-23 05:49:40.677861696 -0800
+++ /etc/config/tunneldigger    2018-02-23 05:49:55.302282993 -0800
```

5. copy the patch file to a test node that is in the "before" state.

6. test the patch with dry run by sshing into your test node and running,
```
patch --dry-run -p1 < bug0017.patch
```
note: may first need to install the `patch` package as this has yet to be rolled into makenode or the sudowrt firmware. To install `patch`, run the following on your node,
```
opkg update
opkg install patch
```

7. If the dry-run succeeds, attempt to run the patch with something like,
```
patch -p1 < bug0017.patch
``` 
You may see a warning about "fuzz", this is triggered when the original file does not match patch exactly. Potential side effects of this fuzz are unknown. 

8. Check that the file was correctly patched.

Every patch should come with clear instructions on usage and/or a shell script that automates most of the process for node whisperers.   

Additionally, if patching a file that contains or modifies user/node specific information, it may be necessary to write helper scripts that discovers such information and inserts it into the patch file.

