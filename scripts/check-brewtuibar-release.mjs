#!/usr/bin/env node
// Pre-publish guard: verifica que la release de GitHub para la versión actual
// de package.json contenga BrewTUI-Bar.app.zip + .sha256. Sin esto, `npm publish`
// puede liberar un brewtui-bar cuyo `install-brewtui-bar --force` apunta a una URL
// que devuelve 404 (caso v1.2.2: release creada sin assets).
//
// Bypass de emergencia: SKIP_BREWTUIBAR_CHECK=1 npm publish

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, resolve } from 'node:path';

if (process.env.SKIP_BREWTUIBAR_CHECK === '1' || process.env.SKIP_BREWBAR_CHECK === '1') {
  console.warn('⚠  SKIP_BREWTUIBAR_CHECK=1 — salto verificación de assets BrewTUI-Bar.');
  process.exit(0);
}

const __dirname = dirname(fileURLToPath(import.meta.url));
const pkg = JSON.parse(readFileSync(resolve(__dirname, '..', 'package.json'), 'utf8'));
const version = pkg.version;
const tag = `v${version}`;
const repo = 'MoLinesDesigns/BrewTUI-Bar';
const required = ['BrewTUI-Bar.app.zip', 'BrewTUI-Bar.app.zip.sha256'];

const url = `https://api.github.com/repos/${repo}/releases/tags/${tag}`;
const headers = { 'User-Agent': 'brewtui-bar-prepublish-guard', Accept: 'application/vnd.github+json' };
if (process.env.GITHUB_TOKEN) headers.Authorization = `Bearer ${process.env.GITHUB_TOKEN}`;

// La app y el CLI van siempre a la misma version. Se comprueba antes de mirar
// la release: si divergen, el 404 del tag de abajo apunta al sitio equivocado
// ("crea la release") en vez de a la causa real ("las versiones no coinciden").
// Fuente local si el repo de la app esta clonado, GitHub si no.
const appRepoPath = process.env.BREWTUI_APP_PATH || '/Volumes/SSD/xCode_Projects/BrewTUI-Bar';
let appVersion = null;
try {
  appVersion = JSON.parse(readFileSync(resolve(appRepoPath, 'package.json'), 'utf8')).version;
} catch {
  try {
    const r = await fetch(`https://raw.githubusercontent.com/${repo}/main/package.json`, { headers });
    if (r.ok) appVersion = (await r.json()).version;
  } catch {
    /* sin red: se deja pasar y decide la comprobacion de la release */
  }
}

if (appVersion && appVersion !== version) {
  console.error(`✘ El CLI (${version}) y la app (${appVersion}) tienen versiones distintas.`);
  console.error('  Deben publicarse siempre con el mismo numero.');
  console.error(`  Igualalas desde el repo de la app:  npm run version:set ${version}`);
  process.exit(1);
}

const fail = (msg) => {
  console.error(`✘ ${msg}`);
  console.error('  Runbook: notarizar BrewTUI-Bar y subir assets ANTES de npm publish.');
  console.error('    1. (cd menubar && tuist generate --no-open)');
  console.error('    2. NOTARY_PROFILE=brewbar-notary bash menubar/scripts/release.sh');
  console.error(`    3. gh release upload ${tag} menubar/build/BrewTUI-Bar.app.zip menubar/build/BrewTUI-Bar.app.zip.sha256 --repo ${repo}`);
  console.error('  Bypass de emergencia (no recomendado): SKIP_BREWTUIBAR_CHECK=1 npm publish');
  process.exit(1);
};

let res;
try {
  res = await fetch(url, { headers });
} catch (err) {
  fail(`No se pudo contactar con la API de GitHub: ${err.message}`);
}

if (res.status === 404) fail(`Release ${tag} no existe en ${repo}. Créala antes de npm publish.`);
if (!res.ok) fail(`GitHub API devolvió HTTP ${res.status} para ${url}.`);

const release = await res.json();
const names = new Set((release.assets ?? []).map((a) => a.name));
const missing = required.filter((n) => !names.has(n));
if (missing.length > 0) {
  fail(`Release ${tag} no contiene los assets requeridos: ${missing.join(', ')}.`);
}

console.log(`✓ Release ${tag} tiene los assets BrewTUI-Bar (${required.join(', ')}).`);
