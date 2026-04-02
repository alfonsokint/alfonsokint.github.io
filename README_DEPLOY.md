Deploy & Test (GitHub Pages)
=============================

What I added
- A GitHub Actions workflow: `.github/workflows/deploy_and_optimize.yml` — runs on `workflow_dispatch` (manual) or on push to `main`/`master`. It installs `jpegoptim` and `pngquant`, runs `scripts/optimize_top_images.sh`, commits any optimized images, and publishes the repo root to the `gh-pages` branch.
- An image-optimization script: `scripts/optimize_top_images.sh` — finds the top N largest jpg/png files in `images/`, creates `.bak` backups, and optimizes them (lossless/near-lossy) when tools are available.

How to use
1. Push this repository to GitHub (if not already). The workflow will be available under Actions.
2. On GitHub, open the Actions tab → "Deploy & Optimize Static Site" and click "Run workflow" (or push to `main`). The workflow will:
   - Optimize up to 5 largest images (configurable by editing the workflow env TOP_N).
   - Commit any changed/optimized files back to the repository.
   - Deploy the repository root to the `gh-pages` branch.

Notes & safety
- The script creates `.bak` backups for each optimized image (next to the image). If an optimized file is worse, you can restore it from the `.bak`.
- The workflow uses the automatically provided `GITHUB_TOKEN` so no extra secrets are required. After the workflow runs it will push commits (from the bot) and create/update the `gh-pages` branch.
- If you prefer Netlify instead of GitHub Pages, I can add a `netlify.toml` and a GitHub Actions job that uses the Netlify CLI and a `NETLIFY_AUTH_TOKEN` secret.

Next recommended steps (pick one):
- I can finish normalizing the remaining percent-encoded filenames across the repo and run the workflow.
- Or I can trigger the workflow now (requires the repo to be pushed to GitHub so Actions can run). If you'd like that, tell me the GitHub repo URL or push the repo; I can provide the exact steps.

If you want me to proceed to run any of those next steps, say which one and I'll continue.
