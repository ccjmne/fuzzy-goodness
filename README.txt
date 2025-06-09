Revision: 3                      Fuzzy Goodness                     Éric NICOLAS
Date: 2025-06-04                 --------------

An eclectic collection of scripts and tricks that leverage fzf [1] to let me
sift through things.

Uses asciinema [2] for recordings.


find-contributors.sh ---------------------------------------- <no recording yet>

    Assists you in crediting contributors in your Git commits.

    I picked the trailers from the Linux kernel [3] that see the most usage,
    with an exception made for Co-authored-by to supplement Co-developed-by
    as the most eminently prominent alternative (not to say "the de-facto
    standard") since GitHub started recognising it in 2017 to credit
    multiple authors for a commit.

    Here are the foremost trailers (normalised for case) found across the
    ancestors of the tip of the kernel's master branch as of June 2025:

        2523341 Signed-off-by
         393276 Reviewed-by
         219653 Acked-by
          76803 Tested-by
          67211 Reported-by
          20302 Suggested-by
           7908 Co-developed-by

    Bindings ...................................................................

        Ctrl-R  Cycle through available trailers by order of their
                prominence through the Linux kernel repository.

    Dependencies ...............................................................

           Git  https://git-scm.com/

edit-service-groups.sh ------- https://asciinema.org/a/ms9qxEUyvH2onWnUJPOUuNoAg

    Conveniently and visually grep through a two-dimensional (svc x env)
    collection of service groups in a gigantic yaml file, edit a finely
    scoped partial view of it, and have it automagically merged back cleanly
    into the original document.  Behaves well even if your configuration
    entries are thousands of lines apart.

    Bindings ...................................................................

        Ctrl-R  Cycle through available environments (dev, minilive, live, all).

    Dependencies ...............................................................

        A text  https://www.vim.org/ or https://neovim.io/
        editor

            yq  https://github.com/kislyuk/yq
                Note: this script requires specifically *that* yq utility.  It
                is the one that's a mere wrapper around actual invocations of
                jq, not the lightweight, portable Go implementation that doesn't
                automatically benefit from all the jq features.


References ---------------------------------------------------------------------

- [1] fzf                                        https://github.com/junegunn/fzf
- [2] asciinema                           https://github.com/asciinema/asciinema
- [3] Linux kernel  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux

                                                          vim: tw=80 sw=4 et sta
