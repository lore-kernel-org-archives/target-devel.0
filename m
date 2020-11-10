From: Jason Wang <jasowang@redhat.com>
Date: Tue, 10 Nov 2020 02:50:29 +0000
Subject: Re: [PATCH 06/11] vhost: support delayed vq creation
Message-Id: <5a64e2d5-1b8b-7bc6-2793-a34206c59d75@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
 <1604528804-2878-7-git-send-email-michael.christie@oracle.com>
 <56056e8d-d6ff-9a6e-2a7e-1ea1737b1d27@redhat.com>
 <54285b79-637e-3dcd-382f-ddeff44f6019@oracle.com>
 <fc22b679-08c1-85bb-515a-8f63de7148a2@oracle.com>
In-Reply-To: <fc22b679-08c1-85bb-515a-8f63de7148a2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org


On 2020/11/10 上午4:30, Mike Christie wrote:
> On 11/9/20 12:41 PM, Mike Christie wrote:
>>
>> If you want to pair this patchset down to it's bare bug fixes that 
>> prevent users from getting IO errors, I would do ring.addr check only 
>> approach for this bug fix patchset.
>
> Oh yeah, just so we don't have to burn an extra day, above I'm 
> proposing I repost the original patchset:
>
> https://lore.kernel.org/linux-scsi/1600712588-9514-1-git-send-email-michael.christie@oracle.com/t/ 
>
>
> for the bug fix only patches. It will have the compile error fixed and 
> Bart's comment handled.
>
> To even trim it down more I can also drop the last 2 patches:
>
> 0007-vhost-remove-work-arg-from-vhost_work_flush.patch
> 0008-vhost-scsi-remove-extra-flushes.patch
>
> and send separately in a cleanups patchset since the extra flushes it 
> kills don't really hurt.


Fine with me.

Thanks
