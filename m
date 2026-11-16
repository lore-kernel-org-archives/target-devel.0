Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794849420;
	b=dkrtwjSF3xVJZHLlrXUnyGTNGYChzzm0xUZ+oXEMbcSr5VCckXRevcigpJTXM0aFk+pj
	 FM0/3WBuN7daQDexNz54Q9C768FaHt0nJiBprMyZ9NJaDQ9z1mpZAAAxIG+q3S54Xk02k
	 Eysja7fIcIAtmnnti9d1zdDoCE27IsNgxLd93EE9nK6pggZnhEt2cxv1Vn7xWC13S0+Eh
	 Ur0pU2k4vnQqyX51DqrAdjxGvnv0PvT0QVMhWCGvdbL/ctX60K/JdTgAae1v1kq69sX46
	 Jp8c840wt8ZOO9ZDiMimDSRclbeJTCCs31bkbmumpZap6IVAhpD/T+K/872tN+oxC/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794849420;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
	b=FyY5ZXOAiat965gj0b5TKY4lcFq3LOVy/XvldVR8DoSwrljlOqX3L3EwsGDpskeOnAMt
	 lkbx/J0R0Mr07Jw703z/0prvjSNaJCISsT/bvpU4G8g8MfY6SxNXF4udSp5Q14w2W/9l3
	 4Sk5wQ7tSUmueDlnd2/Owt70bJwd5kIsmVmidsBEM/AyEx4BnTQd08mzcjp9ZAQqR96rb
	 ccBg4SXg74CPlOtz+x8CecYupTTahsN77jSUPviBJFgJSneIYGubeBNW5KRP/TSCt6ujG
	 7bdIeDTZuRpSwlZ70h3v5l5asY91kdRi/HmQFhyK/SII+ZqPnvq/FvB/ymzKuRhnSrQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=muR038w6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A7C606A323
	for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 17:16:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0A7C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=muR038w6
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b633ddfad6so5782811a12.3
        for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 09:16:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794849418; cv=none;
        d=google.com; s=arc-20260327;
        b=Hq169HOKueIVRbRKxGoOEAmY+YEH+gFjXKyTiRG26X/zI7hYn7+bdsa5fGgL1WAeDg
         cxe09mM0TWaZpiQv2m7RpaFW14NsTR+awusN98cy9un6s7r4oHJTFyLB7Mj4tFzbS367
         hlsZXWbj9HdQpjeFAVauVVEVUxwTw+7pfZcICPjAAZp38SrT+WlX434LsXKWHwei+2tC
         ky9x6+BmH/uYg5/7duYmvdPU0tTDEUFaWCE7EQex7ZQRYw4EDPuy/if3vamEAKB4JJeh
         I8DmxDIdm80qzKuSqsjNQugNSE356yV8uv3jziqgDti9ddD58GxUc67gMEkkRt0rFPah
         uNaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
        fh=vBFOThUR84EHLeJN+5eP+DHGoUScO7QX58x+/E0Xh8k=;
        b=igEVswjhLy1ztLT5zDLkTA6i9/TMnFAfI1gT9Sost15zJiSAi3LYGub29kFqihveAe
         PntGhb0ikZWRTVCxT8UsgWvtOkeShOn3nsv8wLUsx/676qLioUC+HGcIC8bMwiCO6szm
         qefbLmgYKeCCcy1WdBjyk2A1R9IjrA7lTesE2RxAx9e/wd4Xve7Qz1smQWZ2DzrstL6S
         Ti8/EziusZOdqSM1YWeyKl+gRFBmD+9q6vrkj6D8Bs9RutvXAkjIEfo4tSA0YlAb4GbF
         nNcslQt5mMABrU5OgF3Z4lXZMuf8HV6kjPI0timXzzoCXi4eP5NDX1t42Gk8w5wLCz2V
         ZifQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794849418; x=1795454218; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
        b=muR038w65/upa4T3A8TQUgAZPPu00HSp8IEYxLeziP5g7EOqEdvXR4kRn7l7HqC4oM
         V/H7jmVddckf4li4Y0IfO1NYwf6mTpnVcEibSiDpSUGa4rmH8J48GG/AdleQHZhCXsRY
         RKMQZVymvxJl7k97IWLEoqvjx7NjiZbQg2uAM4mR3pJQKz5WqOab8nzYhREPb/6gAZ9i
         pBA6UOQY1B36uqzP1y0SScadwu/L0Druqoe1fQdOxwb3sdGBUZ1ThrB2CqjVL4+PzHGX
         wt9TbJGmNBshQby+yMN9+pQ2Lz5tWQc68vsAD3w5jK3lYbmvcjKJb74HqwwAi+/L+rlV
         RvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794849418; x=1795454218;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
        b=LufvmN/JWryTj3XigKaE9h3Nb9YnhFxScpTY/ubBKIvUHeIISgxjSjsHxMUFiORsMl
         jR9Mwq2T/2HS4E+F9eAbkSmbsVuTlQVLNRyeoty5i35ljvTE+SpWW9uDrY+RTfqMfWwm
         HM74ynIwwCloxYLriCaDwKb5zwOx/jSNN9uhRaZvmgTky+Wg6cZWG5eREi2AUwKHqvnd
         mEGzy6cBEbK5MLy9e1rzmDtN2QOJsaBujhcNXsbMqDboWsXxZUpMKLmuxofSHnOHLCVN
         68CAXY5dSIt0L2fEuvKPYInJjRhNet1jy9jvOT6Ir4jDm9+rQE+/QJYo0HXD6i5yLOyi
         HtMg==
