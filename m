From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Thu, 19 Jul 2018 17:07:59 +0000
Subject: Re: [PATCH 11/15] target: export initiator port values for all sessions
Message-Id: <4dc16288f0dd9723056e83aa4079986ebfd30127.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 2018-07-19 at 11:38 -0500, Mike Christie wrote:
+AD4- On 07/19/2018 10:37 AM, Bart Van Assche wrote:
+AD4- +AD4- The general recommendation for configfs is that each attribute contains a
+AD4- +AD4- single value, just like for sysfs. Patch 11/15 exports two values through
+AD4- +AD4- a single attribute. Have you considered to split the above into two
+AD4- 
+AD4- What about just making it the initiator port transport id so it aligns
+AD4- with the get+AF8-initiator+AF8-port+AF8-transport+AF8-id() comment for the other patch.
+AD4- For iscsi it would be 1 value with the format from SPC/SAM
+AD4- +ACI-target+AF8-name,i,0x,isid+ACI-?

That sounds fine to me.

+AD4- +AD4- attributes, namely the initiator name and the ISID? Can the initiator name
+AD4- +AD4- be changed into a soft link to the se+AF8-node+AF8-acl configfs directory to make
+AD4- +AD4- it easy for shell scripts to retrieve additional initiator configuration
+AD4- +AD4- information?
+AD4- 
+AD4- Because the kernel is creating the session instead of it being driven
+AD4- from a mkdir, there are no existing functions for this. I do not know
+AD4- configfs code well, but I think making a function to do this is possible
+AD4- though.

Initially configfs did not support creation of a directory from the kernel
side. Last time I brought this up with Christoph he replied that this
functionality has been added to configfs (if I understood Christoph
correctly).

+AD4- What about the dynamic+AF8-acl case? Just make those a normal file?

I'm not that familiar with dynamic ACLs. Is there a difference between
+ACI-dynamic ACL+ACI- generation and +ACI-demo mode+ACI-? How does this interact with the
generate+AF8-node+AF8-acls mode?
 
+AD4- Just to make sure we are on the same page too. The initiator name is
+AD4- always the name of the acl right? It looked like that from
+AD4- target+AF8-fabric+AF8-make+AF8-nodeacl but I was wondering if you are asking for the
+AD4- symlink because there are some fabric module quirks where that is not
+AD4- the case. If it's the same names, then you know the acl already from the
+AD4- initiator name file.

It depends on what is called the +ACI-initiator name+ACI-. E.g. the SRP target
driver supports multiple formats to refer to a single initiator port. The
first version of the ib+AF8-srpt driver supported only 128-bit GIDs as initiator
name. Since the 64-bit prefix of a GID may change due to a reboot, later
on support for 64-bit GUIDs was added. During login three formats for
the initiator name are verified: GID, GUID without +ACI-0x+ACI- prefix and GUID
with +ACI-0x+ACI- prefix. In any case, target+AF8-alloc+AF8-session() will store a
pointer to the first struct se+AF8-node+AF8-acl that matches in sess-+AD4-se+AF8-node+AF8-acl.
I think using the name stored in struct se+AF8-node+AF8-acl is fine in all cases.

Bart.