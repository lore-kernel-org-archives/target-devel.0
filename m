From: David Disseldorp <ddiss@suse.de>
Date: Wed, 28 Nov 2018 16:44:45 +0000
Subject: Re: [PATCH v3 3/4] target: add device vendor_id configfs attribute
Message-Id: <20181128174445.56b69848@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181119210636.22979-4-ddiss@suse.de>
In-Reply-To: <20181119210636.22979-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Bart,

On Wed, 28 Nov 2018 08:36:19 -0800, Bart Van Assche wrote:

> Maybe I'm missing something, but why is zeroing of unused bytes in these functions
> necessary? Would the following be correct if all strings in struct t10_wwn would be
> '\0'-terminated?

Your patch looks good to me. Mind if I tack it on to the end of my
t10_wwn.vendor/model/revision[size+1] patchset, with your authorship?

Cheers, David
