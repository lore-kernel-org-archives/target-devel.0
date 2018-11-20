From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 20 Nov 2018 16:49:24 +0000
Subject: Re: [PATCH v3 2/4] target: don't assume t10_wwn.vendor is null terminated
Message-Id: <20181120164924.GB26041@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181119210636.22979-3-ddiss@suse.de>
In-Reply-To: <20181119210636.22979-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This could use a little more explanation, the code doesn't just
add a little if but also changes the existing case.  Also where
can't it be null currently?
