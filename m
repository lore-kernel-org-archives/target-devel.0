From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Mon, 20 Apr 2020 16:54:38 +0000
Subject: Re: [PATCH] target: pr: fix PR IN, READ FULL STATUS
Message-Id: <c68c457c-7b8b-db30-f5bd-16eabb528e96@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200406182951.17446-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200406182951.17446-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


On 04/06/20 23:05, Mike Christie wrote:
> 
> There is actually another isid fix needed for the core pr code:
> 
> https://patchwork.kernel.org/patch/10525287/
> 
> Handling Bart's review comment for that patch ended up being crazy
> because of other issues in the PR code so I have not completed that fix.
Sorry for coming back to this so lately.

I again had a look into your old patch. To me it seems to be clear
that apart from architectural discussion a fix is needed here.
The usage of get_unaligned_be64() is of course just wrong.

Replacing with hex2bin I think is also not ideal, because hex2bin
does not respect byte ordering of the ISID: in the protocol messages
iSCSI receives 48 bit big endian ISID. On little endian machines
hex2bin() does not do the byte swap necessary to have the same
value in string format and in u64.

BTW: I'm wondering if the double storage of ISID as u64 and as a
string should be kept. I think I'd prefer to use u64 only.
In that case lio_sess_get_initiator_sid() could just return s64
swapped to the right enianness and the isid values in session and pr
could be s64 (with -1 meaning "no ISID" in session).

BR,
Bodo
