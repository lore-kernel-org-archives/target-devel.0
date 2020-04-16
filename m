From: Jani Nikula <jani.nikula@linux.intel.com>
Date: Thu, 16 Apr 2020 10:05:39 +0000
Subject: Re: [PATCH v2 0/2] Don't generate thousands of new warnings when building docs
Message-Id: <87a73b4ufg.fsf@intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <cover.1584716446.git.mchehab+huawei@kernel.org> <20200320171020.78f045c5@lwn.net>
In-Reply-To: <20200320171020.78f045c5@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>, Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Paul Mackerras <paulus@samba.org>, Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ricardo Ribalda Delgado <ribalda@kernel.org>, Luca Ceresoli <luca@lucaceresoli.net>, dmaengine@vger.kernel.org, Matthias Maennich <maennich@google.com>, Harry Wei <harryxiyou@gmail.com>, x86@kernel.org, ecryptfs@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, target-devel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Hans Verkuil <hverkuil-cisco@xs4all.nl>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Johannes Berg <johannes.berg@intel.com>, Jacopo Mondi <jacopo@jmondi.org>, Tyler Hicks <code@tyhicks.com>, Vinod Koul <vkoul@kernel.org>, Alex Shi <alex.shi@linux.alibaba.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-scsi@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linuxppc-dev@lists.ozlabs.org, Borislav Petkov <bp@alien8.de>

On Fri, 20 Mar 2020, Jonathan Corbet <corbet@lwn.net> wrote:
> On Fri, 20 Mar 2020 16:11:01 +0100
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
>
>> This small series address a regression caused by a new patch at
>> docs-next (and at linux-next).
>
> I don't know how I missed that mess, sorry.  I plead distracting times or
> something like that.  Heck, I think I'll blame everything on the plague
> for at least the next few weeks.
>
> Anyway, I've applied this, thanks for cleaning it up.

There's still more fallout from the autosectionlabel extension
introduced in 58ad30cf91f0 ("docs: fix reference to
core-api/namespaces.rst"), e.g. in i915.rst.

The biggest trouble is, if you have headings in kernel-doc comments,
Sphinx is unable pinpoint where the dupes are. For example:

 Documentation/gpu/i915.rst:610: WARNING: duplicate label gpu/i915:layout, other instance in
 Documentation/gpu/i915.rst

However there is no "layout" label in i915.rst. The one being warned
about I can dig into based on the line number, but not the second
one. You have to resort to grepping the source. And avoiding duplicate
subsection headings in completely isolated places is a minefield.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
