From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 08 Oct 2019 20:35:56 +0000
Subject: Re: Wrong resetting of Logical Unit Number field in CDB
Message-Id: <df214af8-a12a-205f-4627-d881b0960bd5@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
In-Reply-To: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/8/19 1:20 PM, bodo.stroesser@ts.fujitsu.com wrote:
> 3) Remove the code entirely, because it is no longer needed / useful (?)

I'd like to hear the opinion of Mike Christie. My favorite solution is 
(3) because I think the days of embedding LUN numbers in CDBs are long 
behind us.

Bart.
