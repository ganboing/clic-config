# VNC Connection to CLIC #

## What's VNC? ##

VNC (Virtual Network Computing) uses RFB (Remote Frame Buffer) protocol to remotely control another computer. We are going to make use of the VNC Server installed in the CLIC lab to connect to the virtual desktop environment remotely.

## How It Works ##

UNIX-like OSes, including Linux, use X Window System to host GUI processes. The RealVNC in the CLIC lab server behaves just like a normal X Window Server except that the graphics is rendered on the virtual desktop rather than a real physical screen. And of course, it is also a VNC server for clients to connect to.

## Configure It in CLIC ##

Simply download the "xstartup" and "metacity" from the same directory in Github to your "~/.vnc" directory. Curl and chmod will do the job by

```
curl https://raw.githubusercontent.com/ganboing/clic-config/master/vnc/xstartup --create-dirs -o ~/.vnc/xstartup
curl https://raw.githubusercontent.com/ganboing/clic-config/master/vnc/metacity --create-dirs -o ~/bin/metacity
chmod +x ~/.vnc/xstartup
```

If you would like to change the script, you are very welcomed to. The script will be invoked at the creation of the new Window. My script will create the GNOME login session for you. If you do not need to make any changes, then you are done with configuration!

## Run ##

Since the VNC Server runs on a specific machine, it is essential that you connect to the same CLIC machine to use the same virtual desktop. That being said, you need to specify a host to connect rather than clic-lab. For example, I would like to start a virtual desktop on the host "baghdad" in CLIC, then I can use

```
ssh bg2539@baghdad.clic.cs.columbia.edu
```

to specifically connect to "baghdad" (A almost complete list of CLIC machines can be found here https://github.com/ganboing/clic-config/raw/master/clic-hosts). After that you need to choose a desktop id for the new desktop to start. Be reminded that the desktop id is unique for each host, so you need to pick a desktop id which nobody has been using. You can use the command

```
ls -al /tmp/.X11-unix
```

to see the currently running desktop and their corresponding user. For instance, I would like to choose an available desktop of id 10. I could then use

```
vncserver :10 -geometry 1920x1080 -localhost
```

to start a virtual desktop of id 10 of resolution 1920x1080 on the host "baghdad" which only accept connection from localhost. I would always prefer the "-localhost" (only allow local connection) option to prevent security issue since otherwise the port will be open to the whole world. If you invoke "vncserver" for the first time, it will prompt you to enter a password. Note that only the first 8 characters will actually count. 

## Connect to Virtual Desktop ##

To connect to the desktop, first use the SSH client to tunnel the VNC port from the CLIC machine to your own computer. In my case, I would use

```
ssh -L 8080:localhost:5910 bg2539@baghdad.clic.cs.columbia.edu
```

This essentially forward all traffic sent to localhost:8080 from my own computer to localhost:5910 on the remote CLIC host. You can choose a different local port number rather than 8080 if there is another program which happens to listen to the same port. However you need to specify 5910 as the port number on the remote host, since by default, VNC Server listens to the port of 5900 plus the desktop id. Then I could use any VNC client to connect to localhost:8080. For example,

```
vncviewer ::8080
```

You should be able to see the GNOME desktop after typing in your password.

I also found that tightvnc has a nice Java version which could do SSH tunneling along with the VNC connection. The Java version also runs on the library machines:) If you ever need to use it, go to http://www.tightvnc.com/download.php and download. Be aware that the Java version will prompt for the SSH password first and the VNC password later.

Sample config of tightvnc Java looks like the following:

```
Remote Host: localhost
       Port: 5910

[x] Use SSH tunneling
 SSH Server: baghdad.clic.cs.columbia.edu
   SSH Port: 22
   SSH User: bg2539
```

## Kill Running Desktop ##

You can terminate a running desktop using the "vncserver" program as well. Assume you want to kill the desktop of id 10 that previously created,

```
vncserver -kill :10
```

Please be careful that any GUI process running on the desktop of id 10 will be terminated immediately.

## Security ##

Although the VNC connection itself is not encrypted, the SSH Server will encrypt all the data tunneled. Still, you are recommended to change your VNC password regularly by using

```
vncpasswd
```

## Miscellaneous Issues ##

If you encounter malfunction of text selection using mouse, disable "Accept clipboard from viewers" and "Send clipboard to viewers" in the VNC config dialog box. You can click the icon in the taskbar to bring the VNC config box to front.
