From: Hou Pu <houpu@bytedance.com>
Date: Tue, 28 Jul 2020 03:16:42 +0000
Subject: Re: [PATCH v4 0/2] iscsi-target: fix login error when receiving is too fast
Message-Id: <8c4539d7-c8e5-2698-6d70-f255122fc596@bytedance.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200716100212.4237-1-houpu@bytedance.com>
 <a78662d5-0bb4-8b27-125e-b4c2176b70c6@oracle.com>
In-Reply-To: <a78662d5-0bb4-8b27-125e-b4c2176b70c6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: mchristi@redhat.com



On 2020/7/26 10:58 上午, Mike Christie wrote:
> On 7/16/20 5:02 AM, Hou Pu wrote:
>> Hi,
>> We encountered "iSCSI Login negotiation failed" several times.
>> After enable debug log in iscsi_target_nego.c of iSCSI target.
>> Error shows:
>>    "Got LOGIN_FLAGS_READ_ACTIVE=1, conn: xxxxxxxxxx >>>>"
>>
>> Patch 1 is trying to fix this problem. Please see comment in patch 1
>> for details.
>>
>> Sorry for delay of v4. Version 3 of this patchset could be found here[1].
>>
>> Changes from v4:
>> * In iscsi_target_do_login_rx(), call cancel_delayed_work() if it is final
>>    login pdu. Also call cancel_delayed_work() if current negotiation is failed.
>>    This is advised by Mike Christie. See below[1] for more details.
>>
>> Changes from v3:
>> * Fix style problem found by checkpatch.pl.
>>
> Ah sorry, I thought I replied a little later about my concerns being overly paranoid and your patch being ok. I don't see it on the list so not sure what happened.
> 
> If you are still not liking the cancel call, I'm ok with v3. Add my reviewed by to either version you prefer.
> 
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
> 

It took me some time to understand how workqueue works and make sure
it is safe to cancel it. So it is delayed between v3 and v4. Sorry
for that.

I think it is necessary to cancel delayed work as your suggestion.

Thanks,
Hou
