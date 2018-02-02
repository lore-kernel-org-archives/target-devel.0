From: Michael Di Domenico <mdidomenico4@gmail.com>
Date: Fri, 02 Feb 2018 19:52:09 +0000
Subject: new kernel connection timeouts
Message-Id: <CABOsP2Nx+==bXwZVbkd5qHo5AhF1C-z2ObmNoxMugFeXabvX0w@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

I recently updated my iscsi target box from redhat kernel
3.10.0-693.11.1.el7 to 3.10.0.693.17.1.el7.  now when i try to bring
up a few dozen iscsi clients at a time several will timeout.  i can't
say where in the iscsi connection it's failing, but if i'm on the
console of the iscsi client, i can rerun the connection script and the
disks will appear.

it almost seems like the connections are queued up on the target and
some don't get one because the queue is full.

i know this isn't a fantastic bug report, but i haven't changed
anything process wise in my environment i was able to boot 30-40
machines at a time.  if i do that now, half or so will fail to see
their disks and i have to reboot them a second time.  at which point
they usually succeed.  either because others have finished or just
luck that they were in the queue at the right time, i'm not sure.

the targetcli version is 2.1.fb46-1.el7
