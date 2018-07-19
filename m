From: Mike Christie <mchristi@redhat.com>
Date: Thu, 19 Jul 2018 16:38:05 +0000
Subject: Re: [PATCH 11/15] target: export initiator port values for all sessions
Message-Id: <5B50BE6D.1090902@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 07/19/2018 10:37 AM, Bart Van Assche wrote:
> On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
>> +	if (se_sess->se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
>> +		len = snprintf(page, PAGE_SIZE, "%s 0x%6phN\n",
>> +			       se_sess->se_node_acl->initiatorname,
>> +			       &se_sess->sess_bin_isid);
>> +	} else {
>> +		len = snprintf(page, PAGE_SIZE, "%s\n",
>> +			       se_sess->se_node_acl->initiatorname);
>> +	}
> 
> Hello Mike,
> 
> The general recommendation for configfs is that each attribute contains a
> single value, just like for sysfs. Patch 11/15 exports two values through
> a single attribute. Have you considered to split the above into two

What about just making it the initiator port transport id so it aligns
with the get_initiator_port_transport_id() comment for the other patch.
For iscsi it would be 1 value with the format from SPC/SAM
"target_name,i,0x,isid"?


> attributes, namely the initiator name and the ISID? Can the initiator name
> be changed into a soft link to the se_node_acl configfs directory to make
> it easy for shell scripts to retrieve additional initiator configuration
> information?

Because the kernel is creating the session instead of it being driven
from a mkdir, there are no existing functions for this. I do not know
configfs code well, but I think making a function to do this is possible
though.

What about the dynamic_acl case? Just make those a normal file?

Just to make sure we are on the same page too. The initiator name is
always the name of the acl right? It looked like that from
target_fabric_make_nodeacl but I was wondering if you are asking for the
symlink because there are some fabric module quirks where that is not
the case. If it's the same names, then you know the acl already from the
initiator name file.

> 
> Thanks,
> 
> Bart.
> 

