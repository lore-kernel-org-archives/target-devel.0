From: David Disseldorp <ddiss@suse.de>
Date: Mon, 10 Dec 2018 13:36:50 +0000
Subject: Re: [RFC PATCH] target: sanitize ALUA and PR state file paths before use
Message-Id: <20181210143650.64c254df@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181122133800.1251-1-ddiss@suse.de>
In-Reply-To: <20181122133800.1251-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Ping - any feedback on this change?

On Thu, 22 Nov 2018 14:38:00 +0100, David Disseldorp wrote:

> Block ALUA and PR state storage if any of the dynamic subdirectory
> components include a path separator.
> 
> Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
> Note:
> Submitted as an RFC, as I've not properly tested the alua code path.
> I'm also not sure whether it's reasonable to break existing setups
> with a '/' in the configured unit_serial. Where "break" means fail
> APTPL PR requests; ALUA state-save failures are ignored internally.

I'd also be happy with any pointers on properly testing ALUA.

Cheers, David
