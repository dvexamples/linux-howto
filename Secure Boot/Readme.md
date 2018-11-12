
Secure Boot
==================

#Prerequisite

1. Install UEFI tools
```bash
sudo apt install efitools
```
 
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
	
Use can use any file names instead of `FILE.key` and `FILE.crt`

Then we need convert `*.crt` file to  `*.esl` file format

```bash
cert-to-efi-sig-list -g "$(uuidgen)" FILE.crt FILE.esl
```
* `FILE.esl` - certificate in `*.esl` format
 
The same as in previous command you can use any file name instead of `FILE.esl`
1
# Generate Platform key (PK)

```bash
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=PK keys/" -keyout PK.key -out PK.crt -days 3650 -sha256
```

```bash
cert-to-efi-sig-list -g "$(uuidgen)" PK.crt PK.esl
```
