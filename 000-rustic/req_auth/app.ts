import { createServer } from "node:http";
import type { IncomingMessage, ServerResponse } from "node:http";

// 載入 .env
process.loadEnvFile();

const PORT = Number(process.env.PORT ?? 9004);
const CLIENT_ID = process.env.CLIENT_ID ?? "";
const CLIENT_SECRET = process.env.CLIENT_SECRET ?? "";
const SCOPE = process.env.SCOPE ?? "";
const REDIRECT_URI = `http://127.0.0.1:${PORT}`;
const TOKEN_ENDPOINT = "https://oauth2.googleapis.com/token";

if (!CLIENT_ID) throw new Error("CLIENT_ID is required");
if (!CLIENT_SECRET) throw new Error("CLIENT_SECRET is required");
if (!SCOPE) throw new Error("SCOPE is required");

// 用 code 換 token
async function exchangeCode(code: string): Promise<Record<string, unknown>> {
    const body = new URLSearchParams({
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
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
server.listen(PORT, () => {
    // 組認證網址
    const authUrl = new URL("https://accounts.google.com/o/oauth2/v2/auth");
    authUrl.searchParams.set("scope", SCOPE);
    authUrl.searchParams.set("response_type", "code");
    authUrl.searchParams.set("redirect_uri", REDIRECT_URI);
    authUrl.searchParams.set("client_id", CLIENT_ID);
    console.log(`Listening on port ${PORT}`);
    console.log(`Auth URL:\n${authUrl.toString()}`);
});
