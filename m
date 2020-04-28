From: Mike Christie <mchristi@redhat.com>
Date: Tue, 28 Apr 2020 17:06:46 +0000
Subject: Re: [PATCH 08/11] target: add sysfs session helper functions
Message-Id: <3b071301-3fc4-bc5b-d367-a9e9d5595e0e@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200428061109.3042-1-mchristi@redhat.com>
 <20200428061109.3042-9-mchristi@redhat.com>
 <1c97ee38-7a0e-5aac-6065-41267baea648@acm.org>
In-Reply-To: <1c97ee38-7a0e-5aac-6065-41267baea648@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 4/28/20 11:43 AM, Bart Van Assche wrote:
> On 2020-04-27 23:11, Mike Christie wrote:
>> +	ret = kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "session-%d",
>> +			  se_sess->sid);
>> +	if (ret) {
>> +		pr_err("Could not add session%d to sysfs. Error %d.\n",
>> +		       se_sess->sid, ret);
>> +		goto free_acl_name;
>> +	}
> 
> Has it been considered to derive the directory name for a session from
> the initiator name (se_node_acl.initiatorname-%d)? Would that be more
> convenient for users than the session-%d naming scheme?

It seems nicer. I can do the initaitorname-%d.

It will also handle the iscsi case where we have multiple sessions from
the same initiator to the same target port.

> 
> Thanks,
> 
> Bart.
> 
