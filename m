From: Greg-KH <gregkh@linuxfoundation.org>
Date: Sun, 19 Nov 2017 10:23:47 +0000
Subject: Re: [PATCH-3.18.y 2/2] iscsi-target: Fix iscsi_np reset hung task during parallel delete
Message-Id: <20171119102347.GC12993@kroah.com>
List-Id: <target-devel.vger.kernel.org>
References: <1510813060-15334-1-git-send-email-nab@linux-iscsi.org>
 <1510813060-15334-3-git-send-email-nab@linux-iscsi.org>
 <20171116164642.GI24442@kroah.com>
 <5A0DDA74.3060102@redhat.com>
In-Reply-To: <5A0DDA74.3060102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, stable <stable@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On Thu, Nov 16, 2017 at 12:35:32PM -0600, Mike Christie wrote:
> On 11/16/2017 10:46 AM, Greg-KH wrote:
> > 
> > What is the git commit id of this patch in Linus's tree?
> > 
> 
> It's 978d13d60c34818a41fc35962602bdfa5c03f214

Thanks, now queued up.

greg k-h
