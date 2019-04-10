From: David Disseldorp <ddiss@suse.de>
Date: Wed, 10 Apr 2019 13:25:31 +0000
Subject: Re: How can I change Vendor name LIO-ORG
Message-Id: <20190410152531.3417db79@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <CAPUHmCreBhAa7Dzr+6pkYXyifXnRQfXt39KLHMVCer9jd+Lh3A@mail.gmail.com>
In-Reply-To: <CAPUHmCreBhAa7Dzr+6pkYXyifXnRQfXt39KLHMVCer9jd+Lh3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

Hi,

On Wed, 10 Apr 2019 15:43:47 +0300, Özkan Göksu wrote:

> Hello.
> 
> I couldn't find any way to change LIO-SCSI Vendor name which is shown
> as LIO-ORG when we attached to client.
> I do not want to re-compile kernel with the changing hard-coded Vendor name.
> 
> If there is any way to change it, please can you show me the way?

This functionality was added recently via:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?idTa6f3f6a43cf5a5ad0421e4440a4c7095e7a223

With this change (and 2d882847280e3ae1ddc95175d0fc2006e11bb63f), you
can change the vendor ID via the configfs path at:
target/core/$backstore/$name/wwn/vendor_id

Cheers, David
