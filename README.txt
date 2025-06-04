Revision: 3                      Fuzzy Goodness                     Éric NICOLAS
Date: 2025-06-04                 --------------

An eclectic collection of scripts and tricks that leverage fzf [1] to let me
sift through things.

Uses asciinema [2] for recordings.


find-contributors.sh ---------------------------------------- <no recording yet>

    Assists you in crediting contributors while creating your Git commit.

    I picked the trailers from logs of the Linux kernel [3] that see the
    most usage.  I however replaced Co-developed-by by Co-authored-by
    as it is the most eminently prominent alternative (to not say "the
    de-facto standard") since GitHub started recognising it in 2017 to
    credit multiple authors for a commit.

    For reference, here are the foremost trailers (normalised for case)
    found across the commits reachable from the tip of the kernel's master
    branch as of June 2025:

        2523341 Signed-off-by
         393276 Reviewed-by
         219653 Acked-by
          76803 Tested-by
          67211 Reported-by
          20302 Suggested-by
           7908 Co-developed-by


edit-service-groups.sh ------- https://asciinema.org/a/ms9qxEUyvH2onWnUJPOUuNoAg

    Conveniently and visually grep through a two-dimensional (svc x env)
    collection of service groups in a gigantic yaml file, edit a finely
    scoped partial view of it, and have it automagically merged back cleanly
    into the original document.  Behaves well even if your configuration
    entries are thousands of lines apart.


References ---------------------------------------------------------------------

- [1] fzf                                        https://github.com/junegunn/fzf
- [2] asciinema                           https://github.com/asciinema/asciinema
- [3] Linux kernel  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux

                                                          vim: tw=80 sw=4 et sta
