From: Mike Christie <mchristi@redhat.com>
Date: Wed, 13 Sep 2017 19:31:39 +0000
Subject: Re: [PATCH] target: Add netlink command reply supported option for each device
Message-Id: <59B9879B.5060109@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20170913050122.13731-1-nakayamakenjiro@gmail.com>
In-Reply-To: <20170913050122.13731-1-nakayamakenjiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 09/13/2017 02:27 PM, Nakayama Kenjiro wrote:
> Currently there are no way to disable the netlink sync once enabled
> it and even no way to check if it is enable/disabled on the host. You
> don't think that it is necessary? At least, I would like to confirm

I think your mailer is messing things up and you missed where I said I
agree :) See:

>>> have to restart the host and never run it again". It sounds like a
>>> little bit silly note...
>>
>> Yes. Agree.
>>

I just want to make sure I understood your use case and what you really
need in case there is a better way to do this.
