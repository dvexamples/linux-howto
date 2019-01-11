Sign kernel modules by custom Machine owner key
===================================================

# Generate new Machine Owner Key (MOK)
```bash
openssl req -new -x509 -newkey rsa:2048 -keyout MOK.key -outform DER -out MOK.crt -nodes -days 36500 -subj "/CN=YOUR_NAME/"
```

# Install new keys

```bash
$ mokutil --import MOK.crt

input password:
input password again:
```

And reboot the system. After reboot the MOK Manager must be loaded. You need run `enroll key` option.

# Module signing

```bash
/usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 MOK.key MOK.crt
```

#Examples

## Signing Virtual Box modules


```bash 
!/bin/bash

for modfile in $(dirname $(modinfo -n vboxdrv))/*.ko; do
  echo "Signing $modfile"
  /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 MOK.key MOK.crt "$modfile"
done
``` 





