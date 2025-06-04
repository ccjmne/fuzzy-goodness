Revision: 2                      Fuzzy Goodness                     Éric NICOLAS
Date: 2025-06-04                 --------------

An eclectic collection of scripts and tricks that leverage fzf [1] to let me
sift through things.

Uses asciinema [2] for recordings.


edit-service-groups.sh ------- https://asciinema.org/a/ms9qxEUyvH2onWnUJPOUuNoAg

    Conveniently and visually grep through a two-dimensional (svc x env)
    collection of service groups in a gigantic yaml file, edit a finely
    scoped partial view of it, and have it automagically merged back cleanly
    into the original document.  Behaves well even if your configuration
    entries are thousands of lines apart.


References ---------------------------------------------------------------------

- [1] fzf                                        https://github.com/junegunn/fzf
- [2] asciinema                           https://github.com/asciinema/asciinema

                                                          vim: tw=80 sw=4 et sta
