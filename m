From: Raghuram Devarakonda <draghuram@gmail.com>
Date: Tue, 01 May 2018 20:34:56 +0000
Subject: Re: tcmu-runner rpm
Message-Id: <CALtL6BdX0C74YPnN9jA-smZKSeLaQPLjvPFoh5UWnsmJbDaV5Q@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <CALtL6Bd12N8BOU2+DZh-b8g0GF=hVoMANyVpvMTk-uE+ZGDpMQ@mail.gmail.com>
In-Reply-To: <CALtL6Bd12N8BOU2+DZh-b8g0GF=hVoMANyVpvMTk-uE+ZGDpMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

It turns out that the presence of "/etc/tcmu/tcmu.conf" on the system
trips up the build process.Once I renamed "/etc/tcmu", I could build
RPM successfully. The contents (listed below) of the file
"./extra/rpmbuild/BUILD/tcmu-runner-1.3.0.54.g6684a21/tcmu.conf_install.cmake"
gave me a clue as to what is going on:

----
if (NOT EXISTS "/etc/tcmu/tcmu.conf")
        file(INSTALL
"/root/tcmu-runner-orig/extra/rpmbuild/BUILD/tcmu-runner-1.3.0.54.g6684a21/tcmu.conf"
DESTINATION "/etc/tcmu")
endif()
----

I think it should really be checking for this file under the buildroot
rather than in "/" but I may be wrong.

Thanks,
Raghu


