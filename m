From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 29 Nov 2018 20:46:48 +0000
Subject: Re: [PATCH v4 3/7] target: consistently null-terminate t10_wwn.model
Message-Id: <1543524408.99748.1.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-4-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 2018-11-29 at 21:31 +-0100, David Disseldorp wrote:
+AD4 On Thu, 29 Nov 2018 08:24:38 -0800, Bart Van Assche wrote:
+AD4 +AD4 On Thu, 2018-11-29 at 02:01 +-0100, David Disseldorp wrote:
+AD4 +AD4 +AD4 +AFs ... +AF0
+AD4 +AD4 Additionally, have you considered to use strlcpy()
+AD4 +AD4 instead of snprintf()?
+AD4 
+AD4 Happy to change the logic below over if you find it easier to follow.

It would make the code shorter without hurting readability, so I think
it would be better to use strlcpy(). But it's not that important to me.

Bart.
