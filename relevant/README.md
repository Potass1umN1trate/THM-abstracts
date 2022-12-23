# Relevant
# Penetration Testing Challenge
#
# INFO:
# You have been assigned to a client that wants a penetration test conducted on an environment due to be released to production in seven days. 
# 
# Scope of Work
#
# The client requests that an engineer conducts an assessment of the provided virtual environment. The client has asked that minimal information be provided about the assessment, wanting the engagement conducted from the eyes of a malicious actor (black box penetration test).  The client has asked that you secure two flags (no location provided) as proof of exploitation:
#
#     User.txt
#     Root.txt
#
# Additionally, the client has provided the following scope allowances:
#
#     Any tools or techniques are permitted in this engagement, however we ask that you attempt manual exploitation first
#     Locate and note all vulnerabilities found
#     Submit the flags discovered to the dashboard
#     Only the IP address assigned to your machine is in scope
#     Find and report ALL vulnerabilities (yes, there is more than one path to root)
#
# (Roleplay off)
# I encourage you to approach this challenge as an actual penetration test. Consider writing a report, to include an executive summary, vulnerability and exploitation assessment, and remediation suggestions, as this will benefit you in preparation for the eLearnSecurity Certified Professional Penetration Tester or career as a penetration tester in the field.
#
# Note - Nothing in this room requires Metasploit
#
# Machine may take up to 5 minutes for all services to start.
#
# **Writeups will not be accepted for this room.**
#
# QUESTIONS:
# 1. User flag
# 2. Root flag

# Adding an IP address of the machine to environment variables
export IP=10.10.100.134

# Scanning open ports via nmap
nmap $IP -sT -sV -sV -oA nmap/res

Starting Nmap 7.92 ( https://nmap.org ) at 2022-12-16 14:52 EST
Nmap scan report for 10.10.100.134
Host is up (0.098s latency).
Not shown: 995 filtered tcp ports (no-response)
PORT     STATE SERVICE            VERSION
80/tcp   open  http               Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
135/tcp  open  msrpc              Microsoft Windows RPC
139/tcp  open  netbios-ssn        Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds       Microsoft Windows Server 2008 R2 - 2012 microsoft-ds
3389/tcp open  ssl/ms-wbt-server?
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 117.22 seconds

# Checking website 
# Starting dirbusting