X-Forwarded-Encrypted: i=1; AL+hErHT32fnZeZ/o1vS1JvgBnMRC4/pfu6nzNnwbi7C9cWfWlkX7/vRyWTET2QInHW+38r5ynPGM2g3JM6c+D8=@vger.kernel.org
X-Gm-Message-State: APuU4Z9CiUIZeJ9j/cMjV0EZo3Q6v6NPGpR+9YoAUI1roZs9BkDfPyAq
	qQDiaPtAOt869jecn1KUG9GCA5NV75vgfGBGd62vcSBq6mOtiOamBV8CCjLWm+/W6SbXRj3GdFO
	P5M8QIS4fuBTsQtMD1PkmzxlBeWW2XT8=
X-Gm-Gg: AYBFou04Kv5jyYUuguETXvbjUqensvA3FXm34okMmVRcofQKcI+F35LTnGrg2VdOWdu
	wv2cAiCUt6W3ijS/kZvC9BK0yFuFrmStJpQLq/sdbJ9DbwBEDXXkM0uqiUILO3A+v/VR4yLgGeL
	MN7GwUHFLkcyumZlycXYfGpoVHt4qNMtZp3KfoWTRJz+Y3LM+sqXlfX8XaBTMygo2LaKqiNGKLR
	jWoe2tRqjeDy9IXf9yuuKAZ2svCKfRQ3Dw5k7hPIDTbhObuHqOw7yLKdzQdYqniyBIrFawRmRdn
	1SkPMbOooZqr4CFfVVefRVLYlNk0eNRjEZLJZYdnRf99L8nG9H5dnfytKPBPANh1NHZf4nvyx0D
	XYfB+S8tFmHWU482VFzyNqIf37NZSRlDJ23lujkCD9e5KXtk/gdrxAiLeXW1GMifw9iAVZzjIPl
	MyMyjcE8hJIBxKWTw=
