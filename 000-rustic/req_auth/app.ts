import { createServer } from "node:http";
import type { IncomingMessage, ServerResponse } from "node:http";

// 載入 .env
process.loadEnvFile();

const HTTP_PORT = Number(process.env.HTTP_PORT ?? 9004);
const GOOGLE_OAUTH_CLIENT_ID = process.env.GOOGLE_OAUTH_CLIENT_ID ?? "";
const GOOGLE_OAUTH_CLIENT_SECRET = process.env.GOOGLE_OAUTH_CLIENT_SECRET ?? "";
const GOOGLE_OAUTH_SCOPE = process.env.GOOGLE_OAUTH_SCOPE ?? "";
const REDIRECT_URI = `http://127.0.0.1:${HTTP_PORT}`;
const TOKEN_ENDPOINT = "https://oauth2.googleapis.com/token";

if (!GOOGLE_OAUTH_CLIENT_ID) throw new Error("GOOGLE_OAUTH_CLIENT_ID is required");
if (!GOOGLE_OAUTH_CLIENT_SECRET) throw new Error("GOOGLE_OAUTH_CLIENT_SECRET is required");
if (!GOOGLE_OAUTH_SCOPE) throw new Error("GOOGLE_OAUTH_SCOPE is required");

// 用 code 換 token
async function exchangeCode(code: string): Promise<Record<string, unknown>> {
    const body = new URLSearchParams({
        client_id: GOOGLE_OAUTH_CLIENT_ID,
        client_secret: GOOGLE_OAUTH_CLIENT_SECRET,
        code,
        grant_type: "authorization_code",
        redirect_uri: REDIRECT_URI,
    });

    const res = await fetch(TOKEN_ENDPOINT, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: body.toString(),
    });

    if (!res.ok) {
        const text = await res.text();
        throw new Error(`Token exchange failed (${res.status}): ${text}`);
    }

    return res.json() as Promise<Record<string, unknown>>;
}

// 處理 OAuth redirect callback
async function handler(req: IncomingMessage, res: ServerResponse) {
    const url = new URL(req.url ?? "/", REDIRECT_URI);

    // 忽略 favicon 等無關請求
    if (url.pathname !== "/") {
        res.writeHead(404).end();
        return;
    }

    const error = url.searchParams.get("error");
    if (error) {
        console.error("OAuth error:", error);
        res.writeHead(400, { "Content-Type": "text/plain" });
        res.end(`OAuth error: ${error}`);
        server.close();
        return;
    }

    const code = url.searchParams.get("code");
    if (!code) {
        res.writeHead(400, { "Content-Type": "text/plain" });
        res.end("Missing code parameter");
        return;
    }

    console.log("Got code, exchanging for token...");

    try {
        const token = await exchangeCode(code);
        const pretty = JSON.stringify(token, null, 2);
        console.log("Token response:\n", pretty);
        res.writeHead(200, { "Content-Type": "application/json" });
        res.end(pretty);
    } catch (err) {
        console.error(err);
        res.writeHead(500, { "Content-Type": "text/plain" });
        res.end(String(err));
    }

    server.close();
}

// 啟動
const server = createServer(handler);
server.listen(HTTP_PORT, () => {
    // 組認證網址
    const authUrl = new URL("https://accounts.google.com/o/oauth2/v2/auth");
    authUrl.searchParams.set("scope", GOOGLE_OAUTH_SCOPE);
    authUrl.searchParams.set("response_type", "code");
    authUrl.searchParams.set("redirect_uri", REDIRECT_URI);
    authUrl.searchParams.set("client_id", GOOGLE_OAUTH_CLIENT_ID);
    console.log(`Listening on port ${HTTP_PORT}`);
    console.log(`Auth URL:\n${authUrl.toString()}`);
});
