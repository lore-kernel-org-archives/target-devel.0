From: Mike Christie <mchristi@redhat.com>
Date: Fri, 11 Jan 2019 19:58:57 +0000
Subject: Re: [PATCH v4] scsi: tcmu: avoid cmd/qfull timers updated whenever a new cmd comes
Message-Id: <5C38F581.6040506@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181123011530.2477-1-xiubli@redhat.com>
In-Reply-To: <20181123011530.2477-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/22/2018 07:15 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Currently there has one cmd timeout timer and one qfull timer for
> each udev, and whenever there has any new coming cmd it will update
> the cmd timer or qfull timer. And for some corner case the timers
> are always working only for the ringbuffer's and full queue's newest
> cmd. That's to say the timer won't be fired even there has one cmd
> stuck for a very long time and the deadline is reached.
> 
> This fix will keep the cmd/qfull timers to be pended for the oldest
> cmd in ringbuffer and full queue, and will update them with the next
> cmd's deadline only when the old cmd's deadline is reached or removed
> from the ringbuffer and full queue.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>

Work ok for me.

Acked-by: Mike Christie <mchristi@redhat.com>
