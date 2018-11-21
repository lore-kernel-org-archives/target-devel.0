From: Mike Christie <mchristi@redhat.com>
Date: Wed, 21 Nov 2018 03:29:30 +0000
Subject: Re: [PATCH v5] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <5BF4D11A.2080304@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181107131107.7426-1-ddiss@suse.de>
In-Reply-To: <20181107131107.7426-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/07/2018 07:11 AM, David Disseldorp wrote:
> The new emulate_pr backstore attribute allows for Persistent Reservation
> and SCSI2 RESERVE/RELEASE support to be completely disabled. This can be
> useful for scenarios such as:
> - Ensuring ATS (Compare & Write) usage on recent VMware ESXi initiators.
> - Allowing clustered (e.g. tcm-user) backends to block such requests,
>   avoiding the multi-node reservation state propagation.
> 
> When explicitly disabled, PR and RESERVE/RELEASE requests receive
> Invalid Command Operation Code response sense data.
> 

Reviewed-by: Mike Christie <mchristi@redhat.com>