X-Received: by 2002:aa7:c258:0:b0:6b7:d69a:a3d3 with SMTP id
 4fb4d7f45d1cf-6b7d69aa8fbmr5089335a12.39.1794849418257; Mon, 16 Nov 2026
 09:16:58 -0800 (PST)
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Nov 2026 18:16:46 +0100
X-Gm-Features: AclHuK_s2Kpb4OdbgPngYJl9gLHjfhlAmiJMqLtxRnpTDibz-Ni4SZJspSV9laM
Message-ID: <CAOQ4uxjJVgy-skUbbScfz=eAEATf=iMpqRHNshX=eKu3oiwnrA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 34/44] selftests/ovl: test data-only layers on
 pseudo filesystems
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 12:10=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> Add tests that overlayfs refuses data-only layers on pseudo filesystems:
>
> - sysfs and procfs via the "::" separator in "lowerdir=3D"
> - sysfs and procfs via "datadir+" by path
> - sysfs and procfs via "datadir+" by file descriptor
> - tmpfs as data-only layer
> - sysfs as regular lower layer
>
> The last two must keep mounting.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  .../selftests/filesystems/overlayfs/.gitignore     |   1 +
>  .../selftests/filesystems/overlayfs/Makefile       |   1 +
>  .../filesystems/overlayfs/pseudo_datadir.c         | 131 +++++++++++++++=
++++++
>  3 files changed, 133 insertions(+)
>
> diff --git a/tools/testing/selftests/filesystems/overlayfs/.gitignore b/t=
ools/testing/selftests/filesystems/overlayfs/.gitignore
> index b343cc430051d..e1410fee2269d 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/.gitignore
> +++ b/tools/testing/selftests/filesystems/overlayfs/.gitignore
> @@ -3,3 +3,4 @@ dev_in_maps
>  set_layers_via_fds
>  idmapped_mounts
>  automount_in_layer
> +pseudo_datadir
> diff --git a/tools/testing/selftests/filesystems/overlayfs/Makefile b/too=
ls/testing/selftests/filesystems/overlayfs/Makefile
> index 382a59bda5e70..ace75f5627e0f 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/Makefile
> +++ b/tools/testing/selftests/filesystems/overlayfs/Makefile
> @@ -10,6 +10,7 @@ TEST_GEN_PROGS :=3D dev_in_maps
>  TEST_GEN_PROGS +=3D set_layers_via_fds
>  TEST_GEN_PROGS +=3D idmapped_mounts
>  TEST_GEN_PROGS +=3D automount_in_layer
> +TEST_GEN_PROGS +=3D pseudo_datadir
>
>  include ../../lib.mk
>
> diff --git a/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir=
.c b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
> new file mode 100644
> index 0000000000000..3b59fd3e9f5c2
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
> @@ -0,0 +1,131 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <sched.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <sys/mount.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +
> +#include "kselftest_harness.h"
> +#include "../wrappers.h"
> +
> +static int setup_tmp(void)
> +{
> +       if (unshare(CLONE_NEWNS))
> +               return -errno;
> +       if (sys_mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL))
> +               return -errno;
> +       if (sys_mount("tmpfs", "/tmp", "tmpfs", 0, NULL))
> +               return -errno;
> +       if (mkdir("/tmp/lower", 0755) || mkdir("/tmp/data", 0755) ||
> +           mkdir("/tmp/merged", 0755))
> +               return -errno;
> +       return 0;
> +}
> +
> +/* Mount an overlayfs with the legacy "lowerdir=3D" option. */
> +static int mount_lowerdir(const char *lowerdir)
> +{
> +       char opts[256];
> +
> +       snprintf(opts, sizeof(opts), "lowerdir=3D%s", lowerdir);
> +       if (sys_mount("overlay", "/tmp/merged", "overlay", MS_RDONLY, opt=
s))
> +               return -errno;
> +       if (umount2("/tmp/merged", 0))
> +               return -errno;
> +       return 0;
> +}
> +
> +static int set_layer(int fd_context, const char *key, const char *path,
> +                    bool by_fd)
> +{
> +       int fd, ret =3D 0;
> +
> +       if (!by_fd) {
> +               if (sys_fsconfig(fd_context, FSCONFIG_SET_STRING, key, pa=
th, 0))
> +                       return -errno;
> +               return 0;
> +       }
> +
> +       fd =3D open(path, O_DIRECTORY | O_CLOEXEC);
> +       if (fd < 0)
> +               return -errno;
> +       if (sys_fsconfig(fd_context, FSCONFIG_SET_FD, key, NULL, fd))
> +               ret =3D -errno;
> +       close(fd);
> +       return ret;
> +}
> +
> +/* Create an overlayfs with "lowerdir+" and "datadir+" through fsconfig.=
 */
> +static int fsmount_layers(const char *lower, const char *data, bool by_f=
d)
> +{
> +       int fd_context, fd_mnt, ret;
> +
> +       fd_context =3D sys_fsopen("overlay", FSOPEN_CLOEXEC);
> +       if (fd_context < 0)
> +               return -errno;
> +
> +       ret =3D set_layer(fd_context, "lowerdir+", lower, by_fd);
> +       if (ret)
> +               goto out;
> +       ret =3D set_layer(fd_context, "datadir+", data, by_fd);
> +       if (ret)
> +               goto out;
> +
> +       if (sys_fsconfig(fd_context, FSCONFIG_CMD_CREATE, NULL, NULL, 0))=
 {
> +               ret =3D -errno;
> +               goto out;
> +       }
> +
> +       fd_mnt =3D sys_fsmount(fd_context, FSMOUNT_CLOEXEC, 0);
> +       if (fd_mnt < 0)
> +               ret =3D -errno;
> +       else
> +               close(fd_mnt);
> +out:
> +       close(fd_context);
> +       return ret;
> +}
> +
> +TEST(datadir_sysfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/tmp/lower::/sys/kernel"), -EINVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/sys/kernel", false), -EI=
NVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/sys/kernel", true), -EIN=
VAL);
> +}
> +
> +TEST(datadir_procfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/tmp/lower::/proc"), -EINVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/proc", false), -EINVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/proc", true), -EINVAL);
> +}
> +
> +TEST(datadir_tmpfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/tmp/lower::/tmp/data"), 0);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", false), 0);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", true), 0);
> +}
> +
> +TEST(lowerdir_sysfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/sys/kernel:/tmp/lower"), 0);
> +       EXPECT_EQ(mount_lowerdir("/sys/kernel::/tmp/data"), 0);
> +       EXPECT_EQ(fsmount_layers("/sys/kernel", "/tmp/data", false), 0);
> +       EXPECT_EQ(fsmount_layers("/sys/kernel", "/tmp/data", true), 0);
> +}
> +
> +TEST_HARNESS_MAIN
>
> --
> 2.53.0
>
