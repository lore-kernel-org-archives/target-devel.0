From: Mike Christie <mchristi@redhat.com>
Date: Tue, 07 Aug 2018 20:40:28 +0000
Subject: Re: [PATCH RESEND v2] target: move the rx hdr buffer out of the stack
Message-Id: <5B6A03BC.1070605@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1533286080-13099-1-git-send-email-mlombard@redhat.com>
In-Reply-To: <1533286080-13099-1-git-send-email-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/03/2018 03:48 AM, Maurizio Lombardi wrote:
> When HeaderDigest is enabled on aarch64 machines, target triggers
> a lot of failed crc checksum errors:
> 
> example of output in dmesg:
> [  154.495031] HeaderDigest CRC32C failed, received 0x60571c8d, computed 0x288c3ab9
> [  154.583821] Got unknown iSCSI OpCode: 0xff
> [  162.979857] HeaderDigest CRC32C failed, received 0x0712e57c, computed 0x288c3ab9
> ...
> 
> The problem is that the iscsit_get_rx_pdu() function uses
> a stack buffer as input for the scatterlist crypto library.
> This should be avoided on kernels >= 4.9 because stack buffers
> may not be directly mappable to struct page when the
> CONFIG_VMAP_STACK option is enabled.
> 
> This patch modifies the code so the buffer will be allocated on the heap
> and adds a pointer to it in the iscsi_conn structure.
> 
> v2: allocate conn_rx_buf in iscsi_target_login_thread()
>     and fix a memory leak
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target.c       |  6 +++++-
>  drivers/target/iscsi/iscsi_target_login.c | 15 +++++++++++++++
>  include/target/iscsi/iscsi_target_core.h  |  2 ++
>  3 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 8e22379..149fa91 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -3913,10 +3913,12 @@ static bool iscsi_target_check_conn_state(struct iscsi_conn *conn)
>  static void iscsit_get_rx_pdu(struct iscsi_conn *conn)
>  {
>  	int ret;
> -	u8 buffer[ISCSI_HDR_LEN], opcode;
> +	u8 *buffer, opcode;
>  	u32 checksum = 0, digest = 0;
>  	struct kvec iov;
>  
> +	buffer = conn->conn_rx_buf;

If the buffer is only used in the loop below why does it need to be
allocated in __iscsi_target_login_thread?

It just seems like the error handling and freeing of that buffer would
be more simple if done here.
