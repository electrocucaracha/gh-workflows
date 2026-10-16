// SPDX-license-identifier: Apache-2.0
import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { test } from "node:test";

const checker = new URL(
  "../.github/actions/setup-graphify/check-mcp.mjs",
  import.meta.url,
);
const server = `
  const { createInterface } = require("node:readline");
  let initialized = false;
  createInterface({ input: process.stdin }).on("line", (line) => {
    const request = JSON.parse(line);
    if (request.method === "notifications/initialized") {
      initialized = true;
      return;
    }
    let result;
    if (request.method === "initialize") {
      result = { serverInfo: { name: "graphify-test" } };
    } else if (request.method === "tools/list") {
      if (!initialized) process.exit(2);
      result = { tools: ["query_graph", "get_node", "get_neighbors", "shortest_path"]
        .filter((name) => process.env.SCENARIO !== "missing-tool" || name !== "query_graph")
        .map((name) => ({ name })) };
    } else if (request.method === "tools/call") {
      const { name, arguments: args } = request.params;
      if (name !== "query_graph" || !args.question || args.depth !== 1 || args.token_budget !== 200) process.exit(3);
      result = { content: [{ type: "text", text: "repository structure" }],
        isError: process.env.SCENARIO === "tool-error" };
      if (process.env.SCENARIO === "empty-result") result.content = [];
      if (process.env.SCENARIO === "early-exit") process.exit(1);
    } else {
      process.exit(4);
    }
    if (process.env.SCENARIO === "protocol-error" && request.id === 2) {
      console.log(JSON.stringify({ jsonrpc: "2.0", id: request.id, error: { code: -1, message: "discovery failed" } }));
    } else {
      console.log(JSON.stringify({ jsonrpc: "2.0", id: request.id, result }));
    }
  });
`;

for (const scenario of [
  "success",
  "missing-tool",
  "tool-error",
  "empty-result",
  "early-exit",
  "protocol-error",
]) {
  test(`MCP discovery and query: ${scenario}`, () => {
    const result = spawnSync(
      process.execPath,
      [checker.pathname, process.execPath, "-e", server],
      {
        env: { ...process.env, SCENARIO: scenario },
        encoding: "utf8",
        timeout: 5_000,
      },
    );
    assert.ifError(result.error);
    assert.equal(result.status, scenario === "success" ? 0 : 1, result.stderr);
    if (scenario === "success")
      assert.match(result.stdout, /query_graph succeeded/);
    else assert.match(result.stderr, /Error/);
  });
}

test("MCP executable missing fails explicitly", () => {
  const result = spawnSync(
    process.execPath,
    [checker.pathname, "/nonexistent/graphify-mcp"],
    {
      encoding: "utf8",
      timeout: 5_000,
    },
  );
  assert.ifError(result.error);
  assert.equal(result.status, 1);
  assert.match(result.stderr, /ENOENT/);
});
