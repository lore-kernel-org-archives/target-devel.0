From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 25 Oct 2019 00:20:45 +0000
Subject: Re: [PATCH V2 0/3] iscsi: chap: introduce support for SHA1, SHA256 and SHA3-256
Message-Id: <yq1k18td6aq.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191017131037.9903-1-mlombard@redhat.com>
In-Reply-To: <20191017131037.9903-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Hi Maurizio,

> iSCSI with the Challenge-Handshake Authentication Protocol is not FIPS
> compliant.  This is due to the fact that CHAP currently uses MD5 as
> the only supported digest algorithm and MD5 is not allowed by FIPS.
>
> When FIPS mode is enabled on the target server, the CHAP
> authentication won't work because the target driver will be prevented
> from using the MD5 module.
>
> Given that CHAP is agnostic regarding the algorithm it uses, this
> patchset introduce support for three new alternatives: SHA1, SHA256
> and SHA3-256.

Can you please submit these on top of 5.5/scsi-queue which has your
string parsing fixes in place?

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
