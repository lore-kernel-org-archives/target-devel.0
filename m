From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 12 Nov 2019 17:05:35 +0000
Subject: Re: [PATCH 0/3] Three reliability improvements
Message-Id: <fd927f32-2150-9c34-22f7-dc3e31db6bca@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191112035752.8338-1-bvanassche@acm.org>
In-Reply-To: <20191112035752.8338-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/11/19 7:57 PM, Bart Van Assche wrote:
> The three patches in this series fix the complaints that were reported while
> running the libiscsi test tool against the SCSI target code. I'm not sure why
> I hadn't noticed these issues before - maybe new tests have been added to the
> test tool. Please consider these patches for Linux kernel version v5.5.

This is the second version of this patch series. The changes compared to 
v1 are:
- The patch that declares target_release_reservation() static has been 
left out because a patch in this series introduces a call to that 
function outside the file in which that function has been defined.
- The patch for releasing SPC-2 reservations has been reworked as 
requested by Roman.
- Two new patches have been added.

Bart.
