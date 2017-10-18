From: Mike Christie <mchristi@redhat.com>
Date: Wed, 18 Oct 2017 07:20:51 +0000
Subject: Re: [PATCH 07/17] tcmu: fix dev root_udev_waiter_mutex errors
Message-Id: <59E700D3.7040702@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1508310852-15366-8-git-send-email-mchristi@redhat.com>
In-Reply-To: <1508310852-15366-8-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/18/2017 02:14 AM, Mike Christie wrote:
> This fixes the following bugs:
> 
> 1. You cannot sleep after calling prepare_to_wait, so you
> cannot use a mutex.

One clarification. I meant you cannot sleep between the prepare_to_wait
and schedule calls.
