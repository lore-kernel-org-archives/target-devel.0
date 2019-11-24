From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Sun, 24 Nov 2019 19:15:41 +0000
Subject: Re: [EXT] [PATCH v2 13/15] scsi: qla2xxx: Add async mode for qla24xx_els_dcmd_iocb
Message-Id: <20191124191541.ly3kjofunx7lm77q@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-14-r.bolshakov@yadro.com>
 <BYAPR18MB2759E4C4CDDA0D5447D7A5BDD54E0@BYAPR18MB2759.namprd18.prod.outlook.com>
 <81096D5B-FEC9-4A40-BE7B-ADB8CA1C5CA2@nutanix.com>
In-Reply-To: <81096D5B-FEC9-4A40-BE7B-ADB8CA1C5CA2@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Harvey <mark.harvey@nutanix.com>
Cc: Quinn Tran <qutran@marvell.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux@yadro.com" <linux@yadro.com>

On Fri, Nov 22, 2019 at 05:04:52AM +0000, Mark Harvey wrote:
> Would this not result in a memory leak in the 'else' path - skiping sp->free(sp)?
>   
>   -	wait_for_completion(&elsio->u.els_logo.comp);
>     +	if (wait) {
>     +		wait_for_completion(&elsio->u.els_logo.comp);
>     +	} else {
>     +		goto done;
>     +	}
>      
>      	sp->free(sp);
>     +done:
>      	return rval;
>      }
> 

Hi Mark,

Good catch, it definetely will be a leak. I had this on mind but forgot
while rushing to post v2. I'll add proper cleanup in v3.

Thank you,
Roman
