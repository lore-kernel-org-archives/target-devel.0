From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 30 Jan 2018 02:38:34 +0000
Subject: Re: [bug report] cxgbit: add files for cxgbit.ko
Message-Id: <20180130023834.y446fozsz4yextuz@mwanda>
List-Id: <target-devel.vger.kernel.org>
References: <20180123140550.GA31371@mwanda>
In-Reply-To: <20180123140550.GA31371@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Jan 29, 2018 at 08:19:24PM +0530, Varun Prakash wrote:
> On Tue, Jan 23, 2018 at 05:05:50PM +0300, Dan Carpenter wrote:
> > Hello Varun Prakash,
> > 
> > The patch 9730ffcb8957: "cxgbit: add files for cxgbit.ko" from Apr
> > 20, 2016, leads to the following static checker warning:
> > 
> > 	drivers/target/iscsi/cxgbit/cxgbit_target.c:1443 cxgbit_lro_skb_merge()
> > 	error: buffer overflow 'ssi->frags' 17 <= 255
> > 
> > drivers/target/iscsi/cxgbit/cxgbit_target.c
> >   1425  static void
> >   1426  cxgbit_lro_skb_merge(struct cxgbit_sock *csk, struct sk_buff *skb, u8 pdu_idx)
> >   1427  {
> >   1428          struct sk_buff *hskb = csk->lro_hskb;
> >   1429          struct cxgbit_lro_pdu_cb *hpdu_cb = cxgbit_skb_lro_pdu_cb(hskb, 0);
> >   1430          struct cxgbit_lro_pdu_cb *pdu_cb = cxgbit_skb_lro_pdu_cb(skb, pdu_idx);
> >                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > Smatch marks pdu_cb as tainted because it comes from skb->data
> > 
> >   1431          struct skb_shared_info *hssi = skb_shinfo(hskb);
> >   1432          struct skb_shared_info *ssi = skb_shinfo(skb);
> >   1433          unsigned int len = 0;
> >   1434  
> >   1435          if (pdu_cb->flags & PDUCBF_RX_HDR) {
> >   1436                  u8 hfrag_idx = hssi->nr_frags;
> >   1437  
> >   1438                  hpdu_cb->flags |= pdu_cb->flags;
> >   1439                  hpdu_cb->seq = pdu_cb->seq;
> >   1440                  hpdu_cb->hdr = pdu_cb->hdr;
> >   1441                  hpdu_cb->hlen = pdu_cb->hlen;
> >   1442  
> >   1443                  memcpy(&hssi->frags[hfrag_idx], &ssi->frags[pdu_cb->hfrag_idx],
> >                                                                     ^^^^^^^^^^^^^^^^^
> > how do we know this is within bounds?
> 
> pdu_cb->hfrag_idx is assigned value in the following function
> 
> cxgbit_lro_add_packet_gl()
> 	pdu_cb->hfrag_idx = skb_shinfo(skb)->nr_frags;
> 
> There is one more check for nr_frags in 
> cxgbit_lro_receive()
> 
> 	if ((gl && (((skb_shinfo(skb)->nr_frags + gl->nfrags) >
> 	    MAX_SKB_FRAGS) || (lro_cb->pdu_totallen >= LRO_FLUSH_LEN_MAX))) ||
> 	    (lro_cb->pdu_idx >= MAX_SKB_FRAGS)) {
> 		cxgbit_lro_flush(lro_mgr, skb);
> 		goto start_lro;
> 	}

Ah.  Thanks.  That's tricky for static analysis to follow....

regards,
dan carpenter

