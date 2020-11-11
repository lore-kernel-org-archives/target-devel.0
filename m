From: Maurizio Lombardi <mlombard@redhat.com>
Date: Wed, 11 Nov 2020 15:48:39 +0000
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a task
Message-Id: <4268d61b-89f2-ce74-200b-d5fc21a207bd@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
 <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
 <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
 <71691FED-C164-482C-B629-A8B89B81E566@oracle.com>
 <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
 <68e77a2c-c868-669f-0c4f-0a5bb0259249@oracle.com>
 <5111dcb0-ef0d-fc11-ee1a-ae2a9b30150a@redhat.com>
 <5D26782D-1249-4A2C-8BF9-7176D5B85F55@oracle.com>
In-Reply-To: <5D26782D-1249-4A2C-8BF9-7176D5B85F55@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Michael Christie <michael.christie@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bvanassche@acm.org, m.lombardi85@gmail.com



Dne 11. 11. 20 v 16:37 Michael Christie napsal(a):
> If the SCSI R/W has the CMD_T_ABORTED bit set, we move it it back to the conn_cmd_list and the abort code path cleans it up. But then we still have the ABORT’s se_cmd on the tmp_list. We will then call 
> 
> transport_generic_free_cmd(wait_for_tasks=true) -> __transport_wait_for_tasks(fabric_stop=true)
> 
> And wait for the ABORT to complete, and the ABORT does not complete until the last ref on the command it’s aborting completes.


Right. now I understand it.
Thanks.

Maurizio
