From: David Disseldorp <ddiss@suse.de>
Date: Thu, 08 Nov 2018 12:54:50 +0000
Subject: Re: [PATCH 02/10] target/core: Use kvcalloc() instead of open-coding it
Message-Id: <20181108135450.72c52054@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181106171718.89594-3-bvanassche@acm.org>
In-Reply-To: <20181106171718.89594-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Looks reasonable. Any reason for dropping the extra __GFP flags?

Either way...
Reviewed-by: David Disseldorp <ddiss@suse.de>
