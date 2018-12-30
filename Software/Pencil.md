Pencil
==========

1. Download *.deb file from https://pencil.evolus.vn/Downloads.html
2. Install
```bash
 sudo dpkg -i Pencil_3.0.4_amd64.deb 
```

In case of error 
```
pencil: error while loading shared libraries: libgconf-2.so.4: cannot open shared object file: No such file or directory
```

Install libconf package
```bash
sudo apt -y install libgconf2-4
```


