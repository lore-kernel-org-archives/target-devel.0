From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 14 Oct 2019 21:51:26 +0000
Subject: Re: [PATCH] target: do not overwrite CDB byte 1
Message-Id: <623feb9c-cca8-621c-849e-3e7702f00782@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <12498eab-76fd-eaad-1316-c2827badb76a@ts.fujitsu.com>
In-Reply-To: <12498eab-76fd-eaad-1316-c2827badb76a@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/14/19 11:29 AM, Bodo Stroesser wrote:
> passthrough_parse_cdb() - used by TCMU and PSCSI - attepts to
> reset the LUN field of SCSI-2 CDBs (bits 5,6,7 of byte 1).
> The current code is wrong, as for newer commands not having the
> LUN field it overwrites relevant command bits (e.g. for SECURITY
> PROTOCOL IN / OUT)
> We think this code was unnecessary from the beginning or at least
> it is no longer useful. So we remove it entirely.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
