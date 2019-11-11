From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 11 Nov 2019 20:23:34 +0000
Subject: Re: [PATCH 2/2] target/iscsi: Fix a use-after-free while closing a session
Message-Id: <d6f56368-1b3d-f778-adf1-ac67b6dc1df0@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191111182944.191123-3-bvanassche@acm.org>
In-Reply-To: <20191111182944.191123-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/11/19 11:41 AM, Roman Bolshakov wrote:
> On Mon, Nov 11, 2019 at 10:29:44AM -0800, Bart Van Assche wrote:
>> +static int target_release_res(struct se_device *dev, void *data)
>> +{
>> +	struct se_session *sess = data;
>> +
>> +	if (dev->reservation_holder = sess)
>> +		dev->reservation_holder = NULL;
> 
> Does it worth to use target_release_reservation() when the session is
> reserveration holder instead of the explicit assignment? That would also
> reset reservation flags of the se_device.

That sounds like a good idea to me. I will look into this.

> IMO the code is not specific to iscsi and the tag should be changed to
> "target/core:"

Agreed. I will fix the patch subject.

Bart.
