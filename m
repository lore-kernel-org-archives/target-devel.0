From: Josh England <josh@tgsmc.com>
Date: Tue, 10 Sep 2019 22:36:41 +0000
Subject: prod_mode_write_protect doesn't work
Message-Id: <CAL-b+8jMoe3wBBp_6p74dkVW--pmxY52kXD869Bq_GQy1AL73A@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

CentOS-7.5 target and initiator.

I'm trying to expose a fileio backstore target to multiple initiators
as a read-only device, but running into problems with the read-only
part.
Setting prod_mode_write_protect=1 (or demo_mode_write_protect=1) in
the TPG does not give the expected behavior.  Initiators can still
login and happily write to the device.  Is this a bug or am I just
doing something wrong?

-JE
