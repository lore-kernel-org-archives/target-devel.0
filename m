From: David Disseldorp <ddiss@suse.de>
Date: Mon, 04 Jun 2018 11:36:06 +0000
Subject: Re: [PATCH] target: fix truncated PR-in ReadKeys response
Message-Id: <20180604133606.6a9fb71d@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180531222054.32655-1-ddiss@suse.de>
In-Reply-To: <20180531222054.32655-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 4 Jun 2018 14:16:45 +0300, Maged Mokhtar wrote:

> This also fixes an issue in Windows server 2016 failover cluster with
> many client connections, the initial allocation length sent in cdb is
> 72 bytes which  limits it to 8 keys, with additional length not affected
> by truncation, it will retry with correct size.

Interesting coincidence :) I only ran into this while looking at the
spec for the enable_pr change. Can you confirm that this fixes Win 2016
PR behaviour with an iblock / ifile backstore? If so I'll respin the
patch with an extra note in the commit message.

Cheers, David
