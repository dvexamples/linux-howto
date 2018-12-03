
Secure Boot
==================

#Prerequisite

1. Install UEFI tools
```bash
sudo apt install efitools
```
 
#Replace EFI with custom keys

##Backup original keys
* In ESL format
```bash
efi-readvar -v PK  -o original-pk.esl
efi-readvar -v KEK -o original-kek.esl
efi-readvar -v db  -o original-db.esl
```

* In human readable format (optional)
```bash
efi-readvar -v PK  > original-pk.txt
efi-readvar -v KEK > original-kek.txt
efi-readvar -v db  > original-db.txt
```

## Generate keys

1. New platform key (PK)
```bash
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=PK/" -keyout pk.key -out pk.crt -days 7300 -sha256
```

2. New Key Exchange Key (KEK)
```bash
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=KEK/" -keyout kek.key -out kek.crt -days 7300 -sha256
```

3. New DB key (DB)
```bash
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=DB/" -keyout db.key -out db.crt -days 7300 -sha256
```
##Convert certificate to EFI signature list (ESL)
```bash
cert-to-efi-sig-list pk.crt pk.esl
cert-to-efi-sig-list kek.crt kek.esl
cert-to-efi-sig-list db.crt db.esl
```

##Add original keys
```bash
cat original-kek.esl kek.esl > compound-kek.esl
cat original-db.esl db.esl > compound-db.esl
```


##Signing keys
Each key must be signed with the correspondant key.
    1. PK is signed by itself
    2. KEK is signed by PK
    3. DB is signed by KEK
```bash
sign-efi-sig-list -k pk.key  -c pk.crt  PK  pk.esl  pk.auth
sign-efi-sig-list -k pk.key  -c pk.crt  KEK kek.esl kek.auth
sign-efi-sig-list -k kek.key -c kek.crt db  db.esl  db.auth
```

If original keys also is required then the compound keys (KEK and DB) must be signed.
```bash
sign-efi-sig-list -k pk.key  -c pk.crt  KEK compound_kek.esl compound_kek.auth
sign-efi-sig-list -k kek.key -c kek.crt db  compound_db.esl  compound_db.auth
```

##Setup keys

> In case of getting message "Failed to update dbx: Operation not permitted" use 
> `chattr -i /sys/firmware/efi/efivars/{PK,KEK,db,dbx}-*` command 

* Install custom DB and KEK keys only
```bash
efi-updatevar -f db.auth  db
efi-updatevar -f kek.auth KEK
```

* Install custom and original keys 
```bash
efi-updatevar -f compound_db.auth  db
efi-updatevar -f compound_KEK.auth KEK
```

Install platform key (PK). This operation enable User Mode which prevent any futher unsigned changes
```bash
efi-updatevar -f pk.auth PK
```

#Signing Grub

```bash
sbsign --key db.key --cert db.crt /boot/efi/EFI/ubuntu/grubx64.efi
```
This command produce signed version with the name `grubx64.efi.signed` (in /boot/efi/EFI/ubuntu/ folder)

#Add boot entry for Signed Grub

To find out a disk of EFI partion 
* if the EFI partion located on some of /sda 
```bash
sudo efibootmgr --create  -d ${DISK}  --label "Secure Ubuntu" --loader '\EFI\UBUNTU\grubx64.efi.signed' --verbose
```
Instead of  `${DISK}` use the disk where your EFI partition is located. The following command shows the requried value
```bash
cat /proc/self/mounts | grep /boot/efi | awk '{print $1}'
```
> if the value is looks like this `/dev/nvme0n1p1` then use the value `/dev/nvme0n1`, without the last two characters `p1`.





# Generate the new keys

You need three keys
1. Platform key (PK)
2. Key exchange key (KEK)
3. Database key (DB)

Use openssl to genereate new private/public keys pair and certificate 

```bash
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Any text description of the key/" -keyout FILE.key -out FILE.crt -days 3650 -sha256
```
* FILE.key - is a private key encrypted by the password
* FILE.crt - is a public certificate
	
