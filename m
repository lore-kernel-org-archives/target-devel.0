From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 13 Nov 2019 17:05:15 +0000
Subject: Re: [PATCH 2/3] target/core: Fix a use-after-free in the TMF handling code
Message-Id: <8e80dd8e-ae1e-1857-2b8c-0f5f341b4e4e@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191112035752.8338-3-bvanassche@acm.org>
In-Reply-To: <20191112035752.8338-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/13/19 4:02 AM, Roman Bolshakov wrote:
> As far as I understand the change prevents backstore directory removal
> from TCM configfs when a TMF is processed and targetcli would start
> to fail sporadically as it tries to delete configfs directories only once:
>    https://github.com/open-iscsi/rtslib-fb/blob/master/rtslib/node.py#L228
> 
> Should we hold se_device device without preventing removal of backstore?

How about using config_item_get()/config_item_put() instead of 
target_depend_item()/target_undepend_item()?

Thanks,

Bart.
