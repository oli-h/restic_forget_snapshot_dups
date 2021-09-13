# A smarter `forget` for `restic` backup program
### Background
If you like/use [restic backup program](https://restic.net) then you
probably also know its command `restic forget --keep-xyz...`
which  helps cleaning old backups, keeping only the *last n ones per hour/day/week/month/year*.
See [appropriate restic documentation](https://restic.readthedocs.io/en/stable/060_forget.html#removing-snapshots-according-to-a-policy) for details.

### Different approach to *forget*
This bash-script here provides a different approach: It finds
**identical consecutive snapshots**, then forgets (i.e. deletes/removes)
the younger one.

### Under the hood
The script uses `restic snapshots --json`, pipes the (JSON)-result to `jq`
(see https://stedolan.github.io/jq/) and `sort` (by backup-path and -time)
to produces a plain text-listing which contains the [tree-hash](https://restic.readthedocs.io/en/stable/100_references.html#trees-and-data).
When two **consecutive snapshots** reference the **same tree hash** then we
know that the backup'd data is identical
The script finally forgets the second (later, younger) snapshot.

*(For safety reasons, the 'forget' command is commented out in the script - so it's a dry-run)*

Finally, only snapshots remain which *really* contains differences to the previous snapshot.

### Futher thoughts
- it would be good if `restic` itself would offer an option to *not* create a snapshot when no files changed
- you still can combine this script with the provided `forget`-policies of restic. 
Propose to run this script first as it removes useless snapshots
