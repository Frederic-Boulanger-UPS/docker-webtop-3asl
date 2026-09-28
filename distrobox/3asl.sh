# Setup for login shells in a distrobox (`distrobox enter`).
# In the webtop, /config/.bashrc does this instead. Under distrobox, HOME is
# the user's real home, so /init-config is never copied there by the
# entrypoint: the course configuration is copied here, without overwriting
# anything the user already has.
if [ -n "${CONTAINER_ID:-}" ] && [ "$HOME" != "/config" ]; then
	export OPAMROOT=/opt/opam
	case ":$PATH:" in
		*:/opt/opam/default/bin:*) ;;
		*) PATH="$PATH":'/opt/opam/default/bin'; export PATH ;;
	esac
	case ":$MANPATH:" in
		*:/opt/opam/default/man:*) ;;
		*) MANPATH="$MANPATH":'/opt/opam/default/man'; export MANPATH ;;
	esac

	# Provers known to Why3 (and to Frama-C's WP plugin)
	if [ ! -e "$HOME/.why3.conf" ] && [ -e /init-config/.why3.conf ]; then
		cp /init-config/.why3.conf "$HOME/.why3.conf"
	fi
	# Isabelle preferences, per Isabelle version
	for isabelle_dir in /init-config/.isabelle/*/; do
		[ -d "$isabelle_dir" ] || continue
		isabelle_version=$(basename "$isabelle_dir")
		if [ ! -e "$HOME/.isabelle/$isabelle_version" ]; then
			mkdir -p "$HOME/.isabelle"
			cp -r "$isabelle_dir" "$HOME/.isabelle/$isabelle_version"
		fi
	done
	unset isabelle_dir isabelle_version
fi
