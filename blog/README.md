# Blog<br/>Billy Joel made a Wordpress blog! 

Billy Joel made a blog on his home computer and has started working on it.  It's going to be so awesome!
Enumerate this box and find the 2 flags that are hiding on it!  Billy has some weird things going on his laptop.  Can you maneuver around and get what you need?  Or will you fall down the rabbit hole...
In order to get the blog to work with AWS, you'll need to add blog.thm to your /etc/hosts file.
Credit to Sq00ky for the root privesc idea ;)

**Difficulty: Medium**

**Questions:**
1. root.txt
2. user.txt
3. Where was user.txt found?
4. What CMS was Billy using?
5. What version of the above CMS was being used?
_________________________________________________
> adding ip to /etc/hosts

### scanning via nmap
```
nmap blog.thm -sC -sV -oA nmap/out

Starting Nmap 7.92 ( https://nmap.org ) at 2022-12-23 03:41 EST
Stats: 0:00:35 elapsed; 0 hosts completed (1 up), 1 undergoing Script Scan
NSE Timing: About 94.94% done; ETC: 03:41 (0:00:00 remaining)
Nmap scan report for blog.thm (10.10.253.178)
Host is up (0.14s latency).
Not shown: 996 closed tcp ports (conn-refused)
PORT    STATE SERVICE     VERSION
22/tcp  open  ssh         OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 57:8a:da:90:ba:ed:3a:47:0c:05:a3:f7:a8:0a:8d:78 (RSA)
|   256 c2:64:ef:ab:b1:9a:1c:87:58:7c:4b:d5:0f:20:46:26 (ECDSA)
|_  256 5a:f2:62:92:11:8e:ad:8a:9b:23:82:2d:ad:53:bc:16 (ED25519)
80/tcp  open  http        Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-generator: WordPress 5.0
| http-robots.txt: 1 disallowed entry 
|_/wp-admin/
|_http-title: Billy Joel&#039;s IT Blog &#8211; The IT blog
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp open  netbios-ssn Samba smbd 4.7.6-Ubuntu (workgroup: WORKGROUP)
Service Info: Host: BLOG; OS: Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb-os-discovery: 
|   OS: Windows 6.1 (Samba 4.7.6-Ubuntu)
|   Computer name: blog
|   NetBIOS computer name: BLOG\x00
|   Domain name: \x00
|   FQDN: blog
|_  System time: 2022-12-23T08:41:52+00:00
|_clock-skew: mean: 1s, deviation: 0s, median: 0s
| smb2-time: 
|   date: 2022-12-23T08:41:52
|_  start_date: N/A
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
|_nbstat: NetBIOS name: BLOG, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 41.04 seconds
```

### dirbusting web-site
```
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://blog.thm/
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Extensions:              py,txt,js,css,dic,zip,php
[+] Timeout:                 10s
===============================================================
2022/12/23 03:45:37 Starting gobuster in directory enumeration mode
===============================================================
/index.php            (Status: 301) [Size: 0] [--> http://blog.thm/]
/rss                  (Status: 301) [Size: 0] [--> http://blog.thm/feed/]
/login                (Status: 302) [Size: 0] [--> http://blog.thm/wp-login.php]
/feed                 (Status: 301) [Size: 0] [--> http://blog.thm/feed/]       
/0                    (Status: 301) [Size: 0] [--> http://blog.thm/0/]          
/atom                 (Status: 301) [Size: 0] [--> http://blog.thm/feed/atom/]  
/wp-content           (Status: 301) [Size: 309] [--> http://blog.thm/wp-content/]
/admin                (Status: 302) [Size: 0] [--> http://blog.thm/wp-admin/]    
/welcome              (Status: 301) [Size: 0] [--> http://blog.thm/2020/05/26/welcome/]
/wp-login.php         (Status: 200) [Size: 3087]                                       
/w                    (Status: 301) [Size: 0] [--> http://blog.thm/2020/05/26/welcome/]
/n                    (Status: 301) [Size: 0] [--> http://blog.thm/2020/05/26/note-from-mom/]
/rss2                 (Status: 301) [Size: 0] [--> http://blog.thm/feed/]                    
Progress: 5448 / 1764488 (0.31%)                    
```
