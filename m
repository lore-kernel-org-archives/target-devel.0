From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 18 Jan 2018 09:22:25 +0000
Subject: Re: [PATCH] target:fix destory device in target_configure_device
Message-Id: <1516267345.24576.244.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1516018177-7714-1-git-send-email-tang.wenji@zte.com.cn>
In-Reply-To: <1516018177-7714-1-git-send-email-tang.wenji@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-01-15 at 14:43 -0600, Mike Christie wrote:
> On 01/15/2018 06:09 AM, tang.wenji@zte.com.cn wrote:
> > From: tangwenji <tang.wenji@zte.com.cn>
> > 
> > After dev->transport->configure_device succeeds,target_configure_device
> > exits abnormally, dev_flags has not set DF_CONFIGURED yet, does not call
> > destory_device function in free_device
> > 
> > Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
> > ---
> >  drivers/target/target_core_device.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 

Applied.  Thanks Tang + MNC.

