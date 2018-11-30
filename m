From: David Disseldorp <ddiss@suse.de>
Date: Fri, 30 Nov 2018 13:17:49 +0000
Subject: Re: [PATCH v4 6/7] target: remove hardcoded T10 Vendor ID in INQUIRY response
Message-Id: <20181130141749.608a9ebe@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-7-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-7-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 29 Nov 2018 08:35:26 -0800, Bart Van Assche wrote:

> Where is the code that initializes dev->t10_wwn.vendor to "LIO-ORG"? Did I
> perhaps overlook something?

This is done in target_configure_device() .

> Additionally, why are you using strnlen() for
> a string of which it is guaranteed that its length is less than or equal to
> the second strnlen() argument?

Belt and braces :) Actually, I think it's a little more readable this
way.

Cheers, David
