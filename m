From: Jason Wang <jasowang@redhat.com>
Date: Mon, 02 Nov 2020 06:49:42 +0000
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
Message-Id: <cf74844c-bfa6-e66c-fc3a-07dfd7af3092@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
 <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
 <49c2fc29-348c-06db-4823-392f7476d318@oracle.com>
 <20201030044402-mutt-send-email-mst@kernel.org>
 <688e46b6-77f1-1629-0c93-e3a27d582da5@redhat.com>
In-Reply-To: <688e46b6-77f1-1629-0c93-e3a27d582da5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: "Michael S. Tsirkin" <mst@redhat.com>, Mike Christie <michael.christie@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel@vger.kernel.org, stefanha@redhat.com, pbonzini@redhat.com


On 2020/11/2 下午2:36, Jason Wang wrote:
>>
>> The need to share event/control vqs between devices is a problem though,
>> and sending lots of ioctls on things like reset is also not that 
>> elegant.
>> Jason, did you have a good solution in mind?
>
>
> Nope, I'm not familiar with SCSI so I don't even know sharing evt/cvq 
> is possible. Consider VHOST_SCSI_MAX_VQ is already 128 per device. 
> Mike's proposal seems to be better.
>
> Thanks 


Btw, it looks to me vhost_scsi_do_evt_work() has the assumption of iovec 
layout which needs to be fixed.

Thanks
