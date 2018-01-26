From: Andy Grover <agrover@redhat.com>
Date: Fri, 26 Jan 2018 19:45:37 +0000
Subject: New releases: targetcli.fb48, rtslib.fb65, configshell.fb24
Message-Id: <86ce9b04-916d-f66d-fe3f-5fe02fc40248@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi all,

These versions fix a number of issues, thanks to everyone who contributed!

(Personally, it's pretty much just review and release management these 
days. If there are improvements you'd like to see, please feel free to 
jump in :)

Github:
https://github.com/open-iscsi/targetcli-fb
https://github.com/open-iscsi/rtslib-fb
https://github.com/open-iscsi/configshell-fb

tarballs: via GitHub Releases

targetcli-fb 2.1.fb48:

Andy Grover <agrover@redhat.com> (1):
       version 2.1.fb48

Christophe Vu-Brugier <cvubrugier@fastmail.fm> (1):
       Replace dbus-python with GObject Introspection

David Disseldorp <ddiss@suse.de> (1):
       Auto-detect readonly state for iblock devices

Kenjiro Nakayama <nakayamakenjiro@gmail.com> (1):
       skip refreshing user backed storage object when it is null

Olaf Hering <olaf@aepfle.de> (1):
       remove wrong exit code from targetcli --version

Prasanna Kumar Kalever <prasanna.kalever@redhat.com> (4):
       config: defend on '/etc/target/backup' directory
       config: backup when current config is different from recent 
backup copy
       config: rename key 'kept_backups' as 'max_backup_files'
       backup: global option to tune max no. of backup conf files

Taylor Jakobson <tjakobs@us.ibm.com> (1):
       Read number of backup files to keep from file


rtslib-fb 2.1.fb65:

Andy Grover <agrover@redhat.com> (2):
       Remove hba-only directories in clear_existing()
       version 2.1.fb65

Christophe Vu-Brugier <cvubrugier@fastmail.fm> (3):
       Add missing dependency on six in setup.py
       Display a more meaningful error when targetcli cannot change "dbroot"
       Raise an error about failing to change the dbroot value only if 
the directory does not exist

Ji-Hyeon Gim <potatogim@potatogim.net> (1):
       More compatibility syntax for legacy distros

Olaf Hering <olaf@aepfle.de> (1):
       Correct name for Xen pvscsi


configshell-fb 1.1.fb24:

Andy Grover <agrover@redhat.com> (3):
       Handle if TERM is not set
       Fix path regex for [ and ]
       version 1.1.fb24

Christophe Vu-Brugier <cvubrugier@fastmail.fm> (1):
       Add missing dependency on pyparsing and six

Lee Duncan <lduncan@suse.com> (1):
       Remove explicit dependency on /usr/bin/python

Ryan Sawhill Aroha <rsaw@redhat.com> (2):
       tweak ConfigShell.run_stdin() to strip whitespace/newline from cmds
       make run_cmdline() log "Running command line" msg to new loglevel

Xiubo Li <lixiubo@cmss.chinamobile.com> (1):
       Fix failing to pasre par=val parameters


Regards -- Andy

