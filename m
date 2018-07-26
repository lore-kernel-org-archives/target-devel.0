From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Thu, 26 Jul 2018 17:10:20 +0000
Subject: Re: [PATCH 13/20] target/iscsi: Reduce number of __iscsit_free_cmd() callers
Message-Id: <2786ae3d77b99be8c6f384fbab12be357f858a15.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180622215307.8758-14-bart.vanassche@wdc.com>
In-Reply-To: <20180622215307.8758-14-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 2018-07-26 at 16:42 +-0530, Varun Prakash wrote:
+AD4- cxgbit driver is not working with this patch as transport+AF8-free+AF8-pages()
+AD4- is called before calling conn-+AD4-conn+AF8-transport-+AD4-iscsit+AF8-release+AF8-cmd(), cxgbit
+AD4- driver calls dma+AF8-unmap+AF8-sg() in -+AD4-iscsit+AF8-release+AF8-cmd(), transport+AF8-free+AF8-pages()
+AD4- frees the scatterlist pages so dma unmap will not work.
+AD4- 
+AD4- cxgbit driver needs a callback before target frees the pages
+AD4- so that it can dma unmap.
+AD4- 
+AD4- We can remove -+AD4-iscsit+AF8-release+AF8-cmd() from +AF8AXw-iscsit+AF8-free+AF8-cmd() and call it
+AD4- directly from iscsit+AF8-free+AF8-cmd(), iscsit+AF8-aborted+AF8-task().    

Hello Varun,

Thank you for your report. Since no other patches in this series depend on
this patch, I will send a revert.

Bart.
