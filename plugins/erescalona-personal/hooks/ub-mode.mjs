// SessionStart: puts how to talk to erescalona and the ub-mode skill in the context of every session, and again
// after /clear or a compaction, so both are always loaded without anyone invoking them.
import { readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = process.env.CLAUDE_PLUGIN_ROOT || join(dirname(fileURLToPath(import.meta.url)), '..');
const talk = readFileSync(join(root, 'hooks', 'forma-de-hablar.md'), 'utf8').trim();
const skill = readFileSync(join(root, 'skills', 'ub-mode', 'SKILL.md'), 'utf8');
const ubMode = skill.replace(/^---\r?\n[\s\S]*?\r?\n---\r?\n/, '').trim();

process.stdout.write(
  `${talk}\n\n` +
    'The ub-mode skill is already loaded for this whole session: follow it in every change, without invoking it.\n\n' +
    `${ubMode}\n`
);