On Tue, May 1, 2018 at 3:54 PM, Raghuram Devarakonda
<draghuram@gmail.com> wrote:
> Running "make_runnerrpms.sh" is failing with following errors. I am
> planning to check but thought that I would post any way.
>
> -----
> RPM build errors:
>     Directory not found:
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/etc/tcmu
>     File not found:
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/etc/tcmu/tcmu.conf
> -----
>
> Full output:
>
> -----
> $ cd extra
> $ ./make_runnerrpms.sh
>
> Cloning into '/tmp/tcmu-runner-build/tcmu-runner-1.3.0.54.g6684a21'...
> done.
> Executing(%prep): /bin/sh -e /var/tmp/rpm-tmp.hNkerI
> + umask 022
> + cd /root/tcmu-runner-orig/extra/rpmbuild/BUILD
> + cd /root/tcmu-runner-orig/extra/rpmbuild/BUILD
> + rm -rf tcmu-runner-1.3.0.54.g6684a21
> + /usr/bin/gzip -dc
> /root/tcmu-runner-orig/extra/rpmbuild/SOURCES/tcmu-runner-1.3.0.54.g6684a21.tar.gz
> + /usr/bin/tar -xvvf -
> drwxr-xr-x root/root         0 2018-05-01 16:56 tcmu-runner-1.3.0.54.g6684a21/
> -rw-r--r-- root/root      6571 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/CMakeLists.txt
> -rw-r--r-- root/root     11323 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/LICENSE
> -rw-r--r-- root/root     10983 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/README.md
> -rw-r--r-- root/root     12639 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/alua.c
> -rw-r--r-- root/root      1576 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/alua.h
> -rw-r--r-- root/root     28749 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/api.c
> -rw-r--r-- root/root       904 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/be_byteshift.h
> drwxr-xr-x root/root         0 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/
> drwxr-xr-x root/root         0 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/ccan/
> drwxr-xr-x root/root         0 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/ccan/build_assert/
> -rw-r--r-- root/root      1228 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/ccan/build_assert/build_assert.h
> drwxr-xr-x root/root         0 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/ccan/check_type/
> -rw-r--r-- root/root      2388 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/ccan/check_type/check_type.h
> drwxr-xr-x root/root         0 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/ccan/container_of/
> -rw-r--r-- root/root      4289 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/ccan/container_of/container_of.h
> drwxr-xr-x root/root         0 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/ccan/list/
> -rw-r--r-- root/root     25088 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/ccan/list/list.h
> drwxr-xr-x root/root         0 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/ccan/str/
> -rw-r--r-- root/root      5981 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/ccan/str/str.h
> -rw-r--r-- root/root       774 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/ccan/ccan/str/str_debug.h
> -rw-r--r-- root/root      6734 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/configfs.c
> -rw-r--r-- root/root      5238 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/consumer.c
> -rw-r--r-- root/root     12121 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/darray.h
> drwxr-xr-x root/root         0 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/extra/
> -rwxr-xr-x root/root       825 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/extra/install_dep.sh
> -rwxr-xr-x root/root      1638 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/extra/make_runnerrpms.sh
> -rw-r--r-- root/root      4794 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/file_example.c
> -rw-r--r-- root/root     42732 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/file_optical.c
> -rw-r--r-- root/root     52785 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/file_zbc.c
> -rw-r--r-- root/root     17648 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/glfs.c
> -rw-r--r-- root/root      5427 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/libtcmu-register.c
> -rw-r--r-- root/root     25266 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/libtcmu.c
> -rw-r--r-- root/root      3939 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/libtcmu.h
> -rw-r--r-- root/root      6591 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/libtcmu_common.h
> -rw-r--r-- root/root     11822 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/libtcmu_config.c
> -rw-r--r-- root/root      1664 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/libtcmu_config.h
> -rw-r--r-- root/root     14266 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/libtcmu_log.c
> -rw-r--r-- root/root      3465 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/libtcmu_log.h
> -rw-r--r-- root/root      1883 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/libtcmu_priv.h
> -rw-r--r-- root/root      1263 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/libtcmu_time.c
> -rw-r--r-- root/root       943 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/libtcmu_time.h
> -rw-r--r-- root/root       167 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/main-syms.txt
> -rw-r--r-- root/root     29418 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/main.c
> -rw-r--r-- root/root       279 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/org.kernel.TCMUService1.service
> -rw-r--r-- root/root     41009 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/qcow.c
> -rw-r--r-- root/root       657 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/qcow.h
> -rw-r--r-- root/root     15262 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/qcow2.h
> -rw-r--r-- root/root     34771 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/rbd.c
> -rw-r--r-- root/root      5269 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/scsi_defs.h
> -rw-r--r-- root/root       144 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/string_priv.h
> -rw-r--r-- root/root      1599 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/strlcpy.c
> -rw-r--r-- root/root      8342 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/target.c
> -rw-r--r-- root/root      1117 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/target.h
> -rw-r--r-- root/root      3738 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/target_core_user_local.h
> -rw-r--r-- root/root      1058 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmu-handler.xml
> -rw-r--r-- root/root      1614 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmu-runner.8
> -rw-r--r-- root/root       486 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmu-runner.conf
> -rw-r--r-- root/root      4711 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmu-runner.h
> -rw-r--r-- root/root       232 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmu-runner.service
> -rw-r--r-- root/root      2713 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmu-runner.spec
> -rw-r--r-- root/root      5114 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmu-synthesizer.c
> -rw-r--r-- root/root       455 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmu.conf
> -rw-r--r-- root/root       119 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmu.conf_install.cmake.in
> -rw-r--r-- root/root      8560 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmur_aio.c
> -rw-r--r-- root/root      1765 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmur_aio.h
> -rw-r--r-- root/root     68476 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmur_cmd_handler.c
> -rw-r--r-- root/root      1818 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmur_cmd_handler.h
> -rw-r--r-- root/root      9301 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmur_device.c
> -rw-r--r-- root/root      2431 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/tcmur_device.h
> -rw-r--r-- root/root        94 2018-05-01 16:56
> tcmu-runner-1.3.0.54.g6684a21/version.h.in
> + STATUS=0
> + '[' 0 -ne 0 ']'
> + cd tcmu-runner-1.3.0.54.g6684a21
> + /usr/bin/chmod -Rf a+rX,u+w,g-w,o-w .
> + exit 0
> Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.GWofBw
> + umask 022
> + cd /root/tcmu-runner-orig/extra/rpmbuild/BUILD
> + cd tcmu-runner-1.3.0.54.g6684a21
> + /usr/bin/cmake -DSUPPORT_SYSTEMD=ON -DCMAKE_INSTALL_PREFIX=/usr .
> -- The C compiler identification is GNU 4.8.5
> -- Check for working C compiler: /bin/cc
> -- Check for working C compiler: /bin/cc -- works
> -- Detecting C compiler ABI info
> -- Detecting C compiler ABI info - done
> -- Found PkgConfig: /bin/pkg-config (found version "0.27.1")
> -- checking for module 'gio-unix-2.0'
> --   found gio-unix-2.0, version 2.50.3
> -- checking for module 'libkmod'
> --   found libkmod, version 20
> -- Found ZLIB: /usr/lib64/libz.so (found version "1.2.7")
> -- Looking for linux/falloc.h
> -- Looking for linux/falloc.h - found
> -- Configuring done
> -- Generating done
> -- Build files have been written to:
> /root/tcmu-runner-orig/extra/rpmbuild/BUILD/tcmu-runner-1.3.0.54.g6684a21
> + /usr/bin/make
> [  2%] Generating tcmuhandler-generated.c, tcmuhandler-generated.h
> Scanning dependencies of target tcmu
> [  5%] Building C object CMakeFiles/tcmu.dir/strlcpy.c.o
> [  8%] Building C object CMakeFiles/tcmu.dir/configfs.c.o
> [ 11%] Building C object CMakeFiles/tcmu.dir/api.c.o
> [ 14%] Building C object CMakeFiles/tcmu.dir/libtcmu.c.o
> [ 17%] Building C object CMakeFiles/tcmu.dir/libtcmu-register.c.o
> [ 20%] Building C object CMakeFiles/tcmu.dir/tcmuhandler-generated.c.o
> [ 22%] Building C object CMakeFiles/tcmu.dir/libtcmu_log.c.o
> [ 25%] Building C object CMakeFiles/tcmu.dir/libtcmu_config.c.o
> [ 28%] Building C object CMakeFiles/tcmu.dir/libtcmu_time.c.o
> Linking C shared library libtcmu.so
> [ 28%] Built target tcmu
> Scanning dependencies of target consumer
> [ 31%] Building C object CMakeFiles/consumer.dir/consumer.c.o
> Linking C executable consumer
> [ 31%] Built target consumer
> Scanning dependencies of target handler_file
> [ 34%] Building C object CMakeFiles/handler_file.dir/file_example.c.o
> Linking C shared library handler_file.so
> [ 34%] Built target handler_file
> Scanning dependencies of target handler_file_optical
> [ 37%] Building C object CMakeFiles/handler_file_optical.dir/file_optical.c.o
> Linking C shared library handler_file_optical.so
> [ 37%] Built target handler_file_optical
> Scanning dependencies of target handler_file_zbc
> [ 40%] Building C object CMakeFiles/handler_file_zbc.dir/file_zbc.c.o
> Linking C shared library handler_file_zbc.so
> [ 40%] Built target handler_file_zbc
> Scanning dependencies of target handler_glfs
> [ 42%] Building C object CMakeFiles/handler_glfs.dir/glfs.c.o
> Linking C shared library handler_glfs.so
> [ 42%] Built target handler_glfs
> Scanning dependencies of target handler_qcow
> [ 45%] Building C object CMakeFiles/handler_qcow.dir/qcow.c.o
> Linking C shared library handler_qcow.so
> [ 45%] Built target handler_qcow
> Scanning dependencies of target handler_rbd
> [ 48%] Building C object CMakeFiles/handler_rbd.dir/rbd.c.o
> Linking C shared library handler_rbd.so
> [ 48%] Built target handler_rbd
> Scanning dependencies of target tcmu-runner
> [ 51%] Building C object CMakeFiles/tcmu-runner.dir/tcmur_cmd_handler.c.o
> [ 54%] Building C object CMakeFiles/tcmu-runner.dir/tcmur_aio.c.o
> [ 57%] Building C object CMakeFiles/tcmu-runner.dir/tcmur_device.c.o
> [ 60%] Building C object CMakeFiles/tcmu-runner.dir/target.c.o
> [ 62%] Building C object CMakeFiles/tcmu-runner.dir/alua.c.o
> [ 65%] Building C object CMakeFiles/tcmu-runner.dir/main.c.o
> [ 68%] Building C object CMakeFiles/tcmu-runner.dir/tcmuhandler-generated.c.o
> Linking C executable tcmu-runner
> [ 71%] Built target tcmu-runner
> Scanning dependencies of target tcmu-synthesizer
> [ 74%] Building C object CMakeFiles/tcmu-synthesizer.dir/tcmu-synthesizer.c.o
> Linking C executable tcmu-synthesizer
> [ 74%] Built target tcmu-synthesizer
> Scanning dependencies of target tcmu_static
> [ 77%] Building C object CMakeFiles/tcmu_static.dir/strlcpy.c.o
> [ 80%] Building C object CMakeFiles/tcmu_static.dir/configfs.c.o
> [ 82%] Building C object CMakeFiles/tcmu_static.dir/api.c.o
> [ 85%] Building C object CMakeFiles/tcmu_static.dir/libtcmu.c.o
> [ 88%] Building C object CMakeFiles/tcmu_static.dir/libtcmu-register.c.o
> [ 91%] Building C object CMakeFiles/tcmu_static.dir/tcmuhandler-generated.c.o
> [ 94%] Building C object CMakeFiles/tcmu_static.dir/libtcmu_log.c.o
> [ 97%] Building C object CMakeFiles/tcmu_static.dir/libtcmu_config.c.o
> Linking C static library libtcmu_static.a
> [100%] Built target tcmu_static
> + exit 0
> Executing(%install): /bin/sh -e /var/tmp/rpm-tmp.0G5tey
> + umask 022
> + cd /root/tcmu-runner-orig/extra/rpmbuild/BUILD
> + '[' /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64
> '!=' / ']'
> + rm -rf /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64
> ++ dirname /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64
> + mkdir -p /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT
> + mkdir /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64
> + cd tcmu-runner-1.3.0.54.g6684a21
> + /usr/bin/make
> DESTDIR=/root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64
> install
> [ 28%] Built target tcmu
> [ 31%] Built target consumer
> [ 34%] Built target handler_file
> [ 37%] Built target handler_file_optical
> [ 40%] Built target handler_file_zbc
> [ 42%] Built target handler_glfs
> [ 45%] Built target handler_qcow
> [ 48%] Built target handler_rbd
> [ 71%] Built target tcmu-runner
> [ 74%] Built target tcmu-synthesizer
> [100%] Built target tcmu_static
> Install the project...
> -- Install configuration: ""
> -- Installing: /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/lib64/libtcmu.so.2
> -- Installing: /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/bin/tcmu-runner
> -- Removed runtime path from
> "/root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/bin/tcmu-runner"
> -- Installing: /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/lib64/tcmu-runner/handler_file_zbc.so
> -- Installing: /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/lib64/tcmu-runner/handler_rbd.so
> -- Installing: /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/lib64/tcmu-runner/handler_glfs.so
> -- Installing: /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/lib64/tcmu-runner/handler_qcow.so
> -- Installing: /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/share/dbus-1/system-services/org.kernel.TCMUService1.service
> -- Installing: /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/etc/dbus-1/system.d/tcmu-runner.conf
> -- Installing: /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/lib/systemd/system/tcmu-runner.service
> -- Installing: /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/share/man/man8/tcmu-runner.8
> + /usr/lib/rpm/find-debuginfo.sh --strict-build-id -m --run-dwz
> --dwz-low-mem-die-limit 10000000 --dwz-max-die-limit 110000000
> /root/tcmu-runner-orig/extra/rpmbuild/BUILD/tcmu-runner-1.3.0.54.g6684a21
> extracting debug info from
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/lib64/libtcmu.so.2
> extracting debug info from
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/lib64/tcmu-runner/handler_file_zbc.so
> extracting debug info from
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/lib64/tcmu-runner/handler_rbd.so
> extracting debug info from
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/lib64/tcmu-runner/handler_glfs.so
> extracting debug info from
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/lib64/tcmu-runner/handler_qcow.so
> extracting debug info from
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/bin/tcmu-runner
> dwz: Too few files for multifile optimization
> /usr/lib/rpm/sepdebugcrcfix: Updated 0 CRC32s, 6 CRC32s did match.
> + /usr/lib/rpm/check-buildroot
> + /usr/lib/rpm/redhat/brp-compress
> + /usr/lib/rpm/redhat/brp-strip-static-archive /usr/bin/strip
> + /usr/lib/rpm/brp-python-bytecompile /usr/bin/python 1
> + /usr/lib/rpm/redhat/brp-python-hardlink
> + /usr/lib/rpm/redhat/brp-java-repack-jars
> Processing files: tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64
> error: Directory not found:
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/etc/tcmu
> error: File not found:
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/etc/tcmu/tcmu.conf
> Executing(%doc): /bin/sh -e /var/tmp/rpm-tmp.hsRAbC
> + umask 022
> + cd /root/tcmu-runner-orig/extra/rpmbuild/BUILD
> + cd tcmu-runner-1.3.0.54.g6684a21
> + DOCDIR=/root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/share/doc/tcmu-runner-1.3.0.54.g6684a21
> + export DOCDIR
> + /usr/bin/mkdir -p
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/share/doc/tcmu-runner-1.3.0.54.g6684a21
> + cp -pr README.md
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/share/doc/tcmu-runner-1.3.0.54.g6684a21
> + cp -pr LICENSE
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/usr/share/doc/tcmu-runner-1.3.0.54.g6684a21
> + exit 0
>
>
> RPM build errors:
>     Directory not found:
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/etc/tcmu
>     File not found:
> /root/tcmu-runner-orig/extra/rpmbuild/BUILDROOT/tcmu-runner-1.3.0.54.g6684a21-0.el7.centos.x86_64/etc/tcmu/tcmu.conf
> -----
>
>
> On Tue, May 1, 2018 at 1:58 PM, Raghuram Devarakonda
> <draghuram@gmail.com> wrote:
>> Ok, thanks.
>>
>> On Tue, May 1, 2018 at 11:53 AM, Bryant G. Ly <bryantly@linux.ibm.com> wrote:
>>> On 5/1/18 10:48 AM, Raghuram Devarakonda wrote:
>>>
>>>> Hi,
>>>>
>>>> I am looking for tcmu-runner rpm to install on CentOS 7.4 but am not
>>>> able to find one. Here is some info about my repos:
>>>>
>>>> $ yum repo list
>>>> !base/7/x86_64                                  CentOS-7 - Base
>>>>                                                                9,591
>>>> !elrepo                                         ELRepo.org Community
>>>> Enterprise Linux Repository - el7                                  219
>>>> !epel/x86_64                                    Extra Packages for
>>>> Enterprise Linux 7 - x86_64
>>>> 12,507
>>>> !extras/7/x86_64                                CentOS-7 - Extras
>>>>                                                                  448
>>>> !ius/x86_64                                     IUS Community Packages
>>>> for Enterprise Linux 7 - x86_64                                  469
>>>> !updates/7/x86_64                               CentOS-7 - Updates
>>>>                                                                2,416
>>>> !zfs/x86_64                                     ZFS on Linux for EL7 -
>>>> dkms                                                             118
>>>>
>>>> $ yum search all tcmu
>>>> Loaded plugins: fastestmirror
>>>> Loading mirror speeds from cached hostfile
>>>>  * base: mirrors.advancedhosters.com
>>>>  * elrepo: iad.mirror.rackspace.com
>>>>  * epel: ewr.edge.kernel.org
>>>>  * extras: mirror.cogentco.com
>>>>  * ius: iad.mirror.rackspace.com
>>>>  * updates: mirrors.lga7.us.voxel.net
>>>> Warning: No matches found for: tcmu
>>>>
>>>> Do I need to add any other repo to get tcmu-runner?
>>>
>>> You need to build it yourself.
>>>
>>> Follow: https://github.com/open-iscsi/tcmu-runner
>>>
>>> -Bryant
>>>
