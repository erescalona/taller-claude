// PostToolUse on Write and Edit: formats the touched file with the project's own Prettier, run through Node
// so it works the same on Windows, macOS and Linux. Exit 2 hands Prettier's error back to Claude. A project
// without Prettier installed, a file outside the project, an ignored file or an unknown type is a no-op.
import { spawnSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import { isAbsolute, join, relative, resolve } from 'node:path';

let raw = '';
for await (const chunk of process.stdin) raw += chunk;
const input = JSON.parse(raw || '{}');

const root = process.env.CLAUDE_PROJECT_DIR || input.cwd || process.cwd();
const target = input.tool_input?.file_path;
if (!target) process.exit(0);

const file = resolve(root, target);
const inside = relative(root, file);
if (!inside || inside.startsWith('..') || isAbsolute(inside) || !existsSync(file)) process.exit(0);

const prettier = join(root, 'node_modules', 'prettier');
const manifest = join(prettier, 'package.json');
if (!existsSync(manifest)) process.exit(0);
const { bin } = JSON.parse(readFileSync(manifest, 'utf8'));
const cli = join(prettier, typeof bin === 'string' ? bin : bin.prettier);

const run = spawnSync(process.execPath, [cli, '--write', '--ignore-unknown', '--log-level', 'warn', file], {
  cwd: root,
  encoding: 'utf8',
});
if (run.status !== 0) {
  process.stderr.write(run.stderr || run.stdout || `Prettier could not format ${inside}.`);
  process.exit(2);
}
