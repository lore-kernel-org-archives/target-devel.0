From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Date: Thu, 21 May 2020 20:38:21 +0000
Subject: RE: [PATCH 3/3] target: rename target_setup_cmd_from_cdb() to target_parse_cdb()
Message-Id: <a5497b1c-0f60-4b94-bc3c-f3ac29eddefe@default>
List-Id: <target-devel.vger.kernel.org>
References: <1590082959-1034-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <8cde32d4-eef3-ec4c-9a0e-54c896e90ccc@redhat.com>
In-Reply-To: <8cde32d4-eef3-ec4c-9a0e-54c896e90ccc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, Martin Petersen <martin.petersen@oracle.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shirley Ma <shirley.ma@oracle.com>, ssudhakarp@gmail.com

> Maybe the naming would be nicer if we did:
> 
> target_init_cmd_cdb
> and
> target_parse_cmd_cdb
> 
> This would match each other's pattern and also match the style of the
> other cmd related function naming where its "target or transport"
> prefix, verb, cmd then optionally something extra.
> 
> Or maybe:
> 
> target_cmd_init_cdb
> and
> target_cmd_parse_cdb
> 
> so they at least match each other and you get an idea they pair together.
> 
> Just a suggestion and not a requirement, because I'm pretty bad at
> naming, so I have no idea if its better or not.
> 

Thank you Mike, Nice suggestion. I will incorporate the name change and send out another patch shortly.

Thanks
Sudhakar