You can use any file names instead of `FILE.key` and `FILE.crt`

Then we need convert `*.crt` file to  `*.esl` file format

```bash
cert-to-efi-sig-list -g "$(uuidgen)" FILE.crt FILE.esl
```
* `FILE.esl` - certificate in `*.esl` format
 
The same as in previous command you can use any file name instead of `FILE.esl`

So to generate all required keys you can run the sequence of the following commands

1. To generate platfrom key (PK):
```bash
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=PK/" -keyout PK.key -out PK.crt -days 3650 -sha256
```
```bash
cert-to-efi-sig-list -g "$(uuidgen)" PK.crt PK.esl
```
2. To generate Key exchange key (KEK):
```bash
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=KEK/" -keyout KEK.key -out KEK.crt -days 3650 -sha256
```
```bash
cert-to-efi-sig-list -g "$(uuidgen)" KEK.crt KEK.esl
```
3. To generate Database key (DB)
```bash
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=DB/" -keyout DB.key -out DB.crt -days 3650 -sha256
```
```bash
cert-to-efi-sig-list -g "$(uuidgen)" DB.crt DB.esl
```

# Backup current keys
Actually in general you don't need backup you current keys. All BIOS I know has function for reseting to factory keys. 
So in case of any problem you always can restore the original keys. (!!! to be sure please check your BIOS)
But it is mandatory if you want use new and original keys. For example if you want to have windows and linux on the same machine.

```bash
efi-readvar -v <VAR> -o FILE.esl
```
* `<VAR>` could be one of the value 'PK', 'KEK', 'db', 'dbx' (all values are case sensentive)
* `FILE.esl` coudl be any name you like (for example PK.esl or db.esl)

To see the current keys in human readable format use the following command

```bash
efi-readvar
```

So to backup all variables let's run the following commands

```bash
efi-readvar -v PK -o original_PK.esl
efi-readvar -v KEK -o original_KEK.esl
efi-readvar -v db -o original_db.esl
efi-readvar -v dbx -o original_dbx.esl
```
To see the difference after the new keys will be installed we need to store keys in human readable format also
```bash
efi-readvar > original_efi.txt
```

# Setup Mode



# Install New Keys in setup mode
In setup mode BIOS allows write into PK, KEK, DB and DBX without any sign. But once you write PK key, the Setup Mode will be switched off and KEK, DB and DBX can be updated with the signed data only. 

To write new key in setup mode we can use the following command
```bash
efi-updatevar -e -f FILE.esl VAR
```
And you can write any `*.esl` file without signing until PK is empty (because we are in setup mode). 
When we write anything into PK variable the 'setup mode' will be switched off.

## Install only new keys
If you need install just your own keys you need understand that you will need sign your kernel and bootloader with this new keys. Otherwise it will not be loaded by BIOS. Even Ubuntu (beacuse it is signed by Microsoft).

To write KEK and DB run the following
```bash
efi-updatevar -e -f KEK.esl KEKh
efi-updatevar -e -f db.esl DB
```
Optionaly you can write the original dbx database because it could contains a hashes of known malware. 
```bash
efi-updatevar -e -f original_dbx.esl DBX
```

Finally install by installing platform key
```bash
efi-updatevar -f PK.esl PK
```
But you should understand that your current operation systems will not be able to run in Secure Boot. Because you need sign it with a new key or add it's hashes into DB storage. 

## Install new keys with the original keys

To install original keys with a new one you just need concatenate original `*.esl` file with you new `*.esl`
```bash
cat original_KEK.esl KEK.esl > compound_KEK.esl
cat original_db.esl DB.esl > compound_DB.esl
```
To write compound KEK and DB run the following

```bash
efi-updatevar -e -f compound_KEK.esl KEK
efi-updatevar -e -f compound_DB.esl DB
```
And original dbx (because we didn't change it)
```bash
efi-updatevar -e -f original_dbx.esl DBX
```


