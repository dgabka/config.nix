---
name: website-debug
description: Debug or analyze websites with Playwright. Use when the user asks to inspect a URL, debug browser/UI issues, capture screenshots, check console/network errors, or analyze page behavior/performance.
---

# Website Debug Skill

Use the local `playwright` CLI. Do **not** run `playwright install`; Nix provides the browsers. Set `URL='https://…'` before running the snippets.

## Safety

- Ask before logging into accounts, using credentials, submitting forms, making purchases, deleting data, or mutating production state.
- Prefer read-only navigation, screenshots, console logs, and network inspection.
- For local apps, use the user's provided URL; if missing, ask for it.

## Quick screenshot

```sh
out=/tmp/agent-web-debug
mkdir -p "$out"
playwright screenshot --full-page "$URL" "$out/page.png"
```

Then inspect `$out/page.png` as an image when visual debugging matters.

## Console/network/page probe

Use this for normal debugging. It captures console messages, page errors, failed requests, HTTP 4xx/5xx responses, page text, and a full-page screenshot.

```sh
out=/tmp/agent-web-debug
rm -rf "$out"
mkdir -p "$out"
cat > "$out/probe.spec.ts" <<'EOF'
import { test } from '@playwright/test';
import { mkdirSync, writeFileSync } from 'node:fs';

const url = process.env.TARGET_URL!;
const out = process.env.OUT_DIR || '/tmp/agent-web-debug';

test('website probe', async ({ page }) => {
  mkdirSync(out, { recursive: true });
  const data: any = {
    url,
    console: [],
    pageErrors: [],
    failedRequests: [],
    errorResponses: [],
  };

  page.on('console', msg => data.console.push({
    type: msg.type(),
    text: msg.text(),
    location: msg.location(),
  }));
  page.on('pageerror', err => data.pageErrors.push({
    message: err.message,
    stack: err.stack,
  }));
  page.on('requestfailed', req => data.failedRequests.push({
    method: req.method(),
    url: req.url(),
    failure: req.failure()?.errorText,
  }));
  page.on('response', res => {
    if (res.status() >= 400) data.errorResponses.push({
      status: res.status(),
      url: res.url(),
    });
  });

  const response = await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });
  await page.waitForLoadState('networkidle', { timeout: 10000 }).catch(() => {});

  data.status = response?.status();
  data.finalUrl = page.url();
  data.title = await page.title();
  data.textSample = (await page.locator('body').innerText({ timeout: 5000 }).catch(() => '')).slice(0, 5000);

  await page.screenshot({ path: `${out}/page.png`, fullPage: true });
  writeFileSync(`${out}/probe.json`, JSON.stringify(data, null, 2));
});
EOF
(cd "$out" && TARGET_URL="$URL" OUT_DIR="$out" playwright test probe.spec.ts --reporter=line)
```

Read `$out/probe.json` and, when useful, `$out/page.png`.

## Interaction

For clicks/forms, extend `probe.spec.ts` with the smallest selectors needed:

```ts
await page.getByRole('button', { name: 'Search' }).click();
await page.getByLabel('Email').fill('user@example.com');
```

Use role/label/text locators first. Avoid brittle CSS selectors unless there is no accessible locator.

## Optional performance scan

If `lighthouse` is installed, run:

```sh
lighthouse "$URL" --output=json --output-path=/tmp/agent-web-debug/lighthouse.json --chrome-flags="--headless"
```

If it is missing, skip it; Playwright evidence is enough for most debugging.
