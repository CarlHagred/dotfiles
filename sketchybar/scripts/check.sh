#!/usr/bin/env bash
# Static checks for the SketchyBar config (no extra tools needed):
#   1. every script passes `bash -n`
#   2. every $PLUGIN_DIR / $ITEM_DIR / $LIB_DIR path that is referenced exists
#   3. every variable that is used is defined, and every theme token is used
#   4. executable bits: entry scripts are executable, sourced libraries are not
#   5. indentation uses tabs
#   6. the Swift helper is built and up to date
# Run with --smoke to also reload SketchyBar and report new errors in its log.

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$CONFIG_DIR" || exit 1

FAILED=0
fail() {
	echo "  ✗ $1"
	FAILED=1
}
section() { echo "▸ $1"; }

SCRIPTS=(sketchybarrc theme.sh lib/*.sh items/*.sh plugins/*/*.sh scripts/*.sh)

section "syntax"
for f in "${SCRIPTS[@]}"; do
	bash -n "$f" 2>&1 | sed 's/^/    /' | grep . && fail "$f"
done

section "referenced files exist"
for f in "${SCRIPTS[@]}"; do
	while IFS= read -r ref; do
		path="$(echo "$ref" | sed -E 's#\$\{?PLUGIN_DIR\}?#plugins#; s#\$\{?ITEM_DIR\}?#items#; s#\$\{?LIB_DIR\}?#lib#')"
		path="${path%%[\" ]*}"
		[ -e "$path" ] || fail "$f references missing $path"
	done < <(grep -oE '\$\{?(PLUGIN_DIR|ITEM_DIR|LIB_DIR)\}?/[A-Za-z0-9_./-]+' "$f" | sort -u)
done

section "variables"
# Defined: any NAME= assignment, `read` targets and `for` variables, plus what SketchyBar,
# the shell and awk provide
DEFINED="$( (
	grep -hoE '(^|[^A-Za-z0-9_$])[A-Z][A-Z0-9_]*=' "${SCRIPTS[@]}"
	grep -hE '^[[:space:]]*(while |if )?read -r' "${SCRIPTS[@]}" | grep -oE '[A-Z][A-Z0-9_]*' | sed 's/$/=/'
	grep -hoE 'for [A-Z][A-Z0-9_]* in' "${SCRIPTS[@]}" | awk '{print $2"="}'
) | sed -E 's/^[^A-Z]*//; s/=$//' | sort -u)"
PROVIDED="NAME SENDER INFO BUTTON MODIFIER PERCENTAGE SCROLL_DELTA CONFIG_DIR HOME PATH TMPDIR FOCUSED BASH_SOURCE NF"
for f in "${SCRIPTS[@]}"; do
	for v in $(grep -oE '\$\{?[A-Z][A-Z0-9_]*' "$f" | tr -d '${' | sort -u); do
		echo "$DEFINED $PROVIDED" | tr ' ' '\n' | grep -qx "$v" || fail "$f uses undefined \$$v"
	done
done
for v in $(grep -hoE '^[A-Z][A-Z0-9_]*=' theme.sh lib/common.sh | tr -d '=' | sort -u); do
	[ "$(cat theme.sh lib/*.sh items/*.sh plugins/*/*.sh sketchybarrc | grep -cw "$v")" -gt 1 ] ||
		fail "$v is defined but never used"
done

section "permissions"
for f in sketchybarrc items/*.sh plugins/*/*.sh lib/popup_watch.sh scripts/*.sh; do
	[ -x "$f" ] || fail "$f should be executable"
done
for f in theme.sh lib/common.sh lib/style.sh lib/displays.sh lib/hover.sh lib/popups.sh; do
	[ -x "$f" ] && fail "$f is sourced and should not be executable"
done

section "indentation"
for f in "${SCRIPTS[@]}"; do
	grep -nE '^ +[^ ]' "$f" | grep -vE '^[0-9]+: +(#|\*)' | head -3 | sed "s|^|    $f:|" | grep . && fail "$f is indented with spaces"
done

section "helper"
if [ -x helpers/bin/sbhelper ]; then
	make -s -q -C helpers || fail "helpers/bin/sbhelper is out of date (run make -C helpers)"
else
	fail "helpers/bin/sbhelper is missing (run make -C helpers)"
fi

if [ "$1" = "--smoke" ]; then
	section "smoke test (reload)"
	LOG=/opt/homebrew/var/log/sketchybar/sketchybar.err.log
	before=$(wc -l <"$LOG" 2>/dev/null || echo 0)
	sketchybar --reload
	sleep 6
	# Both lines are printed by the tools themselves on every reload and are harmless
	new="$(tail -n +$((before + 1)) "$LOG" 2>/dev/null | grep -vE 'borders instance is already running|running as root is not allowed')"
	[ -n "$new" ] && {
		echo "$new" | sed 's/^/    /'
		fail "new errors in $LOG"
	}
	echo "  items: $(sketchybar --query bar | jq '.items | length')"
fi

[ "$FAILED" -eq 0 ] && echo "✓ all checks passed" || echo "✗ some checks failed"
exit "$FAILED"
