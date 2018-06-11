From: Mike Christie <mchristi@redhat.com>
Date: Mon, 11 Jun 2018 21:05:57 +0000
Subject: Re: [PATCH 10/14] target: Simplify the code for waiting for command completion
Message-Id: <5B1EE435.8060607@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180301222632.31507-11-bart.vanassche@wdc.com>
In-Reply-To: <20180301222632.31507-11-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

On 06/11/2018 03:37 PM, Bart Van Assche wrote:
> On Mon, 2018-06-11 at 14:02 -0500, Mike Christie wrote:
>> I see that in the current code we always do a wait if the CMD_T_ABORTED
>> bit was set, so your patch matches that. However, is the original code
>> correct? In target_release_cmd_kref below we only do a wake up if both
>> CMD_T_FABRIC_STOP and CMD_T_ABORTED is set. If wait_for_tasks=FAlse and
>> CMD_T_ABORTED was set, we would end up waiting forever. Is that right or
>> can it never happen?
>=20
> Hello Mike,
>=20
> transport_generic_free_cmd() calls target_wait_free_cmd() before waiting
> on cmd->cmd_wait_comp for aborted commands. target_wait_free_cmd() calls
> __transport_wait_for_tasks() with the fabric_stop argument set to true
> and that causes the CMD_T_FABRIC_STOP flag to be set.
>

Yeah, I see it's always set together now. Just misread the code.
