// SPDX-license-identifier: Apache-2.0
import { spawn } from "node:child_process";
import { once } from "node:events";
import { createInterface } from "node:readline";

const [command = "graphify-mcp", ...args] = process.argv.slice(2);
const child = spawn(command, args.length ? args : ["graphify-out/graph.json"], {
  stdio: ["pipe", "pipe", "inherit"],
});
const lines = createInterface({ input: child.stdout })[Symbol.asyncIterator]();
let failure;
child.on("error", (error) => {
  failure = error;
  child.stdout.destroy();
});
child.stdin.on("error", (error) => {
  failure = error;
  child.stdout.destroy();
});
const timer = setTimeout(() => {
  failure = new Error("Graphify MCP check timed out after 30 seconds");
  child.kill();
}, 30_000);

function send(message) {
  child.stdin.write(`${JSON.stringify({ jsonrpc: "2.0", ...message })}\n`);
}

async function response(id) {
  for (;;) {
    const { value, done } = await lines.next();
    if (done)
      throw failure ?? new Error("Graphify MCP exited before responding");
    const message = JSON.parse(value);
    if (message.id !== id) continue;
    if (message.error) throw new Error(JSON.stringify(message.error));
    if (!message.result)
      throw new Error(`Missing MCP result for request ${id}`);
    return message.result;
  }
}

try {
  await once(child, "spawn");
  send({
    id: 1,
    method: "initialize",
    params: {
      protocolVersion: "2025-03-26",
      capabilities: {},
      clientInfo: { name: "graphify-check", version: "1.0" },
    },
  });
  const initialized = await response(1);
  if (!initialized.serverInfo?.name)
    throw new Error("Missing MCP server identity");
  send({ method: "notifications/initialized" });
  send({ id: 2, method: "tools/list", params: {} });
  const { tools } = await response(2);
  for (const name of [
    "query_graph",
    "get_node",
    "get_neighbors",
    "shortest_path",
  ]) {
    if (!tools?.some((tool) => tool.name === name)) {
      throw new Error(`Graphify did not advertise ${name}`);
    }
  }
  send({
    id: 3,
    method: "tools/call",
    params: {
      name: "query_graph",
      arguments: {
        question: "repository structure",
        depth: 1,
        token_budget: 200,
      },
    },
  });
  const result = await response(3);
  if (
    result.isError ||
    !result.content?.some((item) => item.type === "text" && item.text)
  ) {
    throw new Error(`Graphify query failed: ${JSON.stringify(result)}`);
  }
  console.log(
    "Graphify MCP: initialized, four navigation tools discovered, query_graph succeeded.",
  );
} catch (error) {
  console.error(error);
  process.exitCode = 1;
} finally {
  clearTimeout(timer);
  child.stdin.end();
  child.kill();
}
