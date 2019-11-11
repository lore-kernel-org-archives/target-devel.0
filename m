From: Mike Christie <mchristi@redhat.com>
Date: Mon, 11 Nov 2019 18:55:46 +0000
Subject: Re: [PATCH 0/2] Improve SPC-2 reservation support
Message-Id: <5DC9AEB2.4050202@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191111182944.191123-1-bvanassche@acm.org>
In-Reply-To: <20191111182944.191123-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/11/2019 12:29 PM, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series improves support for SPC-2 reservations in the SCSI target
> code. Please consider these patches for inclusion in the v5.5 kernel.
> 
> Thanks,
> 
> Bart.
> 
> Bart Van Assche (2):
>   target/core: Declare target_release_reservation() 'static'
>   target/iscsi: Fix a use-after-free while closing a session
> 

Patches look and tested ok for me.

Reviewed-by: Mike Christie <mchristi@redhat.com>
