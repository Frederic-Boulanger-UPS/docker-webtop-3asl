cat - >> /init-config/.bashrc << "==END=="
export OPAMROOT=/opt/opam
# Current opam switch man dir
MANPATH="$MANPATH":'/opt/opam/default/man'; export MANPATH;
# Binary dir for opam switch default
PATH="$PATH":'/opt/opam/default/bin'; export PATH;
==END==
chmod +x /init-config/.bashrc

cat - >> /init-config/.why3.conf << "==END=="
[main]
default_editor = "xdg-open %f"
magic = 14
memlimit = 1000
running_provers_max = 2
timelimit = 5.000000

[partial_prover]
name = "Alt-Ergo"
path = "/opt/opam/default/bin/alt-ergo"
version = "2.6.2"
==END==
