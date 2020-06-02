From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 02 Jun 2020 23:47:30 +0000
Subject: Re: [PATCH v3 2/3] target: fix NULL pointer dereference
Message-Id: <0ce0914e-6cd7-2aad-d144-c679cdfb86b0@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
 <58f5ec86-2791-a3c6-2c0d-94b717030c42@oracle.com>
 <3df40de4-ab01-4b9c-b727-f7fafbb82b29@default>
 <14f78832-9b81-4e96-0b4a-27d2acff6f71@oracle.com>
In-Reply-To: <14f78832-9b81-4e96-0b4a-27d2acff6f71@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, Martin Petersen <martin.petersen@oracle.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shirley Ma <shirley.ma@oracle.com>



On 6/2/20 6:26 PM, Mike Christie wrote:
>>
> 
> Maybe you need a new trace call for the case where we can't fully 
> initialize the cmd. It could be used for cases like where 
> transport_generic_new_cmd is used directly but fails, the 
> transport_handle_queue_full case, and your case where we fail during the 
> initial setup.

Ignore the transport_handle_queue_full case. I thought we had drivers 
using it when they initially read commands in, but that's not the case 
so the cmd is always setup in that function.
