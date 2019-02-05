From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 05 Feb 2019 02:31:01 +0000
Subject: Re: [PATCH] target: make the pi_prot_format ConfigFS path readable
Message-Id: <67fb72d3-0184-d52b-d909-ceff30d50969@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20190204183210.8386-1-ddiss@suse.de>
In-Reply-To: <20190204183210.8386-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 2/4/19 10:32 AM, David Disseldorp wrote:
> pi_prot_format conversion to write-only caused userspace breakage. Make
> the ConfigFS path readable again and hardcode the "0\n" content,
> matching previous output.
> 
> Fixes: 6baca7601bde ("scsi: target: drop unused pi_prot_format attribute storage")
> Link: https://bugzilla.redhat.com/show_bug.cgi?id67505
> Reported-by: Lee Duncan <lduncan@suse.com>
> Reported-by: Laura Abbott <labbott@redhat.com>
> Signed-off-by: David Disseldorp <ddiss@suse.de>

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
