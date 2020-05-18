From: Lance Digby <lance.digby@gmail.com>
Date: Mon, 18 May 2020 01:02:03 +0000
Subject: Re: [PATCH target] target: Add initiatorname to NON_EXISTENT_LUN error
Message-Id: <CAHh6B+q4b34awGvKxh7vh+Vn75WjBme11NumusNLxiyZ+t4GxA@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <cd119ce943d9ec62ef1bff237ebb49e35a337c3b.1589407872.git.lance.digby@gmail.com>
 <93c437ce-f881-9f54-5e39-afa8afd96141@redhat.com> <CAHh6B+poeCFeZjCt04QT2c12bgvCf9UN+5vdx5EeK6PcgD2y3g@mail.gmail.com>
 <fb2b881c-fe23-4a80-53c3-189d744f2fe3@redhat.com>
In-Reply-To: <fb2b881c-fe23-4a80-53c3-189d744f2fe3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

Thanks again Mike will send out a new version.

On Mon, May 18, 2020 at 5:16 AM Mike Christie <mchristi@redhat.com> wrote:
>
> On 5/16/20 6:29 PM, Lance Digby wrote:
> > Mike,  Thanks for the review!
> >   The pr_err  Detected NON_EXISTENT_LUN is the error messages issued
> > for the TCM_NON_EXISTENT_LUN retcode so I believe they are the same.
> >   Simply scanning for the wrong lun on an initiator will generate this
> > error on the target but not generate an error on the initiator. And I
> > have seen installs, with a lot of initiators, automate the scanning of
> > such luns incorrectly deemed missing.
> >   While this looks like a simple problem it can take days to get
> > access or the tcp traces to sort it out.
> >
> >    Within the same routine there is another pr_err for
> > TCM_WRITE_PROTECTED that I did not add the initiatorname to as I
> > thought this would leave a heavy footprint on the initiator. If you
>
> I'm not sure what you mean by heavy footprint on the initiator part means.
>
> I would say do whatever is helpful to you to debug the problem. For
> TCM_WRITE_PROTECTED I'm not sure the initiatorname is helpful. I think
> the target name and tpg would be useful, because I think you sometimes
> set it at the tpg level then it gets inherited by the LU. But I think
> it's a pain to get to the target name from this code path, so I wouldn't
> worry about adding it now.
>
> > believe this should be changed for consistency please let me know and
> > I will add this and change to nacl->initiatorname.
>
> Just to make sure we are on the same page. I was just commenting about
> the other NON_EXISTENT_LUN instace in transport_lookup_tmr_lun. I just
> thought we would want/need the same info there.
>
>
> >
> >
> >
> >
> >
> >
> >
> >
> >
> > On Sat, May 16, 2020 at 9:50 AM Mike Christie <mchristi@redhat.com> wrote:
> >>
> >> On 5/13/20 11:01 PM, Lance Digby wrote:
> >>> The NON_EXISTENT_LUN error can be written without an error condition
> >>>  on the initiator responsible. Adding the initiatorname to this message
> >>>  will reduce the effort required to fix this when many initiators are
> >>> supported by a target.
> >>>
> >>> Signed-off-by: Lance Digby <lance.digby@gmail.com>
> >>> ---
> >>>  drivers/target/target_core_device.c | 5 +++--
> >>>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> >>> index 4cee113..604dea0 100644
> >>> --- a/drivers/target/target_core_device.c
> >>> +++ b/drivers/target/target_core_device.c
> >>> @@ -100,9 +100,10 @@
> >>>                */
> >>>               if (unpacked_lun != 0) {
> >>>                       pr_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
> >>> -                             " Access for 0x%08llx\n",
> >>> +                             " Access for 0x%08llx from %s\n",
> >>>                               se_cmd->se_tfo->fabric_name,
> >>> -                             unpacked_lun);
> >>> +                             unpacked_lun,
> >>> +                             se_sess->se_node_acl->initiatorname);
> >>
> >> You can do nacl->initiatorname.
> >>
> >> Do you also want add the name to the tmr case? It's probably not common,
> >> but the error message would be consistent.
> >>
> >>>                       return TCM_NON_EXISTENT_LUN;
> >>>               }
> >>>
> >>
> >
>
