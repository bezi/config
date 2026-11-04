# How I Work

Who I am - for the purposes of any place where they ask about the user or who it
is, use `bezi`, not `oscar`.  When pretending to be me, such as in a local
testing of a UI, always select Oscar Bezi as a user, don't use other people.

## Test-driven
Write tests first. Watch them fail. Write the code. Watch them pass. Use
judgement to determine what is a useful test - if adding configuration as code,
adding explicit testing for that configuration is redundant.  Prefer end-to-end
testing over assertions on simple functions.

## Do not comment as me
Do not ever comment as me on Jira or Github - I communicate with my peers
directly.  PR bodies are acceptable since that is a work output.

## Use GH Stack
Use the `gh stack` cli instead of manually restacking PRs or managing branches.
When putting up PRs, consider that it is now very easy to break out no-ops and
restructures: heavily bias towards moving bulk renames, breaking up large files,
etc into behavioral no-op stacked PRs before the meaty change.

## How I like my PRs

**Title:** A short, plain-English sentence describing what the change does.

**Body:** Follow this shape exactly. The goal is "a reviewer can reconstruct
what changed and why from the body alone."

1. **tl;dr line.** One sentence. Answers "which PR am I looking at again?" —
   what it unlocks + the scope tag (full-stack, UI-only, API-only, infra, etc.).
No details. Examples:
   - `tl;dr — A full-stack PR that fixes some odd behavior with module configs.`
   - `tl;dr — A UI PR that adds polish to the module configs overview.`

2. **3–4 bullet workflow summary.** Each bullet describes a *workflow*
   delivered, not a file touched. Example:
   - New logic for fooing the bar.
   - UI button on X interface surfacing that logic.

3. **Algorithm + data-model walk-through.** The main event of the body. Call out
   the important algorithms and data-model changes in this PR — not necessarily
one section per bullet from #2. Some bullets won't need their own write-up; one
algorithm may span multiple bullets. Cover the contents *algorithmically* — what
does the code actually do, step by step. For edits, **always frame as Before /
After**, e.g.:
   > **Before:** To fry an egg, we cracked it, beat it, salted it, then cooked
   > over low heat.
   > **After:** We now liquefy the eggs in the shell, salt with osmosis, then
   > steam and crack them.

   Go longer when the change warrants it — this section earns its length by
   being precise about behavior.

4. **Production follow-ups, if any.** Backfills to run, endpoints to hit
   post-deploy, intentional breakage ("this orphans the old `foo_bar` rows —
that's fine"). Omit the section if there's nothing to call out.

5. **Screenshots, if any UI surface is touched.** Don't skip just because the PR
   is server-side — ask whether the change is *surfaced* anywhere (an admin
view, a status badge, a log panel, an error message a user will see). If yes,
include a screenshot.

**Skip the fluff.** No "added N tests," no "ran the full suite," no "verified
end-to-end." Test coverage belongs as a workflow bullet (#2). The
body is for reconstructing the change, not narrating the process.

## Nucleus test runs — keep them small
The full `mito_api` suite is too big to run locally, and several Claude
sessions often run in parallel clones (Nucleus3/4/5/...). Three overlapping
`pytest -n auto` runs once took 33 workers on 11 cores, filled RAM and swap,
and brought the machine to a crawl.

- **Never run the full suite locally.** Run only the tests for the code you
  touched: `uv run pytest path/to/test_file.py` or `-k <expr>`. CI runs the
  full suite, so let `get-ci-to-pass` cover everything else. This overrides
  `apps/mito_api/AGENTS.md`'s "run the full suite before pushing" — never do
  that locally.
- **Never use `-n auto`.** If a targeted run needs parallelism, cap it at
  `-n 4`.
- **Check for other test runs first.** Before you start one, run
  `pgrep -fl 'pytest'`. If another clone's run is in progress, wait for it or
  run yours serially.
