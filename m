From: Hannes Reinecke <hare@suse.com>
Date: Sat, 01 Dec 2018 14:54:08 +0000
Subject: Re: [PATCH v5 1/5] target: use consistent left-aligned ASCII INQUIRY data
Message-Id: <208989ed-eb4d-f574-e597-a18791a7d5ae@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181130233423.26556-2-ddiss@suse.de>
In-Reply-To: <20181130233423.26556-2-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 12/1/18 12:34 AM, David Disseldorp wrote:
> spc5r17.pdf specifies:
>    4.3.1 ASCII data field requirements
>    ASCII data fields shall contain only ASCII printable characters (i.e.,
>    code values 20h to 7Eh) and may be terminated with one or more ASCII
>    null (00h) characters.
>    ASCII data fields described as being left-aligned shall have any
>    unused bytes at the end of the field (i.e., highest offset) and the
>    unused bytes shall be filled with ASCII space characters (20h).
> 
> LIO currently space-pads the T10 VENDOR IDENTIFICATION and PRODUCT
> IDENTIFICATION fields in the standard INQUIRY data. However, the
> PRODUCT REVISION LEVEL field in the standard INQUIRY data as well as the
> T10 VENDOR IDENTIFICATION field in the INQUIRY Device Identification VPD
> Page are zero-terminated/zero-padded.
> 
> Fix this inconsistency by using space-padding for all of the above
> fields.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bryant G. Ly <bly@catalogicsoftware.com>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/target/target_core_spc.c | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
