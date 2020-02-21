From: David Disseldorp <ddiss@suse.de>
Date: Fri, 21 Feb 2020 09:52:17 +0000
Subject: Re: [PATCH v2 2/2] scsi: target: convert boolean se_dev_attrib types to bool
Message-Id: <20200221105217.27470200@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200219130136.18946-3-ddiss@suse.de>
In-Reply-To: <20200219130136.18946-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 19 Feb 2020 23:06:16 +0100, David Disseldorp wrote:

> On Wed, 19 Feb 2020 09:37:48 -0800, Bart Van Assche wrote:
> 
> > How about introducing an enum type for emulate_ua_intlck_ctrl? Anyway:  
> 
> Yes, that'd make sense. I'll send it as a separate follow up when I get
> a chance.

I've sent the follow up as <20200221094401.32021-1-ddiss@suse.de>. It's
dependent on this patch set.

Cheers, David
