From: David Disseldorp <ddiss@suse.de>
Date: Mon, 10 Dec 2018 19:35:03 +0000
Subject: Re: [RFC PATCH] target: sanitize ALUA and PR state file paths before use
Message-Id: <20181210203503.0ff26a3c@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181122133800.1251-1-ddiss@suse.de>
In-Reply-To: <20181122133800.1251-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 10 Dec 2018 11:19:59 -0800, Bart Van Assche wrote:

> Embedding SCSI properties like the unit serial number in a file system path
> seems wrong to me.

I completely agree, but unfortunately that's where we currently stand.

> I think the path in which these properties are stored
> should be derived from configfs item names configured by the user. These
> names are guaranteed to be ASCII strings. If you want to see an example of
> alternative approach you are welcome to have a look at scst_pr_set_file_name()
> and scst_pr_sync_device_file() in the SCST source code.

Sounds reasonable, although that would leave us with the task of
migrating consumers of the existing unit-serial-number derived paths
to use the new state file locations.

> Regarding testing ALUA code: I use sg_rtpg and sg_stpg to test SCSI target
> ALUA code.

Thanks, I'll have a play with them.

Cheers, David
