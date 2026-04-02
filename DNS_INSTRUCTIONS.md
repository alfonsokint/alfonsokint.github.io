DNS notes & recommended records for deploying `www.alfonsokint.com`
===============================================================

Context
-------
You provided the prior DNS zone contents (many MX, TXT and various CNAMEs). Important: keep the MX records (Google Workspace) and TXT verification/SPF entries unless you plan to move email.

This file lists recommended DNS settings for two common free static hosts (GitHub Pages and Netlify) and how to preserve the existing email and verification records.

1) GitHub Pages (recommended simple workflow when publishing from this repo)
---------------------------------------------------------------------
- Add (or keep) these A records for the apex/root (@):

  Type: A
  Name: @
  Value: 185.199.108.153
  TTL: 3600

  Type: A
  Name: @
  Value: 185.199.109.153
  TTL: 3600

  Type: A
  Name: @
  Value: 185.199.110.153
  TTL: 3600

  Type: A
  Name: @
  Value: 185.199.111.153
  TTL: 3600

- For the `www` subdomain (recommended so canonical URL is www):

  Type: CNAME
  Name: www
  Value: <your-github-username>.github.io.
  TTL: 3600

  Note: After pointing DNS, set the custom domain in your repository Settings → Pages and enable HTTPS. GitHub will provision a certificate.

2) Netlify (alternative, automatic deploys + SSL + CDN)
-------------------------------------------------------
- In Netlify you get a `mysite.netlify.app` target. For Netlify, configure these DNS records:

  For `www`:
    Type: CNAME
    Name: www
    Value: <your-site>.netlify.app.

  For apex (`@`):
    Use an ALIAS / ANAME record if your DNS provider supports it, pointing `@` to `<your-site>.netlify.app`.
    If not supported, Netlify suggests using their load balancer IPs via A or using a DNS provider that supports ALIAS.

3) Preserve your email (MX) and verification TXT records
-------------------------------------------------------
- Keep the following MX records (Google Workspace) exactly as you have them so email keeps working:
  - MX 1 aspmx.l.google.com.
  - MX 3 alt1.aspmx.l.google.com.
  - MX 3 alt2.aspmx.l.google.com.
  - MX 5 aspmx2.googlemail.com.
  - MX 5 aspmx3.googlemail.com.
  - MX 5 aspmx4.googlemail.com.
  - MX 5 aspmx5.googlemail.com.

- Keep any existing verification TXT records (for Google Search Console or G Suite). Example you had:
  Type: TXT
  Name: @
  Value: "verificación-del-sitio-de-google=YMu0hszrdBJv2OHsv..."

4) Fix malformed/unclear records from the old list
-------------------------------------------------
- Your previous zone had some lines that look malformed (maybe from copy/paste):
  - `@ 10800 EN UN 155.133.132.3` likely should be `@ IN A 155.133.132.3` if you want that A record.
  - `@ 10800 EN YYYY 2001: 4b99: 1: 253 :: 3` looks like a broken IPv6 (AAAA) line; remove or fix it if not needed.
  - Make sure CNAME targets end with a dot in some DNS panels, or follow your registrar's UI guidance.

5) TTL and propagation
-----------------------
- Use a TTL of 3600 (1 hour) while testing. After everything is stable you can raise it (e.g., 10800).

6) After DNS changes
--------------------
- Wait for DNS propagation (minutes → hours depending on previous TTL).
- Verify:
  - `dig +short www.alfonsokint.com` should show either the CNAME target or the IPs (for apex A records).
  - `dig +short @8.8.8.8 TXT alfonsokint.com` to verify TXT values.

7) Want me to prepare the repo for a specific provider?
-----------------------------------------------------
- I can:
  - update `CNAME` file in the repo (for GitHub Pages) containing `www.alfonsokint.com`;
  - add a `netlify.toml` if you prefer Netlify (and instructions to create a site);
  - or produce the exact set of DNS records to paste into your DNS provider's UI.

Tell me which hosting provider you want (GitHub Pages or Netlify) and I will add the small repo file needed and give step-by-step DNS entries ready to paste.
