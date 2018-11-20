From: David Disseldorp <ddiss@suse.de>
Date: Tue, 20 Nov 2018 17:37:08 +0000
Subject: Re: [PATCH v3 2/4] target: don't assume t10_wwn.vendor is null terminated
Message-Id: <20181120183708.26d2d177@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181119210636.22979-3-ddiss@suse.de>
In-Reply-To: <20181119210636.22979-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, 20 Nov 2018 08:49:24 -0800, Christoph Hellwig wrote:

> This could use a little more explanation, the code doesn't just
> add a little if but also changes the existing case.  Also where
> can't it be null currently?

I'll add an explanation in the next round. This patch shouldn't cause
any change in behaviour. The vendor string is currently always NULL
terminated, but won't be once patch 3/4 is applied, hence the need to
add the maximum string width specifier.

Thanks for the feedback.
