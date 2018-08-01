From: Mike Christie <mchristi@redhat.com>
Date: Wed, 01 Aug 2018 16:44:05 +0000
Subject: Re: [PATCH 11/15] target: export initiator port values for all sessions
Message-Id: <5B61E355.1060709@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 07/19/2018 12:07 PM, Bart Van Assche wrote:
> On Thu, 2018-07-19 at 11:38 -0500, Mike Christie wrote:
>> On 07/19/2018 10:37 AM, Bart Van Assche wrote:
>>> The general recommendation for configfs is that each attribute contains a
>>> single value, just like for sysfs. Patch 11/15 exports two values through
>>> a single attribute. Have you considered to split the above into two
>>
>> What about just making it the initiator port transport id so it aligns
>> with the get_initiator_port_transport_id() comment for the other patch.
>> For iscsi it would be 1 value with the format from SPC/SAM
>> "target_name,i,0x,isid"?
> 
> That sounds fine to me.
> 
>>> attributes, namely the initiator name and the ISID? Can the initiator name
>>> be changed into a soft link to the se_node_acl configfs directory to make
>>> it easy for shell scripts to retrieve additional initiator configuration
>>> information?
>>
>> Because the kernel is creating the session instead of it being driven
>> from a mkdir, there are no existing functions for this. I do not know
>> configfs code well, but I think making a function to do this is possible
>> though.
> 
> Initially configfs did not support creation of a directory from the kernel
> side. Last time I brought this up with Christoph he replied that this
> functionality has been added to configfs (if I understood Christoph
> correctly).
> 
>> What about the dynamic_acl case? Just make those a normal file?
> 
> I'm not that familiar with dynamic ACLs. Is there a difference between
> "dynamic ACL" generation and "demo mode"? How does this interact with the
> generate_node_acls mode?

Ah sorry, I think I made up that term. I was referring to when
se_node_acl->dynamic_node_acl=1, so generate_node_acls=1 and demo mode
and dynamic_node_acl=1 is the same state.

>  
>> Just to make sure we are on the same page too. The initiator name is
>> always the name of the acl right? It looked like that from
>> target_fabric_make_nodeacl but I was wondering if you are asking for the
>> symlink because there are some fabric module quirks where that is not
>> the case. If it's the same names, then you know the acl already from the
>> initiator name file.
> 
> It depends on what is called the "initiator name". E.g. the SRP target
> driver supports multiple formats to refer to a single initiator port. The
> first version of the ib_srpt driver supported only 128-bit GIDs as initiator
> name. Since the 64-bit prefix of a GID may change due to a reboot, later
> on support for 64-bit GUIDs was added. During login three formats for
> the initiator name are verified: GID, GUID without "0x" prefix and GUID
> with "0x" prefix. In any case, target_alloc_session() will store a
> pointer to the first struct se_node_acl that matches in sess->se_node_acl.
> I think using the name stored in struct se_node_acl is fine in all cases.
> 

Hey Bart,

I did patches to add symlinks. There is one problem that this will break
userspace though.

The userspace tools assume that they can tear down a tpgt while sessions
are running because currently a rmdir on the acl will force running
sessions to be shutdown. For example, a FC or iscsi initiator can be
logged into the target and userspace currently does something like this
simplified sequence:

for each object under a tpgt
    ulink luns
    rmdir luns
    rmdir acls
    rmdir tpt

The problem is that because the session has a symlink to the acl and
configfs has done a config_item_get on the acl config_item to make sure
it does not get freed while in use the "rmdir acl" will now fail.

I agree knowing the acl info is useful, so how about the following:

1. Create a file named "acl" in the session's dir.
2. For dynamic_node_acl=0 the acl file will return a empty string or
"generate_node_acls=1" or "demo mode enabled".
3. For dynamic_node_acl=1 the acl file will return
se_node_acl->initiatorname which is the name of the acl in
..../tpgt_$N/acls/.

