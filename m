From: Michael Christie <michael.christie@oracle.com>
Date: Tue, 22 Sep 2020 15:34:10 +0000
Subject: Re: [PATCH 2/8] vhost: add helper to check if a vq has been setup
Message-Id: <63A53BA5-653D-4DCA-88C3-812A3607FC2E@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-3-git-send-email-michael.christie@oracle.com>
 <ce73f019-a247-7913-47fd-b3e5e7bdf81f@acm.org>
In-Reply-To: <ce73f019-a247-7913-47fd-b3e5e7bdf81f@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org



> On Sep 21, 2020, at 9:45 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> 
> On 2020-09-21 11:23, Mike Christie wrote:
>> +bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
>> +{
>> +	if (vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq))
>> +		return true;
>> +	else
>> +		return false;
>> +}
> 
> Has it been considered changing the body of this function into
> "return vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq)"? I'm

If we do not go the VHOST_SET_VRING_ENABLE route, then I'll do what you suggest.


> concerned otherwise one or another build bot will suggest to make that
> change.
