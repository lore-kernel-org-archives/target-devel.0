From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 21 Sep 2018 02:38:33 +0000
Subject: Re: [PATCH v5] target/iblock: split T10 PI SGL across command bios
Message-Id: <yq18t3vmv6e.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180904171910.21802-1-gedwards@ddn.com>
In-Reply-To: <20180904171910.21802-1-gedwards@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Greg,

> Split the PI SGL across the bios in the command, so each bio's
> bio_integrity_payload contains the protection information for the data
> in the bio.

That is indeed how the bio integrity code is intended to be used. I have
queued it up. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
