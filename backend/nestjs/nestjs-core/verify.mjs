#!/usr/bin/env node
// nestjs-core 학습 사이트 검증: 상대 링크 무결성 + 레슨 필수 구조 요소.
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { join, dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = dirname(fileURLToPath(import.meta.url));

function walk(dir) {
  const out = [];
  for (const e of readdirSync(dir, { withFileTypes: true })) {
    const p = join(dir, e.name);
    if (e.isDirectory()) out.push(...walk(p));
    else if (e.name.endsWith('.html')) out.push(p);
  }
  return out;
}

const htmlFiles = walk(root);
let errors = 0;
const err = (f, msg) => { console.error(`✗ ${f.replace(root + '/', '')}: ${msg}`); errors++; };

for (const file of htmlFiles) {
  const html = readFileSync(file, 'utf8');
  const isIndex = file.endsWith('index.html');

  const cssMatch = html.match(/<link[^>]+href="([^"]+style\.css)"/);
  if (!cssMatch) err(file, 'missing style.css <link>');
  else if (!existsSync(resolve(dirname(file), cssMatch[1]))) err(file, `style.css not found: ${cssMatch[1]}`);

  for (const m of html.matchAll(/(?:href|src)="([^"]+)"/g)) {
    if (/^(https?:|mailto:|data:|#)/.test(m[1])) continue;
    const link = m[1].split('#')[0];
    if (!link) continue;
    if (!existsSync(resolve(dirname(file), link))) err(file, `broken link: ${link}`);
  }

  const need = isIndex
    ? ['class="topbar"', 'class="week"']
    : ['class="topbar"', 'class="summary"', 'class="goals"', 'class="qa"', 'class="pager"'];
  for (const n of need) if (!html.includes(n)) err(file, `missing element: ${n}`);
}

console.log(`\nChecked ${htmlFiles.length} HTML file(s). ${errors === 0 ? '✓ all passed' : `✗ ${errors} error(s)`}`);
process.exit(errors === 0 ? 0 : 1);
