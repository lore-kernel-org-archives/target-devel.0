From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 25 Mar 2019 19:13:17 +0000
Subject: Re: Limit logins or connections to the same target LUN
Message-Id: <1553541197.118779.14.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <17b94268-631e-515b-ccb3-f1b6ffcdd797@assyoma.it>
In-Reply-To: <17b94268-631e-515b-ccb3-f1b6ffcdd797@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 2019-02-28 at 16:19 +-0100, Gionatan Danti wrote:
+AD4 I would like to understand if, and how to, limit the maximum number of 
+AD4 simultaneous connections (or logins) to a specific LUN (similar in how 
+AD4 the +ACI-MaxSession+ACI option worked in the old ietd).
+AD4 
+AD4 I am exporting a LUN with a general purpose filesystem (non cluster 
+AD4 aware) and I would be 100+ACU sure that only a single machine at a time can 
+AD4 mount it.
+AD4 
+AD4 At the moment, I protected the iSCSI LUN with both an IP-based access 
+AD4 list and a username/password combo, but hard limiting the maximum number 
+AD4 of connections opened against it to 1 (one) would be a nice thing...
+AD4 
+AD4 Also, I am aware of SCSI persistent reservations (sg+AF8-persist) but, while 
+AD4 working well, they are somewhat harder to setup.

Hi Danti,

As far as I know this is not yet supported by the SCSI target code. I think
the kernel code will have to be modified to add this functionality.

Bart.
